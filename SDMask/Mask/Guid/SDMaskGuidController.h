//
//  SDMaskGuidController.h
//  SDMask
//
//  Created by MeterWhite on 2020/1/16.
//  Copyright © 2020 Meterwhite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDMaskProtocol.h"
/**
 * Tag of subviews is start with -1 and decrease.
 */
@interface SDMaskGuidController : UIViewController
<
    SDMaskGuidProtocol
>

/// Not suport setAutolayoutValueForKey(...)
@property (nullable,nonatomic,readonly) NSArray <UIView *> * userView;
- (nonnull instancetype)initWithUserView:(nonnull NSArray <UIView *> *)uView;
#pragma mark - Pages
- (nonnull instancetype)pageDidLoad:(nonnull SDMaskUserBlock)block;
#pragma mark - Like cycle
/// <#Description#>
/// @param block <#block description#>
- (nonnull instancetype)userViewDidLoad:(nonnull SDMaskUserBlock)block;
- (nonnull instancetype)userViewDidDisappear:(nonnull SDMaskUserBlock)block;

@end
