//
//  UIView+SDMask.m
//  SDMask
//
//  Created by MeterWhite on 2019/11/8.
//  Copyright © 2019 MeterWhite. All rights reserved.
//

#import "SDMaskGuidController.h"
#import "UIResponder+SDMask.h"
#import "SDMaskController.h"
#import "SDMaskInterface.h"
#import <objc/runtime.h>
#import "SDMaskModel.h"
#import "SDMaskView.h"

@implementation UIView (SDMaskExtension)

- (nonnull SDMask*)sdm_showAlertUsingBlock:(NS_NOESCAPE SDMaskSettingBlock)block {
    id<SDMaskProtocol> mask = [[SDMaskController alloc] initWithUserView:self];
    [mask.model setAnimte:SDMaskAnimationAlert];
    if(block) block(mask);
    [mask show];
    return mask;
}

- (nonnull SDMask*)sdm_showActionSheetUsingBlock:(NS_NOESCAPE SDMaskSettingBlock)block {
    id<SDMaskProtocol> mask = (id)[[SDMaskController alloc] initWithUserView:self];
    [mask.model setAnimte:SDMaskAnimationSheet];
    if(block) block(mask);
    [mask show];
    return mask;
}

- (nonnull SDMask*)sdm_showLeftPushUsingBlock:(NS_NOESCAPE SDMaskSettingBlock)block {
    id<SDMaskProtocol> mask = (id)[[SDMaskController alloc] initWithUserView:self];
    [mask.model setAnimte:SDMaskAnimationLeftPush];
    if(block) block(mask);
    [mask show];
    return mask;
}

- (nonnull SDMask*)sdm_showRightPushUsingBlock:(NS_NOESCAPE SDMaskSettingBlock)block {
    id<SDMaskProtocol> mask = (id)[[SDMaskController alloc] initWithUserView:self];
    [mask.model setAnimte:SDMaskAnimationRightPush];
    if(block) block(mask);
    [mask show];
    return mask;
}

- (nonnull SDMask*)sdm_showHUDUsingBlock:(NS_NOESCAPE SDMaskSettingBlock)block {
    id<SDMaskProtocol> mask = (id)[[SDMaskController alloc] initWithUserView:self];
    [mask.model setAnimte:SDMaskAnimationHUD];
    [mask.model setAutoDismiss:YES];
    if(block) block(mask);
    [mask show];
    return mask;
}

- (nonnull SDMask*)sdm_showAlertIn:(UIView *)superview usingBlock:(NS_NOESCAPE SDMaskSettingBlock)block {
    id<SDMaskProtocol> mask = [[SDMaskView alloc] initWithUserView:self];
    [mask.model setMaskOwner:superview];
    [mask.model setAnimte:SDMaskAnimationAlert];
    if(block) block(mask);
    [mask show];
    return mask;
}

- (nonnull SDMask*)sdm_showActionSheetIn:(UIView *)superview usingBlock:(NS_NOESCAPE  SDMaskSettingBlock)block {
    id<SDMaskProtocol> mask = [[SDMaskView alloc] initWithUserView:self];
    [mask.model setMaskOwner:superview];
    [mask.model setAnimte:SDMaskAnimationSheet];
    if(block) block(mask);
    [mask show];
    return mask;
}

- (nonnull SDMask*)sdm_showLeftPushIn:(UIView *)superview usingBlock:(NS_NOESCAPE  SDMaskSettingBlock)block {
    id<SDMaskProtocol> mask = [[SDMaskView alloc] initWithUserView:self];
    [mask.model setMaskOwner:superview];
    [mask.model setAnimte:SDMaskAnimationLeftPush];
    if(block) block(mask);
    [mask show];
    return mask;
}

- (nonnull SDMask*)sdm_showRightPushIn:(UIView *)superview usingBlock:(NS_NOESCAPE  SDMaskSettingBlock)block {
    id<SDMaskProtocol> mask = [[SDMaskView alloc] initWithUserView:self];
    [mask.model setMaskOwner:superview];
    [mask.model setAnimte:SDMaskAnimationRightPush];
    if(block) block(mask);
    [mask show];
    return mask;
}

- (nonnull SDMask*)sdm_showHUDIn:(UIView *)superview usingBlock:(NS_NOESCAPE  SDMaskSettingBlock)block {
    id<SDMaskProtocol> mask = [[SDMaskView alloc] initWithUserView:self];
    [mask.model setMaskOwner:superview];
    [mask.model setAnimte:SDMaskAnimationHUD];
    [mask.model setAutoDismiss:YES];
    if(block) block(mask);
    [mask show];
    return mask;
}

static char keyForBindingKey = '\0';
- (instancetype)sdm_userViewWithBindingKey:(id)key {
    objc_setAssociatedObject(self, &keyForBindingKey, key, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}

- (id)sdm_bindingKey {
    return objc_getAssociatedObject(self, &keyForBindingKey);
}

- (nonnull id)sdm_safeGuide {
    if (@available(iOS 11.0, *)) return self.safeAreaLayoutGuide;
    return self;
}
@end


@implementation UIResponder(SDMaskExtension)

- (SDMask * _Nonnull (^)(id _Nonnull))sdm_maskWith {
    return ^ id (id userView){
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
        UIResponder<SDMaskBase>* mask = [[cls alloc] initWithUserView:userView];
        [mask.model setMaskOwner:self];
        return mask;
    };
}

- (SDMaskGuidController * _Nonnull (^)(NSArray<UIView *> * _Nonnull))sdm_guidMaskWith {
    return ^ id (NSArray<UIView *> * userView) {
        SDMaskGuidController *mask = [[SDMaskGuidController alloc] initWithUserView:userView];
        [mask.model setMaskOwner:self];
        return mask;
    };
}

- (SDMask * _Nonnull (^)(UIView * _Nonnull))sdm_alertMaskWith {
    return ^ id (UIView *userView) {
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
        SDMask *mask = [[cls alloc] initWithUserView:userView];
        [mask.model setMaskOwner:self];
        [mask.model setAnimte:SDMaskAnimationAlert];
        return mask;
    };
}

- (SDMask * _Nonnull (^)(UIView * _Nonnull))sdm_actionSheetMaskWith {
    return ^ id (UIView *userView) {
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
        SDMask *mask = [[cls alloc] initWithUserView:userView];
        [mask.model setMaskOwner:self];
        [mask.model setAnimte:SDMaskAnimationSheet];
        return mask;
    };
}

- (SDMask * _Nonnull (^)(UIView * _Nonnull))sdm_leftPushMaskWith {
    return ^ id (UIView *userView) {
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
        SDMask *mask = [[cls alloc] initWithUserView:userView];
        [mask.model setMaskOwner:self];
        [mask.model setAnimte:SDMaskAnimationLeftPush];
        return mask;
    };
}

- (SDMask * _Nonnull (^)(UIView * _Nonnull))sdm_rightPushMaskWith {
    return ^ id (UIView *userView) {
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
        SDMask *mask = [[cls alloc] initWithUserView:userView];
        [mask.model setMaskOwner:self];
        [mask.model setAnimte:SDMaskAnimationRightPush];
        return mask;
    };
}

- (SDMask * _Nonnull (^)(UIView * _Nonnull))sdm_HUDMaskWith {
    return ^ id (UIView *userView) {
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
        SDMask *mask = [[cls alloc] initWithUserView:userView];
        [mask.model setMaskOwner:self];
        [mask.model setAnimte:SDMaskAnimationHUD];
        [mask.model setAutoDismiss:YES];
        return mask;
    };
}

@end

