//
//  SDMaskView.h
//  SDMask
//
//  Created by MeterWhite on 16/1/6.
//  Copyright © 2016年 MeterWhite. All rights reserved.
//

#import "NSLayoutConstraint+SDMask.h"
#import "SDMaskNotificationName.h"
#import "SDMaskBindingEvent.h"
#import "UIResponder+SDMask.h"
#import "SDMaskController.h"
#import "SDMaskModel.h"

@interface SDMaskController ()
@property UIView *userView;
@end

@implementation SDMaskController
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
    UIViewController *presenter = self.model.maskOwner ?: self.model.associatedWindow.rootViewController;
    [self.model.associatedWindow makeKeyAndVisible];
    [presenter presentViewController:self animated:YES completion:nil];
}

- (void)dismiss:(id)obj {
    if(obj == self.view && !self.model.autoDismiss) return;
    if(self.model.dismissDelayTime > 0){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.model.dismissDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
        });
    }else{
        [self dismiss];
    }
}

- (void)dismiss {
    UIViewController *presenter = self.model.maskOwner ?: self.model.associatedWindow.rootViewController;
    [presenter dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Controller

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setModalPresentationStyle:UIModalPresentationOverFullScreen];
        [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    }
    return self;
}

- (void)loadView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if(self.model.backgroundColor){
        [button setBackgroundColor:self.model.backgroundColor];
    }else{
        [button setBackgroundColor:SDMaskModel.defaultBackgroundColor];
    }
    [button addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    self.view = button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.userView setAutoresizingMask:UIViewAutoresizingNone];
    [self.view setAutoresizingMask:UIViewAutoresizingNone];
    [self.view addSubview:self.userView];
    if(_userViewDidLoadBlock) _userViewDidLoadBlock(self.model);
    if(self.model.isUsingAutolayout) [self.model performSelector:@selector(updateConstraints)];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if(self->_userViewDidDisappear){
        self->_userViewDidDisappear(self.model);
    }
}

- (void)beginAppearanceTransition:(BOOL)isAppearing animated:(BOOL)animated {
    SDMaskUserBlock willAnimate      = nil;
    SDMaskUserBlock willDoneAnimate  = nil;
    SDMaskUserBlock completeAnimate  = nil;
    __block BOOL    appearing        = isAppearing;
    if(self.isBeingPresented) {
        willAnimate     = _userViewPresentationWillAnimateBlock;
        willDoneAnimate = _userViewPresentationDoAnimationsBlock;
        completeAnimate = _userViewPresentationCompletedBlock;
    } else if (self.isBeingDismissed) {
        willAnimate     = _userViewDismissionWillAnimateBlock;
        willDoneAnimate = _userViewDismissionDoAnimationsBlock;
        completeAnimate = _userViewDismissionCompletedBlock;
    }
    if(!self.model.usingSystemAnimation && willDoneAnimate == nil) return;
    [self systemAnimate:self.model.animte presentElseDismiss:self.isBeingPresented willElseDo:true];
    if(willAnimate) willAnimate(self.model);
    [UIView animateWithDuration:self.isBeingPresented ? self.model.presentTime : self.model.dismissTime animations:^{
        [self systemAnimate:self.model.animte presentElseDismiss:self.isBeingPresented willElseDo:false];
        if(willDoneAnimate) willDoneAnimate(self.model);
    } completion:^(BOOL finished) {
        if(completeAnimate) completeAnimate(self.model);
        if(appearing && self.model.dismissDelayTime > 0) [self dismiss:nil];
    }];
    [super beginAppearanceTransition:isAppearing animated:animated];
}

#pragma mark - View
- (instancetype)initWithUserView:(UIView *)uView {
    if(self = [self init]) {
        _userView = uView;
        _model = [[SDMaskModel alloc] initWithUserView:uView forMask:(id)self];
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
                /// Will show alert animation & Did show dismiss animation.
                deAlpha = 0.8;
            } else {
                deAlpha = 1.0;
            }
            self.userView.alpha = deAlpha;
        }
            break;
        case SDMaskAnimationSheet:
        {
            /// - Autolayout
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
                        /**
                         * bottom.constant = [[self.model valueForKeyPath:@"_autolayoutKeyValues.bottom"] floatValue];
                         * The fowlloed code is berter.
                         */
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
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
            }
            /// - Frame layout
            else {
                if(willElseDo == presentElseDismiss) {
                    deBounds.origin = CGPointMake(SDMaskModel.screenWidth*0.5 - deBounds.size.width*0.5, SDMaskModel.screenHeight);
                }else{
                    deBounds.origin = CGPointMake(SDMaskModel.screenWidth*0.5 - deBounds.size.width*0.5, SDMaskModel.screenHeight - deBounds.size.height);
                }
                [self.model setValue:@(NO) forKey:@"_isUsingAutolayout"];
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
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
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
    NSMutableArray *bindings = [NSMutableArray array];
    [bindingInfo enumerateObjectsUsingBlock:^(UIView * item, NSUInteger idx, BOOL * stop) {
        if(item.userInteractionEnabled == NO) [item setUserInteractionEnabled:YES];
        SDMaskBindingEvent *event = [[SDMaskBindingEvent alloc] initWithSender:item model:self.model atIndex:idx];
        [bindings addObject:event];
    }];
    if(bindings.count){
        [self.model setValue:[bindings copy] forKey:@"_bindingEvents"];
    }
    return self;
}

- (id<SDMaskProtocol>)bindEventForCancelControl:(id)control {
     SDMaskBindingEvent *event = [[SDMaskBindingEvent alloc] initWithSender:control model:self.model atIndex:-1];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if([control respondsToSelector:@selector(addTarget:action:forControlEvents:)]){
        [control addTarget:event action:@selector(actionTap:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:event action:@selector(actionTap:)];
        [control addGestureRecognizer:tap];
    }
#pragma clang diagnostic pop
    if(![control isUserInteractionEnabled]) [control setUserInteractionEnabled:YES];
    [self.model setValue:event forKey:@"_cancelEvent"];
    return self;
}

- (id<SDMaskProtocol>)bindingEventsUsingBlock:(SDMaskUserBindingEventBlock)block {
    [self.model setValue:block forKey:@"_blockForBindingEventsUsingBlock"];
    return self;
}

- (id<SDMaskProtocol>)bindingEventFor:(id)indexer usingBlock:(SDMaskUserBindingEventBlock)block {
    NSMutableDictionary *dic = [self.model valueForKey:@"_blockForBindingEventForUsingBlock"];
    if(!dic){
        dic = [NSMutableDictionary dictionary];
        [self.model setValue:dic forKey:@"_blockForBindingEventForUsingBlock"];
    }
    dic[indexer] = block;
    return self;
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
