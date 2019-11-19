//
//  SDMaskInterface.h
//  SDMaskDemo
//
//  Created by MeterWhite on 2019/11/19.
//  Copyright © 2019 Meterwhite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SDMaskProtocol.h"
#import "SDMaskBindingEvent.h"
#import "SDMaskModel.h"


#define SDMaskUserBlock_T(T) void(^_Nonnull)(SDMaskModel<T>* _Nonnull model)
#define SDMaskUserBindingEventBlock_T(T) void(^_Nonnull)(SDMaskBindingEvent<T>* _Nonnull event)

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
- (nonnull SDMask*)userViewDidLoad:(SDMaskUserBlock_T(TUserView))block;
/// Set something befor view animation.
- (nonnull SDMask*)userViewPresentationWillAnimate:(SDMaskUserBlock_T(TUserView))block;
/// Set something befor view animation.
- (nonnull SDMask*)userViewPresentationDoAnimations:(SDMaskUserBlock_T(TUserView))block;
- (nonnull SDMask*)userViewPresentationCompleted:(SDMaskUserBlock_T(TUserView))block;
/// - (nonnull SDMask*)userViewDidLoad:(nonnull SDMaskUserBlock)block;
- (nonnull SDMask*)userViewDismissionWillAnimate:(SDMaskUserBlock_T(TUserView))block;
- (nonnull SDMask*)userViewDismissionDoAnimations:(SDMaskUserBlock_T(TUserView))block;
- (nonnull SDMask*)userViewDismissionCompleted:(SDMaskUserBlock_T(TUserView))block;
#pragma mark - Events
/**
 * [mask bindEventForControls:@[control0, [control1 sdm_withBindingKey:@"OK"], ...]];
 */
- (nonnull SDMask*)bindEventForControls:(nonnull NSArray<UIView*>*)bindingInfo;
- (nonnull SDMask*)bindEventForCancelControl:(nonnull UIView*)control;
/// Handel all control events .
- (nonnull SDMask*)bindingEventsUsingBlock:(SDMaskUserBindingEventBlock_T(TUserView))block;
/// One control to one event.
/// @param indexer index, key, or control
- (nonnull SDMask*)bindingEventFor:(nonnull id)indexer usingBlock:(SDMaskUserBindingEventBlock_T(TUserView))block;
#pragma mark - Display
- (void)show;
- (void)dismiss;
/// Note : Default for alert is NO. Default for action sheet is YES..
- (nonnull SDMask*)usingAutoDismiss;
- (nonnull SDMask*)disableSystemAnimation;
@end
