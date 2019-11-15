//
//  SDMaskModel.h
//  SDMask
//
//  Created by MeterWhite on 2019/11/8.
//  Copyright © 2019 MeterWhite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SDMaskBindingEvent;
@protocol SDMask;
typedef enum : NSUInteger {
    SDMaskAnimationAlert,
    SDMaskAnimationActionSheet
} SDMaskAnimationStyle;

/**
 *  This object contains animations, layouts, and features for configuring the UI.
 */
@interface SDMaskModel : NSObject
- (nonnull instancetype)initWithUserView:(nonnull UIView*)view forMask:(nonnull id<SDMask>)mask;
#pragma mark - View
/// Need!
@property (nullable,nonatomic,weak) UIView* userView;
/// Need! Who present mask.It is view or controller.
@property (nullable,nonatomic,weak) __kindof UIResponder* container;
/// Super view for user view.
@property (nullable,nonatomic,readonly) UIView* containerView;
@property (nullable,nonatomic,weak) id<SDMask>  thisMask;

#pragma mark - Animation
/// Default 'YES'. 'NO' means user makes animation himself, otherwise there will be no animation.
@property (nonatomic) BOOL usingSystemAnimation;
@property (nonatomic) SDMaskAnimationStyle animte;
/// Default 0.2
@property (nonatomic) NSTimeInterval presentTime;
/// Default 0.25
@property (nonatomic) NSTimeInterval dismissTime;
///  Alert default NO. Action sheet Default YES.
@property (nonatomic) BOOL autoDismiss;

#pragma mark - Bind events
/**
 Lazy update value.So you can do something in followed methods like 'userViewDismissionCompleted:'.
 [mask userViewDismissionCompleted:^(SDMaskModel* model){
    model.latestEvent...
 }];
 */
@property (nullable,nonatomic,weak) SDMaskBindingEvent* latestEvent;

#pragma mark - Autolayout
@property (assign,readonly) BOOL isUsingAutolayout;
/**
 *
 *  model.setAutolayoutValueForKey(@(0), @"bottom").setAutolayoutValueForKey(... ...
 *  Key guide
 *  :
 *  key <- {top, left, right, bottom, centerX, centerY, width, height} <- NSNumber
 *  key <- {size, insets} <- NSValue
 */
@property (nonnull,nonatomic,copy,readonly) SDMaskModel*_Nonnull (^setAutolayoutValueForKey)(NSValue* _Nonnull value, NSString*_Nonnull key);

#pragma mark - System
@property (nonnull,nonatomic,readonly,class) UIColor* defaultBackgroundColor;
@property (nonatomic,readonly,class) CGFloat screenWidth;
@property (nonatomic,readonly,class) CGFloat screenHeight;
- (nonnull UIViewController*)currentController;

#pragma mark - Screen adapt
@property (nonatomic,readonly,class) BOOL screenIsShaped;
@end
