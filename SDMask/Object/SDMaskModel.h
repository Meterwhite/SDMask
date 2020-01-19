//
//  SDMaskModel.h
//  SDMask
//
//  Created by MeterWhite on 2019/11/8.
//  Copyright © 2019 MeterWhite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDMaskProtocol.h"
#import <UIKit/UIKit.h>

@class SDMaskBindingEvent;
@protocol SDMaskProtocol;
typedef enum : NSUInteger {
    /**
     * Fade in and out from the center
     */
    SDMaskAnimationAlert        =   0,
    /**
     * Push the view from the bottom center
     */
    SDMaskAnimationSheet        =   1,
    /**
     * Push the view from the left
     */
    SDMaskAnimationLeftPush     =   2,
    /**
     * Push the view from the right
     */
    SDMaskAnimationRightPush    =   3,
    /**
     * Delay fade in and out from the center.(SDMaskModel.dismissDelayTime)
     */
    SDMaskAnimationHUD          =   4,
    /**
     * <#...#>
     */
    SDMaskAnimationGuid         =   5,
    SDMaskAnimationCustom       =   8964
} SDMaskAnimationStyle;

/**
 *  This object contains animations, layouts, and features for configuring the UI.
 */
@interface SDMaskModel<__covariant TUserView> : NSObject
- (nonnull instancetype)initWithUserView:(nonnull TUserView)uView forMask:(nonnull SDMask*)mask;
#pragma mark - Guid
/// In guid controller it is start with 1, otherwise always is 0;
@property (nonatomic) NSUInteger guidPage;
#pragma mark - View
/// Need!
@property (nullable,nonatomic,weak) TUserView userView;
/// Need! The owner present current mask view.It may be view or controller.For controller sometimes this peoperty may not instead of weak self,if controller not be specified.
@property (nullable,nonatomic,weak) __kindof UIResponder *maskOwner;
/// Super view for user view.
@property (nullable,nonatomic,readonly) UIView *superview;
/// This mask object.
@property (nullable,nonatomic,weak) SDMask *thisMask;
/// Default nil.
@property (nullable,nonatomic,strong) UIColor *backgroundColor;

#pragma mark - Animation
/// Default 'YES'. 'NO' means user makes animation himself, otherwise there will be no animation.
@property (nonatomic) BOOL usingSystemAnimation;
@property (nonatomic) SDMaskAnimationStyle animte;
/// Default 0.2 sec.
@property (nonatomic) NSTimeInterval presentTime;
/// Default 0.25 sec.
@property (nonatomic) NSTimeInterval dismissTime;
/// Default 0.0 sec.
@property (nonatomic) NSTimeInterval dismissDelayTime;
///  Default NO.
@property (nonatomic) BOOL autoDismiss;

#pragma mark - Bind events
/**
 Lazy update value.So you can do something in followed methods like 'userViewDismissionCompleted:'.
 [mask userViewDismissionCompleted:^(SDMaskModel *model){
    model.latestEvent...
 }];
 */
@property (nullable,nonatomic,weak) SDMaskBindingEvent *latestEvent;

#pragma mark - Autolayout
@property (assign,readonly) BOOL isUsingAutolayout;
/**
 *
 *  model.setAutolayoutValueForKey(@(0), @"bottom").setAutolayoutValueForKey(...
 *  SDMaskGuidController is not be supported.
 *  Key guide
 *  :
 *  key <- {top, left, right, bottom, centerX, centerY, width, height} <- NSNumber
 *  key <- {size, insets} <- NSValue
 */
@property (nonnull,nonatomic,copy,readonly) SDMaskModel*_Nonnull (^setAutolayoutValueForKey)(NSValue *_Nonnull value, NSString *_Nonnull key);

#pragma mark - System
@property (nonnull,nonatomic, class) UIColor *defaultBackgroundColor;
@property (nonatomic,readonly,class) CGFloat screenWidth;
@property (nonatomic,readonly,class) CGFloat screenHeight;
#pragma mark - Associated
@property (nullable,nonatomic,strong) UIWindow *associatedWindow;

#pragma mark - Screen adapt
@property (nonatomic,readonly,class) BOOL screenIsShaped;
@end
