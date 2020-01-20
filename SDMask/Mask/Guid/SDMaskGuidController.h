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
 * Create a controller that inherits from SDMaskGuidController,Set constraints and tags for each page in XIB file, Where tag starts from -1 and decreases.
 * Views with the same tag value are displayed as one page
 * Then set the background color in -userViewDidLoad: to make the page color consistent.Finally call -show
 * If the controller is not loaded from a XIB file, the user can use initWithUserView: to initialize it. Then do the view layout in userViewDidLoad :.
 *
 * Note
 * :
 * page = ABS(view.tag)
 * If there are intersections of views on the same page, ensure that the total number of intersections is odd.
 * This can be achieved by adding views in the intersection section.
 * (同一页中视图如果存在交集应确保交集的总数是奇数次，可以通过在交集部分添加一个新视图来实现。)
 *
 */
@interface SDMaskGuidController : UIViewController
<
    SDMaskGuidProtocol
>

@property (nullable,nonatomic,readonly) NSArray <UIView *> * userView;
/// Initializing the controller without using XIB file.
/// @param uView Views of all pages.
- (nonnull instancetype)initWithUserView:(nonnull NSArray <UIView *> *)uView;
#pragma mark - Pages
/// Called when each page loads.
/// @param block Not suport setAutolayoutValueForKey(...)
- (nonnull instancetype)pageDidLoad:(nonnull SDMaskUserBlock)block;
#pragma mark - Like cycle
/// Config work.
/// @param block Set background color in the block.
- (nonnull instancetype)userViewDidLoad:(nonnull SDMaskUserBlock)block;
- (nonnull instancetype)userViewDidDisappear:(nonnull SDMaskUserBlock)block;
@end
