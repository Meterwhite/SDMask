//
//  UIView+SDMask.h
//  SDMask
//
//  Created by MeterWhite on 2019/11/8.
//  Copyright © 2019 MeterWhite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDMaskProtocol.h"

typedef void(^SDMaskSettingBlock)(id<SDMask> _Nonnull mask);


/// Extension for mask owner.
@interface UIResponder(SDMaskExtension)
/**
 *  Get default SDMask object from its presenter.
 */
@property (nonnull,nonatomic,copy,readonly) __kindof UIResponder<SDMask>* _Nonnull
(^sdm_maskWith)(UIView* _Nonnull userView);
/**
*  Get alert style SDMask object from its presenter.
*/
@property (nonnull,nonatomic,copy,readonly) __kindof UIResponder<SDMask>* _Nonnull
(^sdm_alertMaskWith)(UIView* _Nonnull userView);
/**
*  Get action sheet style SDMask object from its presenter.
*/
@property (nonnull,nonatomic,copy,readonly) __kindof UIResponder<SDMask>* _Nonnull
(^sdm_actionSheetMaskWith)(UIView* _Nonnull userView);
@end


/// Extension for mask content view.
@interface UIView (SDMaskExtension)
#pragma mark - Quick methods
/**
 *  Show mask view with user view.You can do something in block.
 */
- (void)sdm_showAlertUsingBlock:(nullable NS_NOESCAPE SDMaskSettingBlock)block;
/**
 *  Show mask view with user view.You can do something in block.
 */
- (void)sdm_showActionSheetUsingBlock:(nullable NS_NOESCAPE SDMaskSettingBlock)block;
/**
 *  Show mask view from specified view with user view.You can do something in block.
 */
- (void)sdm_showAlertIn:(nonnull UIView*)view usingBlock:(nullable NS_NOESCAPE SDMaskSettingBlock)block;
/**
 *  Show mask view from specified view with user view.You can do something in block.
 */
- (void)sdm_showActionSheetIn:(nonnull UIView*)view usingBlock:(nullable NS_NOESCAPE SDMaskSettingBlock)block;

#pragma mark - Bind key
/**
 *  Set key(SDMaskBindingEvent.key) to mark a control.
 */
- (nullable instancetype)sdm_withBindingKey:(nonnull id)key;
/**
 *  Get key(SDMaskBindingEvent.key) from a marked control.
 */
- (nullable id)sdm_bindingKey;

#pragma mark - Safe area
- (nonnull id)sdm_safeGuide;
@end
