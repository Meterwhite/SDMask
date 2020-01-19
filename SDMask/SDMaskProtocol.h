//
//  SDMaskProtocol.h
//  SDMask
//
//  Created by MeterWhite on 2019/11/15.
//  Copyright © 2019 Meterwhite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SDMaskBindingEvent;
@class SDMaskModel;
@class SDMask;

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
#pragma mark - Protocol for mask
@protocol SDMaskBase <NSObject>
@property (nullable,nonatomic,readonly) id userView;
@property (nullable,nonatomic,readonly) SDMaskModel *model;
- (nonnull id)initWithUserView:(nonnull id)uView;
- (void)show;
- (void)dismiss;
@end

@protocol SDMaskLifeCycle <NSObject>
/// View did add to container.Config something here.
- (nonnull SDMask*)userViewDidLoad:(nonnull SDMaskUserBlock)block;
- (nonnull SDMask*)userViewDidDisappear:(nonnull SDMaskUserBlock)block;
@end

@protocol SDMaskAnimationControl <NSObject>
/// Note : Default NO.
- (nonnull SDMask*)usingAutoDismiss;
- (nonnull SDMask*)disableSystemAnimation;
/// Set something befor view animation.
- (nonnull SDMask*)userViewPresentationWillAnimate:(nonnull SDMaskUserBlock)block;
/// Set something befor view animation.
- (nonnull SDMask*)userViewPresentationDoAnimations:(nonnull SDMaskUserBlock)block;
- (nonnull SDMask*)userViewPresentationCompleted:(nonnull SDMaskUserBlock)block;
- (nonnull SDMask*)userViewDismissionWillAnimate:(nonnull SDMaskUserBlock)block;
- (nonnull SDMask*)userViewDismissionDoAnimations:(nonnull SDMaskUserBlock)block;
- (nonnull SDMask*)userViewDismissionCompleted:(nonnull SDMaskUserBlock)block;
@end

@protocol SDMaskUserEvents <NSObject>
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
@end

@protocol SDMaskProtocol
<
    NSObject,
    SDMaskBase,
    SDMaskLifeCycle,
    SDMaskUserEvents,
    SDMaskAnimationControl
>
@end

@protocol SDMaskGuidProtocol
<
    NSObject,
    SDMaskBase,
    SDMaskLifeCycle
>
@end
