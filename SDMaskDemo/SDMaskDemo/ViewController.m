//
//  ViewController.m
//  SDMask
//
//  Created by MeterWhite on 16/1/29.
//  Copyright © 2016年 MeterWhite. All rights reserved.
//

#import "TUserActionSheet.h"
#import "TUserAlertView.h"
#import "ViewController.h"
#import "Masonry.h"
#import "SDMask.h"

@interface ViewController ()
@end

/**
 * Edit scheme switch debuge and release to observe differences.
 */
@implementation ViewController

#pragma mark - User demos
- (void)demoBegin
{
    /// User view is content view in mask view.
    TUserActionSheet* userView;
    
    /// This is mask view.It controls all.
    /// There are tow way to begin.
    /// 1. Begin with userView and wrap it with generics.
    SDMaskUserView(userView);
    /// 2. Begin with view's owner and wrap it with generics.
    SDMaskWith(self, userView);/// Owner is controller
    SDMaskWith(self.view, userView);/// Owner is controller's view
}

- (void)demoSimple
{
    TUserActionSheet* userView;
    [SDMaskUserView(userView) sdm_showActionSheetUsingBlock:^(SDMask<TUserActionSheet *> * _Nonnull mask) {
        /// Frame layout : Set size
        mask.userView.frame = CGRectNull;
        /// User work.
        [userView didTapSomething:^{
            /// ...
            [mask dismiss];
        }];
    }];
}

- (void)demoBindEvents
{
    TUserActionSheet* userView;
    [SDMaskUserView(userView) sdm_showActionSheetIn:self.view usingBlock:^(SDMask<TUserActionSheet *> * _Nonnull mask) {
        /// Bind cancel button
        [mask bindEventForCancelControl:userView.actionCancel_1];
        /// Bind other controls
        [mask bindEventForControls:@[userView.action0, [userView.action1 sdm_userViewWithBindingKey:@"$"]]];
        ///Handle binding events
        [mask bindingEventsUsingBlock:^(SDMaskBindingEvent<TUserActionSheet *> * _Nonnull event) {
            /// Use mark key.
            if([event.key isEqualToString:@"$"]){
                /// ...
                return;
            }
            /// Or use index.
            switch (event.index) {
                case 0:
                    /// ...
                    break;
                default:
                    break;
            }
        }];
    }];
}

- (void)demoCustomAnimation
{
    TUserActionSheet* userView;
    [SDMaskUserView(userView) sdm_showAlertUsingBlock:^(SDMask<TUserActionSheet *> * _Nonnull mask) {
        [[[[mask userViewPresentationWillAnimate:^(SDMaskModel<TUserActionSheet *> * _Nonnull model) {
            model.userView.frame = CGRectNull;
        }] userViewPresentationDoAnimations:^(SDMaskModel<TUserActionSheet *> * _Nonnull model) {
            model.userView.frame = CGRectNull;
        }] userViewDismissionDoAnimations:^(SDMaskModel<TUserActionSheet *> * _Nonnull model) {
            model.userView.frame = CGRectNull;
        }] disableSystemAnimation];
    }];
}

- (void)demoUsingMask
{
    TUserActionSheet* userView;
    SDMask<TUserActionSheet*>* mask = SDMaskWith(self, userView);
    mask.model.animte = SDMaskAnimationActionSheet;
    mask.model.autoDismiss = YES;
    [mask userViewDidLoad:^(SDMaskModel<TUserActionSheet *> * _Nonnull model) {
        /// Layout...
    }];
    /// Bind events
    [mask bindEventForCancelControl:userView.actionCancel_1];
    /// ...
    /// ...
    [mask show];
}

- (void)demoCircularReference
{
    /// Wrong:
    UIButton* cancle;
    SDMask* outMask;
    [outMask userViewDidLoad:^(SDMaskModel * _Nonnull model) {
        [outMask bindEventForCancelControl:cancle];/// Referenc the out value.
    }];
    /// Reason: mask -> block(userViewDidLoad) -> mask
}


#pragma mark - Lib test
#pragma mark - Frame layout
- (IBAction)actionAlert:(id)sender {
    UIView* userView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
    [userView setBackgroundColor:UIColor.whiteColor];
#ifdef DEBUG
    [userView sdm_showAlertUsingBlock:^(SDMask<UIView*>* mask) {
        [mask.model setAutoDismiss:YES];
        /// Configuration...
    }];
#else
    /// Custom animation
    [SDMaskUserView(userView) sdm_showAlertIn:self.view usingBlock:^(SDMask<UIView*>* mask) {
        [[[[[mask userViewPresentationWillAnimate:^(SDMaskModel<UIView*> * model) {
            CGRect frame = userView.frame;
            frame.origin = CGPointMake(0, 0);
            userView.frame = frame;
        }] userViewPresentationDoAnimations:^(SDMaskModel<UIView*>*  model) {
            CGRect frame = userView.frame;
            frame.origin = CGPointMake(SDMaskModel.screenWidth - 280, SDMaskModel.screenHeight - 150);
            userView.frame = frame;
        }] userViewDismissionDoAnimations:^(SDMaskModel<UIView*>* model) {
            CGRect frame = userView.frame;
            frame.origin = CGPointMake(0, 0);
            userView.frame = frame;
        }] usingAutoDismiss] disableSystemAnimation];
    }];
#endif
}

- (IBAction)actionActionSheet:(UIButton *)sender {
    UIView* userView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 180)];
    [userView setBackgroundColor:UIColor.whiteColor];
#ifdef DEBUG
    [userView sdm_showActionSheetUsingBlock:nil];
#else
    [[userView sdm_showActionSheetIn:self.view usingBlock:nil] usingAutoDismiss];
#endif
    
    {
//        TUserAlertView* userView = [[NSBundle mainBundle] loadNibNamed:@"TUserAlertView" owner:nil options:nil].firstObject;
//        userView.frame = CGRectMake(0, 200, 100, 100);
//        SDMask* mask = SDMaskWith(self.view, userView);
////        mask.model.animte = SDMaskAnimationRightPush;
//        mask.model.animte = SDMaskAnimationRightPush;
//        [mask userViewDidLoad:^(SDMaskModel * _Nonnull model) {
//            model.setAutolayoutValueForKey(@(0), @"right");
////            model.setAutolayoutValueForKey(@(0), @"left");
////            model.setAutolayoutValueForKey(@(150), @"width");
//            model.setAutolayoutValueForKey(@(150), @"height");
//            model.setAutolayoutValueForKey(@(0), @"centerY");
//        }];
//        [mask usingAutoDismiss];
//        [mask show];
    }
}

#pragma mark - SDAutolayout
- (IBAction)sdAutolayoutAlert:(id)sender {
    TUserAlertView* userView = [[NSBundle mainBundle] loadNibNamed:@"TUserAlertView" owner:nil options:nil].firstObject;
#ifdef DEBUG
    SDMask<TUserAlertView*>* mask = SDMaskWith(self.view, userView);
#else
    SDMask<TUserAlertView*>* mask = SDMaskWith(self, userView);
#endif
    [mask userViewDidLoad:^(SDMaskModel<TUserAlertView*> *model) {
        model.animte = SDMaskAnimationAlert;
        model.
        setAutolayoutValueForKey(@(0), @"centerX").
        setAutolayoutValueForKey(@(0), @"centerY").
        setAutolayoutValueForKey(@(50), @"left").
        setAutolayoutValueForKey(@(50), @"right");
    }];
    [[mask bindEventForControls:@[userView.action0, userView.cancelButton_1]] bindingEventsUsingBlock:^(SDMaskBindingEvent<TUserAlertView*> * event) {
        switch (event.index) {
            case 0:
            {
                NSLog(@"Click action0");
            }
                break;
            case 1:
            {
                NSLog(@"Click cancel,but mask be kept.");
                [event setNeedKeepMask];
            }
                break;
        }
    }];
    [mask usingAutoDismiss];
    [mask show];
}

- (IBAction)sdAutolayoutSheet:(id)sender {
    TUserActionSheet* userView = [[NSBundle mainBundle] loadNibNamed:@"TUserActionSheet" owner:nil options:nil].firstObject;
#ifdef DEBUG
    SDMask* mask = self.view.sdm_maskWith(userView);
#else
    SDMask* mask = self.sdm_maskWith(userView);
#endif
    [mask userViewDidLoad:^(SDMaskModel<TUserActionSheet*> * _Nonnull model) {
        model.animte = SDMaskAnimationActionSheet;
        model.
        setAutolayoutValueForKey(@(0), @"bottom").
        setAutolayoutValueForKey(@(15), @"left").
        setAutolayoutValueForKey(@(15), @"right").
        setAutolayoutValueForKey(@(350), @"height");
    }];
    [[[mask bindEventForControls:@[userView.action0, userView.action1]] bindEventForCancelControl:userView.actionCancel_1] bindingEventsUsingBlock:^(SDMaskBindingEvent<TUserActionSheet*> *event) {
        switch (event.index) {
            case -1:
            {
                NSLog(@"Click cancel");
            }
                break;
            case 0:
            {
                NSLog(@"Click action0");
            }
                break;
            case 1:
            {
                NSLog(@"Click action1");
            }
                break;
        }
    }];
    [[mask usingAutoDismiss] show];
}

#pragma mark - User autolayout
- (IBAction)userAutolayoutAlert:(id)sender {
    TUserAlertView* userView = [[NSBundle mainBundle] loadNibNamed:@"TUserAlertView" owner:nil options:nil].firstObject;
#ifdef DEBUG
    SDMask* mask = self.view.sdm_alertMaskWith(userView);
#else
    SDMask* mask = self.sdm_alertMaskWith(userView);
#endif
    [mask userViewDidLoad:^(SDMaskModel<TUserAlertView*> *model) {
        model.animte = SDMaskAnimationAlert;
        [model.userView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(model.superview);
            make.left.equalTo(model.superview.mas_left).offset(20);
            make.right.equalTo(model.superview.mas_right).offset(-20);
        }];
    }];
    [[[mask bindEventForCancelControl:userView.cancelButton_1] usingAutoDismiss] show];
}

- (IBAction)userAutolayoutSheet:(id)sender {
    TUserActionSheet* userView = [[NSBundle mainBundle] loadNibNamed:@"TUserActionSheet" owner:nil options:nil].firstObject;
#ifdef DEBUG
    SDMask<TUserActionSheet*>* mask = self.view.sdm_maskWith(userView);
    mask.model.container = self.view;
    [mask userViewDidLoad:^(SDMaskModel *model) {
        model.animte = SDMaskAnimationActionSheet;
    }];
#else
    SDMask*  mask = self.sdm_maskWith(userView);
#endif
    [mask userViewDidLoad:^(SDMaskModel<TUserActionSheet*> * model) {
        model.animte = SDMaskAnimationActionSheet;
        [model.userView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(model.superview.mas_bottom).priorityHigh();
            make.left.equalTo(model.superview.mas_left).offset(15).priorityHigh();
            make.right.equalTo(model.superview.mas_right).offset(-15).priorityHigh();
        }];
    }];
    [[[mask bindEventForCancelControl:userView.actionCancel_1] usingAutoDismiss] show];
}

@end
