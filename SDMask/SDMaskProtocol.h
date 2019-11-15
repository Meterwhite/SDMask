//
//  SDMaskProtocol.h
//  SDMask
//
//  Created by MeterWhite on 2019/11/15.
//  Copyright © 2019 Meterwhite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SDMaskModel;
@class SDMaskBindingEvent;

typedef void(^SDMaskUserBlock)(SDMaskModel* _Nonnull model);
typedef void(^SDMaskUserBindingEventBlock)(SDMaskBindingEvent* _Nonnull event);

@protocol SDMask <NSObject>

@property (nullable,nonatomic,readonly) UIView* userView;
#pragma mark - Properties
@property (nullable,nonatomic,readonly) SDMaskModel* model;
#pragma mark - Init
- (nonnull instancetype)initWithUserView:(nonnull UIView*)view;
#pragma mark - Life cycle
/// View did add to container.Config something here.
- (nonnull id<SDMask>)userViewDidLoad:(nonnull SDMaskUserBlock)block;
/// Set something befor view animation.
- (nonnull id<SDMask>)userViewPresentationWillAnimate:(nonnull SDMaskUserBlock)block;
/// Set something befor view animation.
- (nonnull id<SDMask>)userViewPresentationDoAnimations:(nonnull SDMaskUserBlock)block;
- (nonnull id<SDMask>)userViewPresentationCompleted:(nonnull SDMaskUserBlock)block;
/// - (nonnull id<SDMask>)userViewDidLoad:(nonnull SDMaskUserBlock)block;
- (nonnull id<SDMask>)userViewDismissionWillAnimate:(nonnull SDMaskUserBlock)block;
- (nonnull id<SDMask>)userViewDismissionDoAnimations:(nonnull SDMaskUserBlock)block;
- (nonnull id<SDMask>)userViewDismissionCompleted:(nonnull SDMaskUserBlock)block;
#pragma mark - Events
/**
 * [mask bindEventForControls:@[control0, [control1 sdm_withBindingKey:@"OK"], ...]];
 */
- (nonnull id<SDMask>)bindEventForControls:(nonnull NSArray<UIView*>*)bindingInfo;
- (nonnull id<SDMask>)bindEventForCancelControl:(nonnull UIView*)control;
/// Handel all control events .
- (nonnull id<SDMask>)bindingEventsUsingBlock:(nonnull SDMaskUserBindingEventBlock)block;
/// One control to one event.
/// @param indexer index, key, or control
- (nonnull id<SDMask>)bindingEventFor:(nonnull id)indexer usingBlock:(nonnull SDMaskUserBindingEventBlock)block;
#pragma mark - Display
- (void)show;
- (void)dismiss;
/// Note : Default for alert is NO. Default for action sheet is YES..
- (nonnull id<SDMask>)usingAutoDismiss;
- (nonnull id<SDMask>)disableSystemAnimation;
@end
