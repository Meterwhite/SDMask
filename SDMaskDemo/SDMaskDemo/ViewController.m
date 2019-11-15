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

#pragma mark - Frame layout
- (IBAction)actionAlert:(id)sender {
    UIView* userView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
    [userView setBackgroundColor:UIColor.whiteColor];
#ifdef DEBUG
    [userView sdm_showAlertUsingBlock:^(id<SDMask>  _Nonnull mask) {
        [mask.model setAutoDismiss:YES];
        /// Configuration...
    }];
#else
    /// Custom animation
    [userView sdm_showAlertIn:self.view usingBlock:^(id<SDMask> mask) {
        [[[[[mask userViewPresentationWillAnimate:^(SDMaskModel * model) {
            CGRect frame = userView.frame;
            frame.origin = CGPointMake(0, 0);
            userView.frame = frame;
        }] userViewPresentationDoAnimations:^(SDMaskModel * model) {
            CGRect frame = userView.frame;
            frame.origin = CGPointMake(SDMaskModel.screenWidth - 280, SDMaskModel.screenHeight - 150);
            userView.frame = frame;
        }] userViewDismissionDoAnimations:^(SDMaskModel * model) {
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
    [userView sdm_showActionSheetIn:self.view usingBlock:nil];
#endif
}

#pragma mark - SDAutolayout
- (IBAction)sdAutolayoutAlert:(id)sender {
    TUserAlertView* userView = [[NSBundle mainBundle] loadNibNamed:@"TUserAlertView" owner:nil options:nil].firstObject;
#ifdef DEBUG
    id<SDMask> mask = self.view.sdm_maskWith(userView);
#else
    id<SDMask> mask = self.sdm_maskWith(userView);
#endif
    [mask userViewDidLoad:^(SDMaskModel *model) {
        model.animte = SDMaskAnimationAlert;
        model.
        setAutolayoutValueForKey(@(0), @"centerX").
        setAutolayoutValueForKey(@(0), @"centerY").
        setAutolayoutValueForKey(@(50), @"left").
        setAutolayoutValueForKey(@(50), @"right");
    }];
    [[mask bindEventForControls:@[userView.action0, userView.cancelButton_1]] bindingEventsUsingBlock:^(SDMaskBindingEvent * event) {
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
    id<SDMask> mask = self.view.sdm_maskWith(userView);
#else
    id<SDMask> mask = self.sdm_maskWith(userView);
#endif
    [mask userViewDidLoad:^(SDMaskModel * _Nonnull model) {
        model.animte = SDMaskAnimationActionSheet;
        model.
        setAutolayoutValueForKey(@(0), @"bottom").
        setAutolayoutValueForKey(@(15), @"left").
        setAutolayoutValueForKey(@(15), @"right").
        setAutolayoutValueForKey(@(350), @"height");
    }];
    [[[mask bindEventForControls:@[userView.action0, userView.action1]] bindEventForCancelControl:userView.actionCancel_1] bindingEventsUsingBlock:^(SDMaskBindingEvent *event) {
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
    id<SDMask> mask = self.view.sdm_alertMaskWith(userView);
#else
    id<SDMask> mask = self.sdm_alertMaskWith(userView);
#endif
    [mask userViewDidLoad:^(SDMaskModel *model) {
        model.animte = SDMaskAnimationAlert;
        [model.userView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(model.containerView);
            make.left.equalTo(model.containerView.mas_left).offset(20);
            make.right.equalTo(model.containerView.mas_right).offset(-20);
        }];
    }];
    [[[mask bindEventForCancelControl:userView.cancelButton_1] usingAutoDismiss] show];
}

- (IBAction)userAutolayoutSheet:(id)sender {
    TUserActionSheet* userView = [[NSBundle mainBundle] loadNibNamed:@"TUserActionSheet" owner:nil options:nil].firstObject;
#ifdef DEBUG
    SDMaskView* mask = self.view.sdm_maskWith(userView);
    mask.model.container = self.view;
    [mask userViewDidLoad:^(SDMaskModel *model) {
        model.animte = SDMaskAnimationActionSheet;
    }];
#else
    SDMaskController* mask = self.sdm_maskWith(userView);
#endif
    [mask userViewDidLoad:^(SDMaskModel * model) {
        model.animte = SDMaskAnimationActionSheet;
        [model.userView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(model.containerView.mas_bottom).priorityHigh();
            make.left.equalTo(model.containerView.mas_left).offset(15).priorityHigh();
            make.right.equalTo(model.containerView.mas_right).offset(-15).priorityHigh();
        }];
    }];
    [[[mask bindEventForCancelControl:userView.actionCancel_1] usingAutoDismiss] show];
}

@end
