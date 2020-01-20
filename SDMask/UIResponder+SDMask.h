//
//  UIView+SDMask.h
//  SDMask
//
//  Created by MeterWhite on 2019/11/8.
//  Copyright © 2019 MeterWhite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDMaskProtocol.h"

@class SDMaskGuidController;

typedef void(^SDMaskSettingBlock)(SDMask *_Nonnull mask);
/**
 * Begin with view's owner and wrap it with generics.
 * owner : Object whitch present mask view.
 */
#define SDMaskWith(owner, userView) \
((SDMask<typeof(userView)>*)owner.sdm_maskWith(userView))
/**
 * Begin with view's owner and wrap it with generics.
 */
#define SDAlertMaskWith(owner, userView) \
((SDMask<typeof(userView)>*)owner.sdm_alertMaskWith(userView))
/**
 * Begin with view's owner and wrap it with generics.
 */
#define SDActionsheetMaskWith(owner, userView) \
((SDMask<typeof(userView)>*)owner.sdm_actionSheetMaskWith(userView))


/**
 * Extension for mask content view.
 * [userView sdm_showAlertUsingBlock:^(Mask *mask){
 *      [mask ...^(SDMaskModel *model){
 * Wrong:    [mask ...];//caused circular references.
 * Right:    [model.thisMask ...];
 *      }];
 * }];
 */
@interface UIView (SDMaskExtension)
#pragma mark - Quick methods
/**
 *  Show mask view with user view.You can do something in block.
 */
- (nonnull SDMask*)sdm_showAlertUsingBlock:(nullable NS_NOESCAPE SDMaskSettingBlock)block;
/**
 *  Show mask view with user view.You can do something in block.
 */
- (nonnull SDMask*)sdm_showActionSheetUsingBlock:(nullable NS_NOESCAPE SDMaskSettingBlock)block;

- (nonnull SDMask*)sdm_showLeftPushUsingBlock:(nullable NS_NOESCAPE SDMaskSettingBlock)block;

- (nonnull SDMask*)sdm_showRightPushUsingBlock:(nullable NS_NOESCAPE SDMaskSettingBlock)block;

- (nonnull SDMask*)sdm_showHUDUsingBlock:(nullable NS_NOESCAPE SDMaskSettingBlock)block;
/**
 *  Show mask view from specified view with user view.You can do something in block.
 */
- (nonnull SDMask*)sdm_showAlertIn:(nonnull UIView*)superview usingBlock:(nullable NS_NOESCAPE SDMaskSettingBlock)block;
/**
 *  Show mask view from specified view with user view.You can do something in block.
 */
- (nonnull SDMask*)sdm_showActionSheetIn:(nonnull UIView*)superview usingBlock:(nullable NS_NOESCAPE SDMaskSettingBlock)block;

- (nonnull SDMask*)sdm_showLeftPushIn:(nonnull UIView*)superview usingBlock:(nullable NS_NOESCAPE SDMaskSettingBlock)block;

- (nonnull SDMask*)sdm_showRightPushIn:(nonnull UIView*)superview usingBlock:(nullable NS_NOESCAPE SDMaskSettingBlock)block;

- (nonnull SDMask*)sdm_showHUDIn:(nonnull UIView*)superview usingBlock:(nullable NS_NOESCAPE SDMaskSettingBlock)block;

#pragma mark - Bind key
/**
 *  Set key(SDMaskBindingEvent.key) to mark a control.
 */
- (nullable instancetype)sdm_userViewWithBindingKey:(nonnull id)key;
/**
 *  Get key(SDMaskBindingEvent.key) from a marked control.
 */
@property (nullable,nonatomic,readonly)id sdm_bindingKey;

#pragma mark - Safe area
@property (nonnull,nonatomic,readonly)id sdm_safeGuide;
@end


/// Extension for mask view`s owner.
@interface UIResponder(SDMaskExtension)
/**
 *  Get default SDMask object from its presenter.
 */
@property (nonnull,nonatomic,copy,readonly) SDMask *_Nonnull
(^sdm_maskWith)(id _Nonnull userView);
/**
 * Get SDMaskGuidController from its presenter.
 */
@property (nonnull,nonatomic,copy,readonly) SDMaskGuidController *_Nonnull
(^sdm_guidMaskWith)(NSArray<UIView *> * _Nonnull userView);
/**
 *  Get alert style SDMask object from its presenter.
 */
@property (nonnull,nonatomic,copy,readonly) SDMask *_Nonnull
(^sdm_alertMaskWith)(UIView *_Nonnull userView);
/**
 *  Get action sheet style SDMask object from its presenter.
 */
@property (nonnull,nonatomic,copy,readonly) SDMask *_Nonnull
(^sdm_actionSheetMaskWith)(UIView *_Nonnull userView);

@property (nonnull,nonatomic,copy,readonly) SDMask *_Nonnull
(^sdm_leftPushMaskWith)(UIView *_Nonnull userView);

@property (nonnull,nonatomic,copy,readonly) SDMask *_Nonnull
(^sdm_rightPushMaskWith)(UIView *_Nonnull userView);

@property (nonnull,nonatomic,copy,readonly) SDMask *_Nonnull
(^sdm_HUDMaskWith)(UIView *_Nonnull userView);
@end
