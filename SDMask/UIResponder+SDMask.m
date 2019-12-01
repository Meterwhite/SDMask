//
//  UIView+SDMask.m
//  SDMask
//
//  Created by MeterWhite on 2019/11/8.
//  Copyright © 2019 MeterWhite. All rights reserved.
//

#import "UIResponder+SDMask.h"
#import "SDMaskController.h"
#import "SDMaskInterface.h"
#import <objc/runtime.h>
#import "SDMaskModel.h"
#import "SDMaskView.h"

@implementation UIView (SDMaskExtension)

- (nonnull SDMask*)sdm_showAlertUsingBlock:(NS_NOESCAPE SDMaskSettingBlock)block
{
    id<SDMaskProtocol> mask = [[SDMaskController alloc] initWithUserView:self];
    mask.model.animte = SDMaskAnimationAlert;
    if(block) block(mask);
    [mask show];
    return mask;
}

- (nonnull SDMask*)sdm_showActionSheetUsingBlock:(NS_NOESCAPE SDMaskSettingBlock)block
{
    id<SDMaskProtocol> mask = (id)[[SDMaskController alloc] initWithUserView:self];
    mask.model.animte = SDMaskAnimationActionSheet;
    if(block) block(mask);
    [mask show];
    return mask;
}

- (nonnull SDMask*)sdm_showLeftPushUsingBlock:(NS_NOESCAPE SDMaskSettingBlock)block
{
    id<SDMaskProtocol> mask = (id)[[SDMaskController alloc] initWithUserView:self];
    mask.model.animte = SDMaskAnimationLeftPush;
    if(block) block(mask);
    [mask show];
    return mask;
}

- (nonnull SDMask*)sdm_showRightPushUsingBlock:(NS_NOESCAPE SDMaskSettingBlock)block
{
    id<SDMaskProtocol> mask = (id)[[SDMaskController alloc] initWithUserView:self];
    mask.model.animte = SDMaskAnimationRightPush;
    if(block) block(mask);
    [mask show];
    return mask;
}

- (nonnull SDMask*)sdm_showAlertIn:(UIView *)superview usingBlock:(NS_NOESCAPE SDMaskSettingBlock)block
{
    id<SDMaskProtocol> mask = [[SDMaskView alloc] initWithUserView:self];
    mask.model.animte = SDMaskAnimationAlert;
    mask.model.maskOwner = superview;
    if(block) block(mask);
    [mask show];
    return mask;
}

- (nonnull SDMask*)sdm_showActionSheetIn:(UIView *)superview usingBlock:(NS_NOESCAPE  SDMaskSettingBlock)block
{
    id<SDMaskProtocol> mask = [[SDMaskView alloc] initWithUserView:self];
    mask.model.animte = SDMaskAnimationActionSheet;
    mask.model.maskOwner = superview;
    if(block) block(mask);
    [mask show];
    return mask;
}

- (nonnull SDMask*)sdm_showLeftPushIn:(UIView *)superview usingBlock:(NS_NOESCAPE  SDMaskSettingBlock)block
{
    id<SDMaskProtocol> mask = [[SDMaskView alloc] initWithUserView:self];
    mask.model.animte = SDMaskAnimationLeftPush;
    mask.model.maskOwner = superview;
    if(block) block(mask);
    [mask show];
    return mask;
}

- (nonnull SDMask*)sdm_showRightPushIn:(UIView *)superview usingBlock:(NS_NOESCAPE  SDMaskSettingBlock)block
{
    id<SDMaskProtocol> mask = [[SDMaskView alloc] initWithUserView:self];
    mask.model.animte = SDMaskAnimationRightPush;
    mask.model.maskOwner = superview;
    if(block) block(mask);
    [mask show];
    return mask;
}

static char keyForBindingKey = '\0';

- (instancetype)sdm_userViewWithBindingKey:(id)key
{
    objc_setAssociatedObject(self, &keyForBindingKey, key, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}

- (id)sdm_bindingKey
{
    return objc_getAssociatedObject(self, &keyForBindingKey);
}

- (nonnull id)sdm_safeGuide
{
    if (@available(iOS 11.0, *)) return self.safeAreaLayoutGuide;
    return self;
}
@end


@implementation UIResponder(SDMaskExtension)

- (SDMask * _Nonnull (^)(UIView * _Nonnull))sdm_maskWith
{
    return ^ id (UIView* userView){
        Class cls = nil;
        do {
            if([self.class isSubclassOfClass:UIViewController.class]){
                cls = SDMaskController.class;
                break;
            }
            if([self.class isSubclassOfClass:UIView.class]){
                cls = SDMaskView.class;
                break;
            }
        } while (0);
        UIResponder<SDMaskProtocol>* mask = [[cls alloc] initWithUserView:userView];
        mask.model.maskOwner = self;
        return mask;
    };
}

- (SDMask * _Nonnull (^)(UIView * _Nonnull))sdm_alertMaskWith
{
    return ^ id (UIView* userView) {
        Class cls = nil;
        do {
            if([self.class isSubclassOfClass:UIViewController.class]){
                cls = SDMaskController.class;
                break;
            }
            if([self.class isSubclassOfClass:UIView.class]){
                cls = SDMaskView.class;
                break;
            }
        } while (0);
        SDMask* mask = [[cls alloc] initWithUserView:userView];
        mask.model.maskOwner = self;
        mask.model.animte = SDMaskAnimationAlert;
        return mask;
    };
}

- (SDMask * _Nonnull (^)(UIView * _Nonnull))sdm_actionSheetMaskWith
{
    return ^ id (UIView* userView) {
        Class cls = nil;
        do {
            if([self.class isSubclassOfClass:UIViewController.class]){
                cls = SDMaskController.class;
                break;
            }
            if([self.class isSubclassOfClass:UIView.class]){
                cls = SDMaskView.class;
                break;
            }
        } while (0);
        SDMask* mask = [[cls alloc] initWithUserView:userView];
        mask.model.maskOwner = self;
        mask.model.animte = SDMaskAnimationActionSheet;
        return mask;
    };
}

- (SDMask * _Nonnull (^)(UIView * _Nonnull))sdm_leftPushMaskWith
{
    return ^ id (UIView* userView) {
        Class cls = nil;
        do {
            if([self.class isSubclassOfClass:UIViewController.class]){
                cls = SDMaskController.class;
                break;
            }
            if([self.class isSubclassOfClass:UIView.class]){
                cls = SDMaskView.class;
                break;
            }
        } while (0);
        SDMask* mask = [[cls alloc] initWithUserView:userView];
        mask.model.maskOwner = self;
        mask.model.animte = SDMaskAnimationLeftPush;
        return mask;
    };
}

- (SDMask * _Nonnull (^)(UIView * _Nonnull))sdm_rightPushMaskWith
{
    return ^ id (UIView* userView) {
        Class cls = nil;
        do {
            if([self.class isSubclassOfClass:UIViewController.class]){
                cls = SDMaskController.class;
                break;
            }
            if([self.class isSubclassOfClass:UIView.class]){
                cls = SDMaskView.class;
                break;
            }
        } while (0);
        SDMask* mask = [[cls alloc] initWithUserView:userView];
        mask.model.maskOwner = self;
        mask.model.animte = SDMaskAnimationRightPush;
        return mask;
    };
}

@end

