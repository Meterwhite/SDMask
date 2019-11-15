//
//  SDMaskModel.m
//  SDMask
//
//  Created by MeterWhite on 2019/11/8.
//  Copyright © 2019 MeterWhite. All rights reserved.
//

#import <objc/runtime.h>
#import "UIResponder+SDMask.h"
#import "SDMaskController.h"
#import "SDMaskModel.h"
#import "SDMaskProtocol.h"

@implementation SDMaskModel
{
    __weak UIViewController*    _currentController;
    SDMaskBindingEvent*         _cancelEvent;
    NSArray*                    _bindingEvents;
    SDMaskUserBindingEventBlock _blockForBindingEventsUsingBlock;
    NSMutableDictionary<id,SDMaskUserBindingEventBlock>* _blockForBindingEventForUsingBlock;
    NSMutableDictionary*        _autolayoutKeyValues;
    NSMutableDictionary*        _autolayoutKeyConstraints;
    NSNumber*                   _isUsingAutolayout;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dismissTime            = 0.25;
        _presentTime            = 0.2;
        _usingSystemAnimation   = YES;
        _autoDismiss            = NO;
    }
    return self;
}

- (instancetype)initWithUserView:(UIView *)view forMask:(nonnull id<SDMask>)mask
{
    self = [self init];
    if (self) {
        _userView   = view;
        _thisMask   = mask;
    }
    return self;
}

#pragma mark - Getter & setter

- (void)setAnimte:(SDMaskAnimationStyle)animte
{
    _animte = animte;
    if(animte == SDMaskAnimationAlert){
        _autoDismiss = NO;
    } else if (animte == SDMaskAnimationActionSheet){
        _autoDismiss = YES;
    }
}

- (SDMaskModel * _Nonnull (^)(NSValue * _Nonnull, NSString * _Nonnull))setAutolayoutValueForKey
{
    if(!_autolayoutKeyValues){
        _autolayoutKeyValues = [NSMutableDictionary dictionary];
    }
    return ^id (NSValue* value, NSString* key){
        NSAssert(key != nil && value != nil, @"key or value must not be nil!");
        self->_autolayoutKeyValues[key] = value;
        return self;
    };
}

- (BOOL)isUsingAutolayout
{
    if(_isUsingAutolayout){
        return [_isUsingAutolayout boolValue];
    }
    if([_autolayoutKeyValues count]) return YES;
    if([[self.containerView constraints] count] > 0) return YES;
    return NO;
}

- (void)setIsUsingAutolayout:(BOOL)isUsingAutolayout
{
    _isUsingAutolayout = [NSNumber numberWithBool:isUsingAutolayout];
}

- (id)containerView
{
    return self.userView.superview;
}

#pragma mark - Autolayout
/// private method : Use performSelctor: better.
- (void)updateConstraints
{
    do {
        /// SDAutolayout
        if([_autolayoutKeyValues count] > 0) break;
        /// User autolayout
        if([[self.containerView constraints] count] == 0) break;
        [self registerCustomConstraints];
        return;
    } while (0);
    [self.userView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSMutableArray* constraintsForSuper     = [NSMutableArray array];
    NSMutableArray* constraintsForUserView  = [NSMutableArray array];
    if(!_autolayoutKeyConstraints){
        _autolayoutKeyConstraints = [NSMutableDictionary dictionary];
    } else {
        [_autolayoutKeyConstraints removeAllObjects];
    }
    /// top, left, right, bottom, centerX, centerY, width, height
    /// size
    for (NSString* key in _autolayoutKeyValues.keyEnumerator) {
        __kindof NSValue* value = _autolayoutKeyValues[key];
        NSLayoutConstraint* cst = nil;
        if([key isEqualToString:@"top"]){
            [constraintsForSuper addObject:cst = [self makeConstraint:NSLayoutAttributeTop value:[value floatValue]]];
            _autolayoutKeyConstraints[key] = cst;
        }
        else if ([key isEqualToString:@"left"]){
            [constraintsForSuper addObject:cst = [self makeConstraint:NSLayoutAttributeLeading value:[value floatValue]]];
            _autolayoutKeyConstraints[key] = cst;
        }
        else if ([key isEqualToString:@"bottom"]){
            [constraintsForSuper addObject:cst = [self makeConstraint:NSLayoutAttributeBottom value:[value floatValue]]];
            _autolayoutKeyConstraints[key] = cst;
            NSLayoutConstraint* bottomAnimation = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.userView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
            bottomAnimation.identifier = @"animation";
            [constraintsForSuper addObject:bottomAnimation];
            _autolayoutKeyConstraints[@"bottomAnimation"] = bottomAnimation;
        }
        else if ([key isEqualToString:@"right"]){
            [constraintsForSuper addObject:cst = [self makeConstraint:NSLayoutAttributeTrailing value:[value floatValue]]];
            _autolayoutKeyConstraints[key] = cst;
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
        for (NSLayoutConstraint* item in constraintsForUserView) {
            if([item.identifier isEqualToString:@"animation"]){
                [item setActive:NO];
            }
        }
    }
    if(constraintsForSuper.count){
        [self.containerView addConstraints:constraintsForSuper];
        for (NSLayoutConstraint* item in constraintsForSuper) {
            if([item.identifier isEqualToString:@"animation"]){
                [item setActive:NO];
            }
        }
    }
}

- (NSLayoutConstraint*)makeConstraint:(NSLayoutAttribute)attr value:(CGFloat)value
{
    NSLayoutConstraint* cst = nil;
    id firstItem, secondItem;
    NSLayoutAttribute firstAttr     = attr;
    NSLayoutAttribute secondAttr    = attr;
    do {
        if(attr == NSLayoutAttributeTrailing || attr == NSLayoutAttributeRight || attr == NSLayoutAttributeBottom) {
            firstItem   = self.containerView;
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
            secondItem  = self.containerView;
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
- (void)registerCustomConstraints
{
    [self.userView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSArray<NSLayoutConstraint*>* cstForUserView = [self.userView constraints];
    NSArray<NSLayoutConstraint*>* cstForContainer = [self.containerView constraints];
    if(!_autolayoutKeyConstraints){
        _autolayoutKeyConstraints = [NSMutableDictionary dictionary];
    }
    for (NSLayoutConstraint* cst in cstForUserView) {
        if(cst.firstAttribute == NSLayoutAttributeWidth && cst.firstItem == self.userView && cst.secondItem == nil){
            _autolayoutKeyConstraints[@"width"] = cst;
        }
        else if(cst.firstAttribute == NSLayoutAttributeHeight && cst.firstItem == self.userView && cst.secondItem == nil){
            _autolayoutKeyConstraints[@"height"] = cst;
        }
    }
    for (NSLayoutConstraint* cst in cstForContainer) {
        NSLayoutAttribute attr  = NSLayoutAttributeNotAnAttribute;
        id key                  = nil;
        if (__builtin_available(iOS 9.0, *)) {
            if(cst.firstItem == self.userView  && (cst.secondItem == self.containerView || [cst.secondItem isKindOfClass:[NSLayoutAnchor class]])){
                attr = cst.firstAttribute;
            }
            else if((cst.firstItem == self.containerView || [cst.firstItem isKindOfClass:[NSLayoutAnchor class]])
                    && cst.secondItem == self.userView){
                attr = cst.secondAttribute;
            }
        } else {
            if(cst.firstItem == self.userView && cst.secondItem == self.containerView){
                attr = cst.firstAttribute;
            }
            else if(cst.firstItem == self.containerView && cst.secondItem == self.userView){
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
            }
                break;
            case NSLayoutAttributeBottom:
            {
                key = @"bottom";
                {
                    NSLayoutConstraint* bottomAnimation = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.userView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
                    _autolayoutKeyConstraints[@"bottomAnimation"] = bottomAnimation;
                    [bottomAnimation setPriority:(UILayoutPriorityRequired -1)];
                    [self.containerView addConstraint:bottomAnimation];
                    [bottomAnimation setActive:NO];
                }
            }
                break;
            case NSLayoutAttributeRight:
            case NSLayoutAttributeTrailing:
            {
                key = @"right";
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

#pragma mark - Config

+ (UIColor *)defaultBackgroundColor
{
    static UIColor* _defaultBackgroundColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultBackgroundColor = [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:0.62];
    });
    return _defaultBackgroundColor;
}

+ (CGFloat)screenWidth
{
    static CGFloat _screenWidth;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _screenWidth = UIScreen.mainScreen.bounds.size.width;
    });
    return _screenWidth;
}

+ (CGFloat)screenHeight
{
    static CGFloat _screenHeight;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _screenHeight = UIScreen.mainScreen.bounds.size.height;
    });
    return _screenHeight;
}

- (UIViewController *)currentController
{
    if(_currentController){
        return _currentController;
    }
    if([object_getClass(self.thisMask) isSubclassOfClass:UIView.class]){
        return [self.class topMostControllerForView:(id)self.thisMask];
    }
    return [self.class findTopAlertableController:(id)[NSNull null]];
}

+ (UIViewController*)findTopAlertableController:(UIViewController*)vc
{
    if(!vc) return nil;
    if(vc == ((id)[NSNull null])) vc = [self keyWindow].rootViewController;
    if (vc.presentedViewController) {
        // Return presented view controller
        return [self findTopAlertableController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findTopAlertableController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findTopAlertableController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if(svc.viewControllers.count > 5 && svc.selectedIndex >= 4)
            return [self findTopAlertableController:svc.moreNavigationController];
        else if (svc.viewControllers.count > 0)
            return [self findTopAlertableController:svc.selectedViewController];
    }
    /// Parent controller of child controller to present view may be more appropriate.
    //else if(vc.childViewControllers.count > 0){
    //    // Unknown view controller type, return first child view controller
    //    return vc.childViewControllers.firstObject;
    //}
    return vc;
}

/// From IQUIView+Hierarchy.h
+ (UIViewController *)topMostControllerForView:(UIView*)view;
{
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
+ (UIViewController*)viewContainingControllerForView:(UIView*)view
{
    UIResponder *nextResponder =  view;
    do {
        nextResponder = [nextResponder nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;

    } while (nextResponder);

    return nil;
}

+ (BOOL)screenIsShaped
{
    if (@available(iOS 11.0, *)) {
        return self.keyWindow.safeAreaInsets.bottom > 0.0;
    }
    return NO;
}

+ (UIWindow*)keyWindow
{
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
@end
