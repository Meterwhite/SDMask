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

/**
 * Use Strongly referenced 'userView' in this block is safe.
 * Strongly referenced 'mask' object in block will cause circular references.Because mask retaind this block.
 */
typedef void(^SDMaskUserBlock)(SDMaskModel *_Nonnull model);

/**
 * Use Strongly referenced 'userView' in this block is safe.
 * Strongly referenced 'mask' object in block will cause circular references.Because mask retaind this block.
 */
typedef void(^SDMaskUserBindingEventBlock)(SDMaskBindingEvent *_Nonnull event);

@class SDMask;

@protocol SDMaskProtocol <NSObject>

@property (nullable,nonatomic,readonly) id userView;
#pragma mark - Properties
@property (nullable,nonatomic,readonly) SDMaskModel *model;
#pragma mark - Init
- (nonnull id<SDMaskProtocol>)initWithUserView:(nonnull UIView*)view;
#pragma mark - Life cycle
/// View did add to container.Config something here.
- (nonnull SDMask*)userViewDidLoad:(nonnull SDMaskUserBlock)block;
/// Set something befor view animation.
- (nonnull SDMask*)userViewPresentationWillAnimate:(nonnull SDMaskUserBlock)block;
/// Set something befor view animation.
- (nonnull SDMask*)userViewPresentationDoAnimations:(nonnull SDMaskUserBlock)block;
- (nonnull SDMask*)userViewPresentationCompleted:(nonnull SDMaskUserBlock)block;
/// - (nonnull SDMask*)userViewDidLoad:(nonnull SDMaskUserBlock)block;
- (nonnull SDMask*)userViewDismissionWillAnimate:(nonnull SDMaskUserBlock)block;
- (nonnull SDMask*)userViewDismissionDoAnimations:(nonnull SDMaskUserBlock)block;
- (nonnull SDMask*)userViewDismissionCompleted:(nonnull SDMaskUserBlock)block;
#pragma mark - Events
/**
 * [mask bindEventForControls:@[control0, [control1 sdm_withBindingKey:@"OK"], ...]];
 */
- (nonnull SDMask*)bindEventForControls:(nonnull NSArray<UIView*>*)bindingInfo;
- (nonnull SDMask*)bindEventForCancelControl:(nonnull UIView*)control;
/// Handel all control events .
- (nonnull SDMask*)bindingEventsUsingBlock:(nonnull SDMaskUserBindingEventBlock)block;
/// One control to one event.
/// @param indexer index, key, or control
- (nonnull SDMask*)bindingEventFor:(nonnull id)indexer usingBlock:(nonnull SDMaskUserBindingEventBlock)block;
#pragma mark - Display
- (void)show;
- (void)dismiss;
/// Note : Default NO.
- (nonnull SDMask*)usingAutoDismiss;
- (nonnull SDMask*)disableSystemAnimation;
@end
