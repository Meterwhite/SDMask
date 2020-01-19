//
//  SDMaskNotificationName.m
//  SDMask
//
//  Created by MeterWhite on 2019/11/25.
//  Copyright © 2019 Meterwhite. All rights reserved.
//

#import "SDMaskNotificationName.h"

@implementation SDMaskNotificationName

//static NSString *_didLoad       = @"SDMask/Notification/load/did";
static NSString *_needDismiss   = @"SDMask/Notification/dismiss/need";
//static NSString *_willDismiss   = @"SDMask/Notification/dismiss/will";
//static NSString *_didDismiss    = @"SDMask/Notification/dismiss/did";
//static NSString *_willPresent   = @"SDMask/Notification/present/will";
//static NSString *_didPresent    = @"SDMask/Notification/present/did";
static NSString *_userInteraction   = @"SDMask/Notification/interaction";

+ (NSString *)needDismiss {
    return _needDismiss;
}

+ (NSString *)userInteraction {
    return _userInteraction;
}
@end
