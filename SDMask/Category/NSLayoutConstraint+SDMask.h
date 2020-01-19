//
//  NSLayoutConstraint+SDMask.h
//  SDMask
//
//  Created by MeterWhite on 2019/11/25.
//  Copyright © 2019 Meterwhite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (SDMaskExtension)
/**
 * Return CGFLOAT_MAX if not have a snapshot of constant.
 */
@property (nonatomic,readonly) CGFloat constantSnapshot;
/// Thread safe.
- (void)takeConstantSnapshot;
@end
