//
//  SDMaskModel.m
//  SDMask
//
//  Created by MeterWhite on 2019/11/8.
//  Copyright © 2019 MeterWhite. All rights reserved.
//

#import "SDMaskNotificationName.h"
#import "UIResponder+SDMask.h"
#import "SDMaskController.h"
#import "SDMaskProtocol.h"
#import <objc/runtime.h>
#import "SDMaskModel.h"

@implementation SDMaskModel {
    __weak UIViewController *   _currentController;
    SDMaskBindingEvent *        _cancelEvent;
    NSArray *                   _bindingEvents;
    SDMaskUserBindingEventBlock _blockForBindingEventsUsingBlock;
    NSMutableDictionary<id,SDMaskUserBindingEventBlock>* _blockForBindingEventForUsingBlock;
    NSMutableDictionary *       _autolayoutKeyValues;
    NSMutableDictionary *       _autolayoutKeyConstraints;
    NSNumber *                  _isUsingAutolayout;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _dismissTime            = 0.25;
        _presentTime            = 0.2;
        _dismissDelayTime       = 0.0;
        _usingSystemAnimation   = YES;
        _autoDismiss            = NO;
        _guidPage               = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whatNotification:) name:SDMaskNotificationName.needDismiss object:nil];
    }
    return self;
}

- (instancetype)initWithUserView:(UIView *)uView forMask:(nonnull SDMask*)mask {
    self = [self init];
    if (self) {
        _userView   = uView;
        _thisMask   = mask;
    }
    return self;
}

#pragma mark - Getter & setter

- (SDMaskModel * _Nonnull (^)(NSValue * _Nonnull, NSString * _Nonnull))setAutolayoutValueForKey {
    if(!_autolayoutKeyValues){
        _autolayoutKeyValues = [NSMutableDictionary dictionary];
    }
    return ^id (NSValue *value, NSString *key){
        NSAssert(key != nil && value != nil, @"key or value must not be nil!");
        self->_autolayoutKeyValues[key] = value;
        return self;
    };
}

- (BOOL)isUsingAutolayout {
    if(_isUsingAutolayout){
        return [_isUsingAutolayout boolValue];
    }
    if([_autolayoutKeyValues count]) return YES;
    if([[self.superview constraints] count] > 0) return YES;
    return NO;
}

- (void)setIsUsingAutolayout:(BOOL)isUsingAutolayout {
    _isUsingAutolayout = [NSNumber numberWithBool:isUsingAutolayout];
}

- (id)superview {
    if(!_userView) return nil;
    if([_userView isKindOfClass:[NSArray class]]) {
        return [[_userView firstObject] superview];
    }
    return [_userView superview];
}

- (void)setAnimte:(SDMaskAnimationStyle)animte {
    _animte = animte;
    if(animte == SDMaskAnimationHUD && _dismissDelayTime == 0.0){
        _dismissDelayTime = 1.2;
    }
}

#pragma mark - Autolayout
#define SDMaskAnimationKey @"SDMaskAnimation"
/// private method : Use performSelctor: better.
- (void)updateConstraints {
    do {
        /// SDAutolayout
        if([_autolayoutKeyValues count] > 0) break;
        /// User autolayout
        if([[self.superview constraints] count] == 0) break;
        [self registerCustomConstraints];
        return;
    } while (0);
    [self.userView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSMutableArray *constraintsForSuper     = [NSMutableArray array];
    NSMutableArray *constraintsForUserView  = [NSMutableArray array];
    if(!_autolayoutKeyConstraints){
        _autolayoutKeyConstraints = [NSMutableDictionary dictionary];
    } else {
        [_autolayoutKeyConstraints removeAllObjects];
    }
    /// top, left, right, bottom, centerX, centerY, width, height
    /// size
    for (NSString *key in _autolayoutKeyValues.keyEnumerator) {
        __kindof NSValue *value = _autolayoutKeyValues[key];
        NSLayoutConstraint *cst = nil;
        if([key isEqualToString:@"top"]){
            [constraintsForSuper addObject:cst = [self makeConstraint:NSLayoutAttributeTop value:[value floatValue]]];
            _autolayoutKeyConstraints[key] = cst;
        }
        else if ([key isEqualToString:@"left"]){
            [constraintsForSuper addObject:cst = [self makeConstraint:NSLayoutAttributeLeading value:[value floatValue]]];
            _autolayoutKeyConstraints[key] = cst;
            /// System animation.
            NSLayoutConstraint *leftAnimation = [NSLayoutConstraint constraintWithItem:self.userView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
            leftAnimation.identifier = SDMaskAnimationKey;
            [constraintsForSuper addObject:leftAnimation];
            _autolayoutKeyConstraints[@"leftAnimation"] = leftAnimation;
        }
        else if ([key isEqualToString:@"bottom"]){
            [constraintsForSuper addObject:cst = [self makeConstraint:NSLayoutAttributeBottom value:[value floatValue]]];
            _autolayoutKeyConstraints[key] = cst;
            /// System animation.
            NSLayoutConstraint *bottomAnimation = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.userView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
            bottomAnimation.identifier = SDMaskAnimationKey;
            [constraintsForSuper addObject:bottomAnimation];
            _autolayoutKeyConstraints[@"bottomAnimation"] = bottomAnimation;
        }
        else if ([key isEqualToString:@"right"]){
            [constraintsForSuper addObject:cst = [self makeConstraint:NSLayoutAttributeTrailing value:[value floatValue]]];
            _autolayoutKeyConstraints[key] = cst;
            /// System animation.
            NSLayoutConstraint *rightAnimation = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.userView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
            rightAnimation.identifier = SDMaskAnimationKey;
            [constraintsForSuper addObject:rightAnimation];
            _autolayoutKeyConstraints[@"rightAnimation"] = rightAnimation;

        }
        else if ([key isEqualToString:@"centerX"]){
            [constraintsForSuper addObject:cst = [self makeConstraint:NSLayoutAttributeCenterX value:[value floatValue]]];
            _autolayoutKeyConstraints[key] = cst;
        }
        else if ([key isEqualToString:@"centerY"]){
            [constraintsForSuper addObject:cst = [self makeConstraint:NSLayoutAttributeCenterY value:[value floatValue]]];
            _autolayoutKeyConstraints[key] = cst;
        }
        else if ([key isEqualToString:@"width"]){
            [constraintsForUserView addObject:cst = [self makeConstraint:NSLayoutAttributeWidth value:[value floatValue]]];
            _autolayoutKeyConstraints[key] = cst;
        }
        else if ([key isEqualToString:@"height"]){
            [constraintsForUserView addObject:cst = [self makeConstraint:NSLayoutAttributeHeight value:[value floatValue]]];
            _autolayoutKeyConstraints[key] = cst;
        }
        else if ([key isEqualToString:@"size"]){
            CGSize v = [value CGSizeValue];
            [constraintsForUserView addObject:cst = [self makeConstraint:NSLayoutAttributeWidth value:v.width]];
            _autolayoutKeyConstraints[@"width"] = cst;
            [constraintsForUserView addObject:cst = [self makeConstraint:NSLayoutAttributeHeight value:v.height]];
            _autolayoutKeyConstraints[@"height"] = cst;
        }
        else if ([key isEqualToString:@"insets"]){
            UIEdgeInsets v = [value UIEdgeInsetsValue];
            [constraintsForSuper addObject:cst = [self makeConstraint:NSLayoutAttributeTop value:v.top]];
            _autolayoutKeyConstraints[@"top"] = cst;
            [constraintsForSuper addObject:cst = [self makeConstraint:NSLayoutAttributeLeading value:[value floatValue]]];
            _autolayoutKeyConstraints[@"left"] = cst;
            [constraintsForSuper addObject:cst = [self makeConstraint:NSLayoutAttributeBottom value:[value floatValue]]];
            _autolayoutKeyConstraints[@"bottom"] = cst;
            [constraintsForSuper addObject:cst = [self makeConstraint:NSLayoutAttributeTrailing value:[value floatValue]]];
            _autolayoutKeyConstraints[@"right"] = cst;
        }
    }
    if(constraintsForUserView.count){
        [self.userView addConstraints:constraintsForUserView];
        for (NSLayoutConstraint *item in constraintsForUserView) {
            if([item.identifier isEqualToString:SDMaskAnimationKey]){
                [item setActive:NO];
            }
        }
    }
    if(constraintsForSuper.count){
        [self.superview addConstraints:constraintsForSuper];
        for (NSLayoutConstraint *item in constraintsForSuper) {
            if([item.identifier isEqualToString:SDMaskAnimationKey]){
                [item setActive:NO];
            }
        }
    }
}

- (NSLayoutConstraint*)makeConstraint:(NSLayoutAttribute)attr value:(CGFloat)value {
    NSLayoutConstraint *cst = nil;
    id firstItem, secondItem;
    NSLayoutAttribute firstAttr     = attr;
    NSLayoutAttribute secondAttr    = attr;
    do {
        if(attr == NSLayoutAttributeTrailing || attr == NSLayoutAttributeRight || attr == NSLayoutAttributeBottom) {
            firstItem   = self.superview;
            secondItem  = self.userView;
            break;
        }
        if(attr == NSLayoutAttributeWidth || attr == NSLayoutAttributeHeight) {
            firstItem   = self.userView;
            secondItem  = nil;
            secondAttr  = NSLayoutAttributeNotAnAttribute;
            break;
        }
        /// Default
        {
            firstItem   = self.userView;
            secondItem  = self.superview;
        }
    } while (0);
    cst = [NSLayoutConstraint constraintWithItem:firstItem
                                       attribute:firstAttr
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:secondItem
                                        attribute:secondAttr
                                       multiplier:1.0
                                         constant:value];
    /// Adapt UIView-Encapsulated-Layout
    [cst setPriority:(UILayoutPriorityRequired - 1)];
    return cst;
}

/// Translate original constraints to SDMask infomation.
- (void)registerCustomConstraints {
    [self.userView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSArray<NSLayoutConstraint*>* cstForUserView = [self.userView constraints];
    NSArray<NSLayoutConstraint*>* cstForSuperview= [self.superview constraints];
    if(!_autolayoutKeyConstraints){
        _autolayoutKeyConstraints = [NSMutableDictionary dictionary];
    }
    for (NSLayoutConstraint *cst in cstForUserView) {
        if(cst.firstAttribute == NSLayoutAttributeWidth && cst.firstItem == self.userView && cst.secondItem == nil){
            _autolayoutKeyConstraints[@"width"] = cst;
        }
        else if(cst.firstAttribute == NSLayoutAttributeHeight && cst.firstItem == self.userView && cst.secondItem == nil){
            _autolayoutKeyConstraints[@"height"] = cst;
        }
    }
    for (NSLayoutConstraint *cst in cstForSuperview) {
        NSLayoutAttribute attr  = NSLayoutAttributeNotAnAttribute;
        id key                  = nil;
        if (__builtin_available(iOS 9.0, *)) {
            if(cst.firstItem == self.userView  && (cst.secondItem == self.superview || [cst.secondItem isKindOfClass:[NSLayoutAnchor class]])){
                attr = cst.firstAttribute;
            }
            else if((cst.firstItem == self.superview || [cst.firstItem isKindOfClass:[NSLayoutAnchor class]])
                    && cst.secondItem == self.userView){
                attr = cst.secondAttribute;
            }
        } else {
            if(cst.firstItem == self.userView && cst.secondItem == self.superview){
                attr = cst.firstAttribute;
            }
            else if(cst.firstItem == self.superview && cst.secondItem == self.userView){
                attr = cst.secondAttribute;
            }
        }
        switch (attr) {
            case NSLayoutAttributeTop:
            {
                key = @"top";
            }
                break;
            case NSLayoutAttributeLeft:
            case NSLayoutAttributeLeading:
            {
                key = @"left";
                {
                    NSLayoutConstraint *leftAnimation = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.userView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
                    [leftAnimation setIdentifier:SDMaskAnimationKey];
                    _autolayoutKeyConstraints[@"leftAnimation"] = leftAnimation;
                    [leftAnimation setPriority:(UILayoutPriorityRequired -1)];
                    [self.superview addConstraint:leftAnimation];
                    [leftAnimation setActive:NO];
                }
            }
                break;
            case NSLayoutAttributeBottom:
            {
                key = @"bottom";
                {
                    NSLayoutConstraint *bottomAnimation = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.userView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
                    [bottomAnimation setIdentifier:SDMaskAnimationKey];
                    _autolayoutKeyConstraints[@"bottomAnimation"] = bottomAnimation;
                    [bottomAnimation setPriority:(UILayoutPriorityRequired -1)];
                    [self.superview addConstraint:bottomAnimation];
                    [bottomAnimation setActive:NO];
                }
            }
                break;
            case NSLayoutAttributeRight:
            case NSLayoutAttributeTrailing:
            {
                key = @"right";
                {
                    NSLayoutConstraint *rightAnimation = [NSLayoutConstraint constraintWithItem:self.userView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
                    [rightAnimation setIdentifier:SDMaskAnimationKey];
                    _autolayoutKeyConstraints[@"rightAnimation"] = rightAnimation;
                    [rightAnimation setPriority:(UILayoutPriorityRequired -1)];
                    [self.superview addConstraint:rightAnimation];
                    [rightAnimation setActive:NO];
                }
            }
                break;
            case NSLayoutAttributeCenterX:
            {
                key = @"centerX";
            }
                break;
            case NSLayoutAttributeCenterY:
            {
                key = @"centerY";
            }
                break;
            default: break;
        }
        if(key) _autolayoutKeyConstraints[key] = cst;
    }
}

#pragma mark - Notification
- (void)whatNotification:(NSNotification*)notify {
    if(notify.object && notify.object != self.thisMask && notify.object != self.userView) return;
    
    if([notify.name isEqualToString:SDMaskNotificationName.needDismiss]){
        [(id<SDMaskProtocol>)self.thisMask dismiss];
    }
}

#pragma mark - Config

static UIColor *_defaultBackgroundColor;
+ (UIColor *)defaultBackgroundColor {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultBackgroundColor = [UIColor colorWithRed:0.1459 green:0.1459 blue:0.1459 alpha:0.618];
    });
    return _defaultBackgroundColor;
}

+ (void)setDefaultBackgroundColor:(UIColor *)defaultBackgroundColor {
    _defaultBackgroundColor = defaultBackgroundColor;
}

+ (CGFloat)screenWidth {
    static CGFloat _screenWidth;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _screenWidth = UIScreen.mainScreen.bounds.size.width;
    });
    return _screenWidth;
}

+ (CGFloat)screenHeight {
    static CGFloat _screenHeight;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _screenHeight = UIScreen.mainScreen.bounds.size.height;
    });
    return _screenHeight;
}

+ (BOOL)screenIsShaped {
    if (@available(iOS 11.0, *)) {
        return self.keyWindow.safeAreaInsets.bottom > 0.0;
    }
    return NO;
}

+ (UIWindow*)keyWindow {
    UIWindow        *foundWindow = nil;
    NSArray         *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow   *window in windows) {
        if (window.isKeyWindow) {
            foundWindow = window;
            break;
        }
    }
    return foundWindow;
}

- (UIWindow *)associatedWindow {
    if(!_associatedWindow) {
        _associatedWindow = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _associatedWindow.rootViewController = [[UIViewController alloc] init];
        _associatedWindow.windowLevel = UIWindowLevelAlert + 1;
    }
    return _associatedWindow;
}
@end

/**

 /// From IQUIView+Hierarchy.h
 + (UIViewController *)topMostControllerForView:(UIView*)view {
     NSMutableArray<UIViewController*> *controllersHierarchy = [[NSMutableArray alloc] init];
     UIViewController *topController = view.window.rootViewController;
     if (topController) {
         [controllersHierarchy addObject:topController];
     }
     while ([topController presentedViewController]) {
         topController = [topController presentedViewController];
         [controllersHierarchy addObject:topController];
     }
     UIViewController *matchController = [SDMaskModel viewContainingControllerForView:view];
     while (matchController && [controllersHierarchy containsObject:matchController] == NO) {
         do {
             matchController = (UIViewController*)[matchController nextResponder];
         } while (matchController && [matchController isKindOfClass:[UIViewController class]] == NO);
     }
     return matchController;
 }

 /// From IQUIView+Hierarchy.h
 + (UIViewController*)viewContainingControllerForView:(UIView*)view {
     UIResponder *nextResponder =  view;
     do {
         nextResponder = [nextResponder nextResponder];
         if ([nextResponder isKindOfClass:[UIViewController class]])
             return (UIViewController*)nextResponder;

     } while (nextResponder);

     return nil;
 }
 */
