//
//  SDMaskBindingEvent.h
//  SDMask
//  https://github.com/Meterwhite/SDMask
//
//  Created by MeterWhite on 2019/11/12.
//  Copyright © 2019 MeterWhite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SDMaskModel.h"

/**
 *  This object is from user`s interaction.
 */
@interface SDMaskBindingEvent<__covariant TUserView> : NSObject
/// UIView.
@property (nullable,nonatomic,weak,readonly) id sender;
/// 绑定的事件的索引
/// -1 : cancel control.
@property (nonatomic,readonly) NSInteger index;
/// 模型
@property (nullable,nonatomic,weak,readonly) SDMaskModel<TUserView> *model;
/// This key is from 'sdm_withBindingKey:'；指定的key可以代替index使用
@property (nullable,nonatomic,copy,readonly) id key;

- (nonnull instancetype)initWithSender:(nonnull UIView*)sender model:(nonnull SDMaskModel*)model atIndex:(NSInteger)index;
/// Change the default folding behavior after the mask is touched.
/// 改变蒙板触摸后默认的收起行为.
- (void)setNeedKeepMask;
@end

