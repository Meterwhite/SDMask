//
//  SDHudView.h
//  Novo
//
//  Created by Novo on 16/1/6.
//  Copyright © 2016年 Novo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/**
 内容视图显示动画
 */
typedef enum EnumSDHudViewContentAnimateStyle{
    /**
     *  自然出现，默认
     */
    EnumSDHudViewAnimateStyleImmedia,
    /**
     *  从HUD上端移动到指定位置
     */
    EnumSDHudViewAnimateStyleFromTop,
    /**
     *  屏幕底部移动到指定位置
     */
    EnumSDHudViewAnimateStyleFromBottom,
    /**
     *  从小到大放大
     */
    EnumSDHudViewAnimateStyleFromSmallSize
}EnumSDHudViewContentAnimateStyle;

/**
 内容视图位置
 */
typedef enum EnumSDHudViewContentPositionStyle{
    /**
     *  HUD中间，默认
     */
    EnumSDHudViewPositionStyleCenter,
    /**
     *  HUD顶部
     */
    EnumSDHudViewPositionStyleTop,
    /**
     *  屏幕底部
     */
    EnumSDHudViewPositionStyleBottom
}EnumSDHudViewContentPositionStyle;

/**
 *  蒙版
 */
@interface SDHudView : UIView



#pragma mark - 主要
/** 内容视图动画样式 */
@property (nonatomic,assign) EnumSDHudViewContentAnimateStyle contentAnimateStyle;
/** 内容视图真实位置 */
@property (nonatomic,assign) EnumSDHudViewContentPositionStyle contentPositionStyle;

/** 初始化并添加到父视图 */
- (instancetype)initFromSuperView:(UIView*)superView;
/** 添加到父视图 */
- (void)addToSuperView:(UIView*)superView;
/** 每次显示前添加内容视图，内容和Hud会同处一个容器，而不是Hud的子视图 */
- (void)addContentView:(id)view;
/** 显示HUD和内容视图 */
- (void)uiShowWithContentView:(id)view;
/** 显示HUD和内容视图 */
- (void)uiShow;
/** 收起，收起之后内容视图被移除 */
- (void)uiHidden;



#pragma mark - 次要
/** 显示动画耗时 */
@property (nonatomic,assign) double timeShowDuring;
/** 收起动画耗时 */
@property (nonatomic,assign) double timeHiddenDuring;
/** 蒙版最终透明度 */
@property (nonatomic,assign) double alphaContentEnd;
/** 内容视图在y轴的偏移 */
@property (nonatomic,assign) CGFloat contentYOffset;
/** 内容视图在x轴的偏移 */
@property (nonatomic,assign) CGFloat contentXOffset;
/** 默认NO，触摸蒙版是否隐藏 */
@property (nonatomic,assign) BOOL isHiddenWhenTouch;
/** 内容视图是否是在显示中 */
@property (nonatomic,assign,readonly) BOOL isShowing;

/** 蒙版尺寸参考父视图 */
- (void)uiFrameCopySuper;
/** 自定义的布局 */
- (void)contentLayoutInSuperUsingBlock:(void(^)(UIView* contentView))block;
/** 显示动画完成后的回调 */
- (void)eventDidContentViewShow:(void(^)())block;
/** 收起动画完成后的回调 */
- (void)eventDidContentViewHidden:(void(^)())block;



@end
