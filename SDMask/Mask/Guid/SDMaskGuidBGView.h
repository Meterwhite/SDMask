//
//  SDMaskGuidBGView.h
//  SDMask
//
//  Created by MeterWhite on 2020/1/16.
//  Copyright © 2020 Meterwhite. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDMaskModel;
@protocol SDMaskGuidBGViewDelegate <NSObject>
- (void)didTapedBackgroud:(nullable NSArray<UIView *> *)guidViews page:(NSInteger)tag;
- (void)pagesShowCompleted;
@end

@interface SDMaskGuidBGView : UIView
@property (nullable,nonatomic,strong) UIColor *maskColor;
@property (nullable,nonatomic,weak) id<SDMaskGuidBGViewDelegate> delegate;
/// NSNotFound means end of page.
@property (nonatomic,readonly) NSInteger  page;
@property (nonatomic,readonly) NSUInteger totalPage;
/// Tells the class that it is hooked to a view .Called while nib of controller's view is loaded;
- (void)didHook;
/// Page by page.
- (void)showPage;
@end

