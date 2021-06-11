//
//  SDMaskInterface.h
//  SDMask
//  https://github.com/Meterwhite/SDMask
//
//  Created by MeterWhite on 2019/11/19.
//  Copyright © 2019 Meterwhite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SDMaskProtocol.h"
#import "SDMaskBindingEvent.h"
#import "SDMaskModel.h"

#pragma mark - User
/**
 * Get a user view with expanded capabilities.user can start working on the object(获得被能力扩展的户视图。用户可以该对象开始工作。)
 * This method is recommended to wrap a user view.(推荐这种方式来包装一个用户视图。)
 */
#define SDMaskUserView(userView) ((SDMaskUserContent<typeof(userView)> *)userView)
/**
 * Get the mask object , user can start working on the object .(获得蒙层对象，用户可以使用该对象开始工作。)
 */
#define SDMaskWith(owner, userView) \
((SDMask<typeof(userView)>*)owner.sdm_maskWith(userView))
/**
 * Mask for alert
 */
#define SDAlertMaskWith(owner, userView) \
((SDMask<typeof(userView)>*)owner.sdm_alertMaskWith(userView))
/**
 * Mask for action sheet.
 */
#define SDActionsheetMaskWith(owner, userView) \
((SDMask<typeof(userView)>*)owner.sdm_actionSheetMaskWith(userView))


#pragma mark - Subitem 次级宏定义
/// 使用OC泛型
#define SDMaskUserBlock_T(T) void(^ _Nullable)(SDMaskModel<T> *_Nonnull model)
#define SDMaskUserBindingEventBlock_T(T) void(^ _Nullable)(SDMaskBindingEvent<T> *_Nonnull event)
#define SDMaskSettingBlock_T(T) void(NS_NOESCAPE ^ _Nullable)(SDMask<T> *_Nonnull mask)

/**
* Associated with mask object
* Abstractly defines the UserView interface to make up for the protocol inability to use generics.
* 弥补OC协议无法使用泛型的能力，此处重复声明SDMaskProtocol对象的接口。SDMaskView和SDMaskController两者分别独立实现了SDMaskProtocol协议。
*/
@interface SDMask<__covariant TUserView> : NSProxy <SDMaskProtocol>
@property (nullable,nonatomic,readonly) TUserView userView;
#pragma mark - Properties
@property (nullable,nonatomic,readonly) SDMaskModel<TUserView>* model;
#pragma mark - Init
- (nonnull SDMask<TUserView>*)initWithUserView:(nonnull TUserView)view;
#pragma mark - Life cycle
/// View did add to container.Config something here.
- (nonnull SDMask<TUserView>*)userViewDidLoad:(SDMaskUserBlock_T(TUserView))block;
/// Set something befor view animation.
- (nonnull SDMask<TUserView>*)userViewPresentationWillAnimate:(SDMaskUserBlock_T(TUserView))block;
/// Set something befor view animation.
- (nonnull SDMask<TUserView>*)userViewPresentationDoAnimations:(SDMaskUserBlock_T(TUserView))block;
- (nonnull SDMask<TUserView>*)userViewPresentationCompleted:(SDMaskUserBlock_T(TUserView))block;
- (nonnull SDMask<TUserView>*)userViewDismissionDoAnimations:(SDMaskUserBlock_T(TUserView))block;
- (nonnull SDMask<TUserView>*)userViewDismissionCompleted:(SDMaskUserBlock_T(TUserView))block;
#pragma mark - Events
/**
 * [mask bindEventForControls:@[control0, [control1 sdm_withBindingKey:@"OK"], ...]];
 */
- (nonnull SDMask<TUserView>*)bindEventForControls:(nonnull NSArray<UIView*>*)bindingInfo;
/// 绑定取消按钮
- (nonnull SDMask<TUserView>*)bindEventForCancelControl:(nonnull UIView*)control;
/// Handel all control events .控制已经绑定好的事件
- (nonnull SDMask<TUserView>*)bindingEventsUsingBlock:(SDMaskUserBindingEventBlock_T(TUserView))block;
/// One control to one event.指定地控制已经绑定好的事件
/// @param indexer index, key, or control
- (nonnull SDMask<TUserView>*)bindingEventFor:(nonnull id)indexer usingBlock:(SDMaskUserBindingEventBlock_T(TUserView))block;
/// 取消事件
- (nonnull SDMask<TUserView>*)bindingCancelEventUsingBlock:(SDMaskUserBindingEventBlock_T(TUserView))block;
#pragma mark - Display
- (void)show;
/// 还可以使用通知的形式来全局
- (void)dismiss;
/// Note : Default for alert is NO. Default for action sheet is YES..
/// 改变蒙板触摸后默认的收起行为.
- (nonnull SDMask<TUserView>*)usingAutoDismiss;
- (nonnull SDMask<TUserView>*)disableSystemAnimation;
@end

/**
 * Associated with UserView
 * Abstractly defines the UserView interface to make up for the protocol inability to use generics.
 * 弥补OC协议无法使用泛型的能力，此处重复声明UIReponder+SDMask的接口
 */
@interface SDMaskUserContent<__covariant TUserView> : NSProxy
#pragma mark - UIView (SDMaskExtension)
- (nonnull SDMask<TUserView>*)sdm_showAlertUsingBlock:(SDMaskSettingBlock_T(TUserView))block;
- (nonnull SDMask<TUserView>*)sdm_showLeftPushUsingBlock:(SDMaskSettingBlock_T(TUserView))block;
- (nonnull SDMask<TUserView>*)sdm_showRightPushUsingBlock:(SDMaskSettingBlock_T(TUserView))block;
- (nonnull SDMask<TUserView>*)sdm_showActionSheetUsingBlock:(SDMaskSettingBlock_T(TUserView))block;
- (nonnull SDMask<TUserView>*)sdm_showHUDUsingBlock:(SDMaskSettingBlock_T(TUserView))block;
- (nonnull SDMask<TUserView>*)sdm_showAlertIn:(nonnull UIView*)superview usingBlock:(SDMaskSettingBlock_T(TUserView))block;
- (nonnull SDMask<TUserView>*)sdm_showActionSheetIn:(nonnull UIView*)superview usingBlock:(SDMaskSettingBlock_T(TUserView))block;
- (nonnull SDMask<TUserView>*)sdm_showLeftPushIn:(nonnull UIView*)superview usingBlock:(SDMaskSettingBlock_T(TUserView))block;
- (nonnull SDMask<TUserView>*)sdm_showRightPushIn:(nonnull UIView*)superview usingBlock:(SDMaskSettingBlock_T(TUserView))block;
- (nonnull SDMask<TUserView>*)sdm_showHUDIn:(nonnull UIView*)superview usingBlock:(SDMaskSettingBlock_T(TUserView))block;
@end
