//
//  SDMaskInterface.h
//  SDMask
//
//  Created by MeterWhite on 2019/11/19.
//  Copyright © 2019 Meterwhite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SDMaskProtocol.h"
#import "SDMaskBindingEvent.h"
#import "SDMaskModel.h"
/**
 * Begin with userView and wrap it with generics.
 */
#define SDMaskUserView(userView) ((SDMaskUserContent<typeof(userView)> *)userView)
#define SDMaskUserBlock_T(T) void(^ _Nullable)(SDMaskModel<T> *_Nonnull model)
#define SDMaskUserBindingEventBlock_T(T) void(^ _Nullable)(SDMaskBindingEvent<T> *_Nonnull event)
#define SDMaskSettingBlock_T(T) void(NS_NOESCAPE ^ _Nullable)(SDMask<T> *_Nonnull mask)
/**
 * Methods in  'SDMaskProtocol.h'
 * Note : SDMask is a Interface as a protocol to implement generics.
 *
 *  You can use generics in blocks to get xcode code hints.
 *  :
 *  void(^SDMaskUserBlock)(SDMaskModel<TUserView>*  model);
 *  void(^SDMaskUserBindingEventBlock)(SDMaskBindingEvent<TUserView>* event);
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
- (nonnull SDMask<TUserView>*)bindEventForCancelControl:(nonnull UIView*)control;
/// Handel all control events .
- (nonnull SDMask<TUserView>*)bindingEventsUsingBlock:(SDMaskUserBindingEventBlock_T(TUserView))block;
/// One control to one event.
/// @param indexer index, key, or control
- (nonnull SDMask<TUserView>*)bindingEventFor:(nonnull id)indexer usingBlock:(SDMaskUserBindingEventBlock_T(TUserView))block;
#pragma mark - Display
- (void)show;
- (void)dismiss;
/// Note : Default for alert is NO. Default for action sheet is YES..
- (nonnull SDMask<TUserView>*)usingAutoDismiss;
- (nonnull SDMask<TUserView>*)disableSystemAnimation;
@end


@interface SDMaskUserContent<__covariant TUserView> : NSProxy
#pragma mark - UIView (SDMaskExtension)
- (nonnull SDMask<TUserView>*)sdm_showAlertUsingBlock:(SDMaskSettingBlock_T(TUserView))block;
- (nonnull SDMask<TUserView>*)sdm_showActionSheetUsingBlock:(SDMaskSettingBlock_T(TUserView))block;
- (nonnull SDMask<TUserView>*)sdm_showHUDUsingBlock:(SDMaskSettingBlock_T(TUserView))block;
- (nonnull SDMask<TUserView>*)sdm_showAlertIn:(nonnull UIView*)superview usingBlock:(SDMaskSettingBlock_T(TUserView))block;
- (nonnull SDMask<TUserView>*)sdm_showActionSheetIn:(nonnull UIView*)superview usingBlock:(SDMaskSettingBlock_T(TUserView))block;
- (nonnull SDMask<TUserView>*)sdm_showHUDIn:(nonnull UIView*)superview usingBlock:(SDMaskSettingBlock_T(TUserView))block;
@end
