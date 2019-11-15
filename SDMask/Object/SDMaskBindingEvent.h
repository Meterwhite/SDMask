//
//  SDMaskBindingEvent.h
//  SDMask
//
//  Created by MeterWhite on 2019/11/12.
//  Copyright © 2019 MeterWhite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SDMaskModel;
/**
 *  This object is from user interaction.
 */
@interface SDMaskBindingEvent : NSObject

@property (nullable,nonatomic,weak,readonly) UIView *sender;
/// -1 for cancel control.
@property (nonatomic,readonly) NSInteger index;
@property (nullable,nonatomic,weak,readonly) SDMaskModel *model;
/// This key is from 'sdm_withBindingKey:'
@property (nullable,nonatomic,copy,readonly) id key;

- (nonnull instancetype)initWithSender:(nonnull UIView*)sender model:(nonnull SDMaskModel*)model atIndex:(NSInteger)index;
/// The default behavior that the bind event will trigger dismiss.This method counld keeps the mask on the screen.
- (void)setNeedKeepMask;
@end

