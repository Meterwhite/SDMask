//
//  SDMaskView.m
//  SDMask
//
//  Created by MeterWhite on 2019/11/15.
//  Copyright © 2019 Meterwhite. All rights reserved.
//

#import "NSLayoutConstraint+SDMask.h"
#import "SDMaskController.h"
#import "SDMaskProtocol.h"
#import <objc/runtime.h>
#import "SDMaskModel.h"
#import "SDMaskView.h"

@interface SDMaskView ()
@property UIView *userView;
@end

@implementation SDMaskView
{
    SDMaskUserBlock _userViewDidLoadBlock;
    SDMaskUserBlock _userViewDidDisappear;
    SDMaskUserBlock _userViewPresentationWillAnimateBlock;
    SDMaskUserBlock _userViewPresentationDoAnimationsBlock;
    SDMaskUserBlock _userViewPresentationCompletedBlock;
    SDMaskUserBlock _userViewDismissionWillAnimateBlock;
    SDMaskUserBlock _userViewDismissionDoAnimationsBlock;
    SDMaskUserBlock _userViewDismissionCompletedBlock;
}
@synthesize userView = _userView;
@synthesize model    = _model;
#pragma mark - Core
- (void)show {
    if(!self.model.maskOwner) return;
    /// Frame layout
    [self.model.maskOwner addSubview:self];
    self.frame = [self.model.maskOwner bounds];
    [self addSubview:self.model.userView];
    if(_userViewDidLoadBlock) _userViewDidLoadBlock(self.model);
    if(self.model.isUsingAutolayout) [self.model performSelector:@selector(updateConstraints)];
    SDMaskUserBlock willAnimate      = _userViewPresentationWillAnimateBlock;
    SDMaskUserBlock willDoneAnimate  = _userViewPresentationDoAnimationsBlock;
    SDMaskUserBlock completeAnimate  = _userViewPresentationCompletedBlock;
    if(!self.model.usingSystemAnimation && willDoneAnimate == nil) return;
    /// Animation for content
    if(self.model.usingSystemAnimation) [self systemAnimate:self.model.animte presentElseDismiss:true willElseDo:true];
    if(willAnimate) willAnimate(self.model);
    [UIView animateWithDuration:self.model.presentTime animations:^{
        if(self.model.usingSystemAnimation) [self systemAnimate:self.model.animte presentElseDismiss:true willElseDo:false];
        if(willDoneAnimate) willDoneAnimate(self.model);
    } completion:^(BOOL finished) {
        if(completeAnimate) completeAnimate(self.model);
        if(self.model.dismissDelayTime > 0) [self dismiss:nil];
    }];
    /// Animation for mask
    self.alpha = 0.0;
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)dismiss:(id)obj {
    if(obj == self && !self.model.autoDismiss) return;
    if(self.model.dismissDelayTime > 0){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.model.dismissDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
        });
    }else{
        [self dismiss];
    }
}

- (void)dismiss {
    SDMaskUserBlock willAnimate      = _userViewDismissionWillAnimateBlock;
    SDMaskUserBlock willDoneAnimate  = _userViewDismissionDoAnimationsBlock;
    SDMaskUserBlock completeAnimate  = _userViewDismissionCompletedBlock;
    SDMaskUserBlock didDisappear     = _userViewDidDisappear;
    if(!self.model.usingSystemAnimation && willDoneAnimate == nil) return;
    /// Animation for content
    if(self.model.usingSystemAnimation) [self systemAnimate:self.model.animte presentElseDismiss:false willElseDo:true];
    if(willAnimate) willAnimate(self.model);
    [UIView animateWithDuration:self.model.dismissTime animations:^{
        if(self.model.usingSystemAnimation) [self systemAnimate:self.model.animte presentElseDismiss:false willElseDo:false];
        if(willDoneAnimate) willDoneAnimate(self.model);
    } completion:^(BOOL finished) {
        if(completeAnimate) completeAnimate(self.model);
    }];
    /// Animation for mask
    self.alpha = 1.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if(didDisappear) didDisappear(self.model);
    }];
}

#pragma mark - View
- (instancetype)initWithUserView:(UIView *)uView {
    if(self = [super init]) {
        _userView = uView;
        _model = [[SDMaskModel alloc] initWithUserView:uView forMask:(id)self];
        if(self.model.backgroundColor){
            [self setBackgroundColor:self.model.backgroundColor];
        }else{
            [self setBackgroundColor:SDMaskModel.defaultBackgroundColor];
        }
        [self addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        [uView setAutoresizingMask:UIViewAutoresizingNone];
        [self setAutoresizingMask:UIViewAutoresizingNone];
    }
    return self;
}

#pragma mark - System animation
- (void)systemAnimate:(SDMaskAnimationStyle)animation presentElseDismiss:(BOOL)presentElseDismiss willElseDo:(BOOL)willElseDo {
    CGRect  deBounds= self.userView.bounds;
    CGRect  deFrame = self.userView.frame;
    CGFloat deAlpha = 0.0;
    switch (animation) {
        case SDMaskAnimationAlert:
        case SDMaskAnimationHUD:
        {
            if(willElseDo){
                if(!self.model.isUsingAutolayout){
                    deBounds.origin = CGPointMake(SDMaskModel.screenWidth*0.5 - deBounds.size.width*0.5, SDMaskModel.screenHeight*0.5 - deBounds.size.height*0.5);
                    self.userView.frame = deBounds;
                }
            }
            if(willElseDo == presentElseDismiss) {
                deAlpha = 0.8;
            } else {
                deAlpha = 1.0;
            }
            self.userView.alpha = deAlpha;
        }
            break;
        case SDMaskAnimationSheet:
        {
            if(self.model.isUsingAutolayout) {
                NSNumber *userHeight = [self.model valueForKeyPath:@"_autolayoutKeyConstraints.height.constant"];
                NSLayoutConstraint *bottom = [self.model valueForKeyPath:@"_autolayoutKeyConstraints.bottom"];
                NSLayoutConstraint *bottomAnimation = [self.model valueForKeyPath:@"_autolayoutKeyConstraints.bottomAnimation"];
                if(userHeight){
                    /// Height animation
                    if(presentElseDismiss == willElseDo) {
                        [bottom takeConstantSnapshot];
                        bottom.constant = (bottom.firstItem == self.userView ? 1.0 : -1.0) * userHeight.floatValue;
                    } else {
                        bottom.constant = bottom.constantSnapshot;
                    }
                } else {
                    /// Bottom switch to top animation
                    if(presentElseDismiss == willElseDo) {
                        [bottom setActive:NO];
                        [bottomAnimation setActive:YES];
                    } else {
                        [bottom setActive:YES];
                        [bottomAnimation setActive:NO];
                    }
                }
                [self setNeedsLayout];
                [self layoutIfNeeded];
            } else {
                if(willElseDo == presentElseDismiss) {
                    deBounds.origin  = CGPointMake(SDMaskModel.screenWidth*0.5 - deBounds.size.width*0.5, SDMaskModel.screenHeight);
                } else {
                    deBounds.origin = CGPointMake(SDMaskModel.screenWidth*0.5 - deBounds.size.width*0.5, SDMaskModel.screenHeight - deBounds.size.height);
                }
                self.userView.frame = deBounds;
            }
        }
            break;
        case SDMaskAnimationLeftPush:
        case SDMaskAnimationRightPush:
        {
            /// - Autolayout
            if(self.model.isUsingAutolayout) {
                NSNumber *userWidth = [self.model valueForKeyPath:@"_autolayoutKeyConstraints.width.constant"];
                NSString *dDes = animation == SDMaskAnimationLeftPush ? @"left" : @"right";
                NSLayoutConstraint *hor = [self.model valueForKeyPath:[NSString stringWithFormat:@"_autolayoutKeyConstraints.%@",dDes]];
                NSLayoutConstraint *horAnimation = [self.model valueForKeyPath:[NSString stringWithFormat:@"_autolayoutKeyConstraints.%@Animation",dDes]];
                if(userWidth){
                    /// Push animation
                    if(presentElseDismiss == willElseDo) {
                        CGFloat l = (hor.firstItem == self.userView ? -1.0 : 1.0) * userWidth.floatValue;
                        if(animation == SDMaskAnimationRightPush) l = -l;
                        [hor takeConstantSnapshot];
                        hor.constant = l;
                    } else {
                        hor.constant = hor.constantSnapshot;
                    }
                } else {
                    /// Bottom switch to top animation
                    if(presentElseDismiss == willElseDo) {
                        [hor setActive:NO];
                        [horAnimation setActive:YES];
                    } else {
                        [hor setActive:YES];
                        [horAnimation setActive:NO];
                    }
                }
                [self setNeedsLayout];
                [self layoutIfNeeded];
            }
            /// - Frame layout
            else {
                if(willElseDo == presentElseDismiss) {
                    CGFloat x = animation == SDMaskAnimationLeftPush ? - deFrame.size.width : SDMaskModel.screenWidth;
                    deFrame.origin = CGPointMake(x, deFrame.origin.y);
                    /// Hide
                }else{
                    CGFloat x = animation == SDMaskAnimationLeftPush ? 0 : SDMaskModel.screenWidth - deBounds.size.width;
                    deFrame.origin = CGPointMake(x, deFrame.origin.y);
                }
                [self.model setValue:@(NO) forKey:@"_isUsingAutolayout"];
                self.userView.frame = deFrame;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - Bind events
- (id<SDMaskProtocol>)bindEventForControls:(NSArray<UIView *> *)bindingInfo {
    IMP imp = class_getMethodImplementation(SDMaskController.class, @selector(bindEventForControls:));
    return ((id(*)(id,SEL,id))imp)(self, @selector(bindEventForControls:), bindingInfo);
}

- (id<SDMaskProtocol>)bindEventForCancelControl:(id)control {
    IMP imp = class_getMethodImplementation(SDMaskController.class, @selector(bindEventForCancelControl:));
    return ((id(*)(id,SEL,id))imp)(self, @selector(bindEventForCancelControl:), control);
}

- (id<SDMaskProtocol>)bindingEventFor:(id)indexer usingBlock:(SDMaskUserBindingEventBlock)block {
    IMP imp = class_getMethodImplementation(SDMaskController.class, @selector(bindingEventFor:usingBlock:));
    return ((id(*)(id,SEL,id,id))imp)(self, @selector(bindingEventFor:usingBlock:), indexer, block);
}

- (id<SDMaskProtocol>)bindingEventsUsingBlock:(SDMaskUserBindingEventBlock)block {
    IMP imp = class_getMethodImplementation(SDMaskController.class, @selector(bindingEventsUsingBlock:));
    return ((id(*)(id,SEL,id))imp)(self, @selector(bindingEventsUsingBlock:), block);
}

#pragma mark - Setter & Getter
- (UIView *)userView {
    return _userView;
}

- (SDMaskModel *)model {
    return _model;
}

- (id<SDMaskProtocol>)userViewDidLoad:(SDMaskUserBlock)block {
    _userViewDidLoadBlock = [block copy];
    return self;
}

- (id<SDMaskProtocol>)userViewDidDisappear:(SDMaskUserBlock)block {
    _userViewDidDisappear = [block copy];
    return self;
}

- (id<SDMaskProtocol>)userViewPresentationWillAnimate:(SDMaskUserBlock)block {
    _userViewPresentationWillAnimateBlock = [block copy];
    return self;
}

- (id<SDMaskProtocol>)userViewPresentationDoAnimations:(SDMaskUserBlock)block {
    _userViewPresentationDoAnimationsBlock = [block copy];
    return self;
}

- (id<SDMaskProtocol>)userViewPresentationCompleted:(SDMaskUserBlock)block {
    _userViewPresentationCompletedBlock = [block copy];
    return self;
}

- (id<SDMaskProtocol>)userViewDismissionWillAnimate:(SDMaskUserBlock)block {
    _userViewDismissionWillAnimateBlock = [block copy];
    return self;
}

- (id<SDMaskProtocol>)userViewDismissionDoAnimations:(SDMaskUserBlock)block {
    _userViewDismissionDoAnimationsBlock = [block copy];
    return self;
}

- (id<SDMaskProtocol>)userViewDismissionCompleted:(SDMaskUserBlock)block {
    _userViewDismissionCompletedBlock = [block copy];
    return self;
}

- (id<SDMaskProtocol>)usingAutoDismiss {
    _model.autoDismiss = YES;
    return self;
}

- (id<SDMaskProtocol>)disableSystemAnimation {
    _model.usingSystemAnimation = NO;
    return self;
}

@end
