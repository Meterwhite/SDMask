//
//  SDMaskNotificationName.h
//  SDMask
//
//  Created by MeterWhite on 2019/11/25.
//  Copyright © 2019 Meterwhite. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDMaskNotificationName : NSString
#pragma mark - User post notification
/**
 * Dismiss specified or all mask view.
 * object = nil : dismiss all mask view.
 * object = Specified mask view or user view.
 */
@property (nonatomic,readonly,class,copy) NSString *needDismiss;
#pragma mark - User observed notification
/**
 * Get event object using nofication.
 * userInfo[@"event"] = SDMaskBindingEvent
 */
@property (nonatomic,readonly,class,copy) NSString *userInteraction;

#pragma mark - System notification
/// ...
@end

NS_ASSUME_NONNULL_END
