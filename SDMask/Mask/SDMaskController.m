//
//  SDMaskView.h
//  MeterWhite
//
//  Created by MeterWhite on 16/1/6.
//  Copyright © 2016年 MeterWhite. All rights reserved.
//

#import "SDMaskBindingEvent.h"
#import "UIResponder+SDMask.h"
#import "SDMaskController.h"
#import "SDMaskModel.h"

@interface SDMaskController ()

@end

@implementation SDMaskController
{
    SDMaskUserBlock _userViewDidLoadBlock;
    SDMaskUserBlock _userViewPresentationWillAnimateBlock;
    SDMaskUserBlock _userViewPresentationDoAnimationsBlock;
    SDMaskUserBlock _userViewPresentationCompletedBlock;
    SDMaskUserBlock _userViewDismissionWillAnimateBlock;
    SDMaskUserBlock _userViewDismissionDoAnimationsBlock;
    SDMaskUserBlock _userViewDismissionCompletedBlock;
}
@synthesize userView    = _userView;
@synthesize model       = _model;

#pragma mark - Core
- (void)show
{
    if(!self.model.container) {
        self.model.container = self.model.currentController;
    }
    if(!self.model.container) return;
    [self.model.container presentViewController:self animated:YES completion:nil];
}

- (void)dismiss:(id)obj
{
    if(obj == self.view && !self.model.autoDismiss) return;
    [self dismiss];
}

- (void)dismiss
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Controller

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setModalPresentationStyle:UIModalPresentationOverFullScreen];
        [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    }
    return self;
}

- (void)loadView
{
    UIButton* newView = [UIButton buttonWithType:UIButtonTypeCustom];
    [newView setBackgroundColor:SDMaskModel.defaultBackgroundColor];
    [newView addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    self.view = newView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userView.autoresizingMask  = UIViewAutoresizingNone;
    self.view.autoresizingMask      = UIViewAutoresizingNone;
    [self.view addSubview:self.userView];
    if(_userViewDidLoadBlock) _userViewDidLoadBlock(self.model);
    if(self.model.isUsingAutolayout) [self.model performSelector:@selector(updateConstraints)];
}

- (void)beginAppearanceTransition:(BOOL)isAppearing animated:(BOOL)animated
{
    SDMaskUserBlock willAnimate      = nil;
    SDMaskUserBlock willDoneAnimate  = nil;
    SDMaskUserBlock completeAnimate  = nil;
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
    }];
    [super beginAppearanceTransition:isAppearing animated:animated];
}

#pragma mark - View
- (instancetype)initWithUserView:(UIView *)view
{
    if(self = [self init]) {
        _userView = view;
        _model = [[SDMaskModel alloc] initWithUserView:view forMask:self];
    }
    return self;
}

#pragma mark - System animation
- (void)systemAnimate:(SDMaskAnimationStyle)animation presentElseDismiss:(BOOL)presentElseDismiss willElseDo:(BOOL)willElseDo
{
    CGRect  desRect    = self.userView.bounds;
    CGFloat desAlpha   = 0.0;
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
                /// Will show alert animation & Did show dismiss animation.
                desAlpha    = 0.6;
            } else {
                desAlpha    = 1.0;
            }
            self.userView.alpha = desAlpha;
        }
            break;
        case SDMaskAnimationActionSheet:
        {
            /// - Autolayout
            if(self.model.isUsingAutolayout) {
                NSNumber* userHeight = [self.model valueForKeyPath:@"_autolayoutKeyConstraints.height.constant"];
                NSLayoutConstraint* bottom = [self.model valueForKeyPath:@"_autolayoutKeyConstraints.bottom"];
                NSLayoutConstraint* bottomAnimation = [self.model valueForKeyPath:@"_autolayoutKeyConstraints.bottomAnimation"];
                if(userHeight){
                    /// Height animation
                    if(presentElseDismiss == willElseDo) {
                        bottom.constant = (bottom.firstItem == self.userView ? 1.0 : -1.0) * userHeight.floatValue;
                    } else {
                        bottom.constant = [[self.model valueForKeyPath:@"_autolayoutKeyValues.bottom"] floatValue];
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
                    desRect.origin = CGPointMake(SDMaskModel.screenWidth*0.5 - desRect.size.width*0.5, SDMaskModel.screenHeight);
                }else{
                    desRect.origin = CGPointMake(SDMaskModel.screenWidth*0.5 - desRect.size.width*0.5, SDMaskModel.screenHeight - desRect.size.height);
                }
                [self.model setValue:@(NO) forKey:@"_isUsingAutolayout"];
                self.userView.frame = desRect;
            }
        }
            break;
    }
}

#pragma mark - Bind events
- (id<SDMask>)bindEventForControls:(NSArray<UIView *> *)bindingInfo
{
    NSMutableArray* bindings = [NSMutableArray array];
    [bindingInfo enumerateObjectsUsingBlock:^(UIView * item, NSUInteger idx, BOOL * stop) {
        if(item.userInteractionEnabled == NO) [item setUserInteractionEnabled:YES];
        SDMaskBindingEvent* event = [[SDMaskBindingEvent alloc] initWithSender:item model:self.model atIndex:idx];
        [bindings addObject:event];
    }];
    if(bindings.count){
        [self.model setValue:[bindings copy] forKey:@"_bindingEvents"];
    }
    return self;
}

- (id<SDMask>)bindEventForCancelControl:(id)control
{
     SDMaskBindingEvent* event = [[SDMaskBindingEvent alloc] initWithSender:control model:self.model atIndex:-1];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if([control respondsToSelector:@selector(addTarget:action:forControlEvents:)]){
        [control addTarget:event action:@selector(actionTap:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:event action:@selector(actionTap:)];
        [control addGestureRecognizer:tap];
    }
#pragma clang diagnostic pop
    if(![control isUserInteractionEnabled]) [control setUserInteractionEnabled:YES];
    [self.model setValue:event forKey:@"_cancelEvent"];
    return self;
}

- (id<SDMask>)bindingEventsUsingBlock:(SDMaskUserBindingEventBlock)block
{
    [self.model setValue:block forKey:@"_blockForBindingEventsUsingBlock"];
    return self;
}

- (id<SDMask>)bindingEventFor:(id)indexer usingBlock:(SDMaskUserBindingEventBlock)block
{
    NSMutableDictionary* dic = [self.model valueForKey:@"_blockForBindingEventForUsingBlock"];
    if(!dic){
        dic = [NSMutableDictionary dictionary];
        [self.model setValue:dic forKey:@"_blockForBindingEventForUsingBlock"];
    }
    dic[indexer] = block;
    return self;
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
