//
//  SDMaskView.m
//  SDMask
//
//  Created by MeterWhite on 2019/11/15.
//  Copyright © 2019 Meterwhite. All rights reserved.
//

#import <objc/runtime.h>
#import "SDMaskController.h"
#import "SDMaskProtocol.h"
#import "SDMaskModel.h"
#import "SDMaskView.h"

@implementation SDMaskView
{
    SDMaskUserBlock _userViewDidLoadBlock;
    SDMaskUserBlock _userViewPresentationWillAnimateBlock;
    SDMaskUserBlock _userViewPresentationDoAnimationsBlock;
    SDMaskUserBlock _userViewPresentationCompletedBlock;
    SDMaskUserBlock _userViewDismissionWillAnimateBlock;
    SDMaskUserBlock _userViewDismissionDoAnimationsBlock;
    SDMaskUserBlock _userViewDismissionCompletedBlock;
}
@synthesize userView= _userView;
@synthesize model   = _model;
#pragma mark - Core
- (void)show
{
    if(!self.model.container) return;
    /// Frame layout
    [self.model.container addSubview:self];
    self.frame = [self.model.container bounds];
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
    }];
    /// Animation for mask
    self.alpha = 0.0;
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)dismiss:(id)obj
{
    if(obj == self && !self.model.autoDismiss) return;
    [self dismiss];
}

- (void)dismiss
{
    SDMaskUserBlock willAnimate      = _userViewDismissionWillAnimateBlock;
    SDMaskUserBlock willDoneAnimate  = _userViewDismissionDoAnimationsBlock;
    SDMaskUserBlock completeAnimate  = _userViewDismissionCompletedBlock;
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
    }];
}

#pragma mark - View
- (instancetype)initWithUserView:(UIView *)view
{
    if(self = [super init]) {
        _userView = view;
        _model = [[SDMaskModel alloc] initWithUserView:view forMask:self];
        [self setBackgroundColor:SDMaskModel.defaultBackgroundColor];
        [self addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        [view setAutoresizingMask:UIViewAutoresizingNone];
        [self setAutoresizingMask:UIViewAutoresizingNone];
    }
    return self;
}

#pragma mark - System animation
- (void)systemAnimate:(SDMaskAnimationStyle)animation presentElseDismiss:(BOOL)presentElseDismiss willElseDo:(BOOL)willElseDo
{
    CGRect  desRect             = self.userView.bounds;
    CGFloat desAlphaForUserView = 0.0;
    switch (animation) {
        case SDMaskAnimationAlert:
        {
            if(willElseDo){
                if(!self.model.isUsingAutolayout){
                    desRect.origin = CGPointMake(SDMaskModel.screenWidth*0.5 - desRect.size.width*0.5, SDMaskModel.screenHeight*0.5 - desRect.size.height*0.5);
                    self.userView.frame = desRect;
                }
            }
            if(willElseDo == presentElseDismiss) {
                desAlphaForUserView = 0.6;
            } else {
                desAlphaForUserView = 1.0;
            }
            self.userView.alpha = desAlphaForUserView;
        }
            break;
        case SDMaskAnimationActionSheet:
        {
            if(self.model.isUsingAutolayout) {
                NSNumber* userHeight = [self.model valueForKeyPath:@"_autolayoutKeyConstraints.height.constant"];
                NSLayoutConstraint* bottom = [self.model valueForKeyPath:@"_autolayoutKeyConstraints.bottom"];
                NSLayoutConstraint* bottomAnimation = [self.model valueForKeyPath:@"_autolayoutKeyConstraints.bottomAnimation"];
                if(userHeight){
                    /// Height animation
                    if(presentElseDismiss == willElseDo) {
                        bottom.constant = (bottom.firstItem == self.userView ? 1.0 : -1.0) * userHeight.floatValue;
                    } else {
                        bottom.constant = 0.0;
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
                    desRect.origin  = CGPointMake(SDMaskModel.screenWidth*0.5 - desRect.size.width*0.5, SDMaskModel.screenHeight);
                } else {
                    desRect.origin = CGPointMake(SDMaskModel.screenWidth*0.5 - desRect.size.width*0.5, SDMaskModel.screenHeight - desRect.size.height);
                }
                self.userView.frame = desRect;
            }
        }
            break;
    }
}

#pragma mark - Bind events
- (id<SDMask>)bindEventForControls:(NSArray<UIView *> *)bindingInfo
{
    IMP imp = class_getMethodImplementation(SDMaskController.class, @selector(bindEventForControls:));
    return ((id(*)(id,SEL,id))imp)(self, @selector(bindEventForControls:), bindingInfo);
}

- (id<SDMask>)bindEventForCancelControl:(id)control
{
    IMP imp = class_getMethodImplementation(SDMaskController.class, @selector(bindEventForCancelControl:));
    return ((id(*)(id,SEL,id))imp)(self, @selector(bindEventForCancelControl:), control);
}

- (id<SDMask>)bindingEventFor:(id)indexer usingBlock:(SDMaskUserBindingEventBlock)block
{
    IMP imp = class_getMethodImplementation(SDMaskController.class, @selector(bindingEventFor:usingBlock:));
    return ((id(*)(id,SEL,id,id))imp)(self, @selector(bindingEventFor:usingBlock:), indexer, block);
}

- (id<SDMask>)bindingEventsUsingBlock:(SDMaskUserBindingEventBlock)block
{
    IMP imp = class_getMethodImplementation(SDMaskController.class, @selector(bindingEventsUsingBlock:));
    return ((id(*)(id,SEL,id))imp)(self, @selector(bindingEventsUsingBlock:), block);
}

#pragma mark - Setter & Getter
- (UIView *)userView
{
    return _userView;
}

- (SDMaskModel *)model
{
    return _model;
}

- (id<SDMask>)userViewDidLoad:(SDMaskUserBlock)block
{
    _userViewDidLoadBlock = [block copy];
    return self;
}

- (id<SDMask>)userViewPresentationWillAnimate:(SDMaskUserBlock)block
{
    _userViewPresentationWillAnimateBlock = [block copy];
    return self;
}

- (id<SDMask>)userViewPresentationDoAnimations:(SDMaskUserBlock)block
{
    _userViewPresentationDoAnimationsBlock = [block copy];
    return self;
}

- (id<SDMask>)userViewPresentationCompleted:(SDMaskUserBlock)block
{
    _userViewPresentationCompletedBlock = [block copy];
    return self;
}

- (id<SDMask>)userViewDismissionWillAnimate:(SDMaskUserBlock)block
{
    _userViewDismissionWillAnimateBlock = [block copy];
    return self;
}

- (id<SDMask>)userViewDismissionDoAnimations:(SDMaskUserBlock)block
{
    _userViewDismissionDoAnimationsBlock = [block copy];
    return self;
}

- (id<SDMask>)userViewDismissionCompleted:(SDMaskUserBlock)block
{
    _userViewDismissionCompletedBlock = [block copy];
    return self;
}

- (id<SDMask>)usingAutoDismiss
{
    _model.autoDismiss = YES;
    return self;
}

- (id<SDMask>)disableSystemAnimation
{
    _model.usingSystemAnimation = NO;
    return self;
}

@end
