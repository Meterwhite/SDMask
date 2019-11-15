//
//  UIView+SDMask.m
//  SDMask
//
//  Created by MeterWhite on 2019/11/8.
//  Copyright © 2019 MeterWhite. All rights reserved.
//

#import "UIResponder+SDMask.h"
#import "SDMaskController.h"
#import <objc/runtime.h>
#import "SDMaskModel.h"
#import "SDMaskView.h"

@implementation UIResponder(SDMaskExtension)

- (__kindof UIResponder<SDMask> * _Nonnull (^)(UIView * _Nonnull))sdm_maskWith
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
        UIResponder<SDMask>* mask = [[cls alloc] initWithUserView:userView];
        mask.model.container = self;
        return mask;
    };
}

- (__kindof UIResponder<SDMask> * _Nonnull (^)(UIView * _Nonnull))sdm_alertMaskWith
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
        id<SDMask> mask = [[cls alloc] initWithUserView:userView];
        mask.model.container = self;
        mask.model.animte = SDMaskAnimationAlert;
        return mask;
    };
}

- (__kindof UIResponder<SDMask> * _Nonnull (^)(UIView * _Nonnull))sdm_actionSheetMaskWith
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
        id<SDMask> mask = [[cls alloc] initWithUserView:userView];
        mask.model.container = self;
        mask.model.animte = SDMaskAnimationActionSheet;
        return mask;
    };
}

@end

@implementation UIView (SDMaskExtension)

- (void)sdm_showAlertUsingBlock:(NS_NOESCAPE SDMaskSettingBlock)block
{
    id<SDMask> mask = [[SDMaskController alloc] initWithUserView:self];
    mask.model.animte = SDMaskAnimationAlert;
    if(block) block(mask);
    [mask show];
}

- (void)sdm_showActionSheetUsingBlock:(NS_NOESCAPE SDMaskSettingBlock)block
{
    id<SDMask> mask = [[SDMaskController alloc] initWithUserView:self];
    mask.model.animte = SDMaskAnimationActionSheet;
    if(block) block(mask);
    [mask show];
}

- (void)sdm_showAlertIn:(UIView *)view usingBlock:(NS_NOESCAPE SDMaskSettingBlock)block
{
    id<SDMask> mask = [[SDMaskView alloc] initWithUserView:self];
    mask.model.animte = SDMaskAnimationAlert;
    mask.model.container = view;
    if(block) block(mask);
    [mask show];
}

- (void)sdm_showActionSheetIn:(UIView *)view usingBlock:(NS_NOESCAPE  SDMaskSettingBlock)block
{
    id<SDMask> mask = [[SDMaskView alloc] initWithUserView:self];
    mask.model.animte = SDMaskAnimationActionSheet;
    mask.model.container = view;
    if(block) block(mask);
    [mask show];
}

static char keyForBindingKey = '\0';

- (instancetype)sdm_withBindingKey:(id)key
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
