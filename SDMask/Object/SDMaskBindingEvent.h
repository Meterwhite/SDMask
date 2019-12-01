//
//  SDMaskBindingEvent.h
//  SDMask
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
/// Kind of UIView.
@property (nullable,nonatomic,weak,readonly) id sender;
/// -1 for cancel control.
@property (nonatomic,readonly) NSInteger index;
@property (nullable,nonatomic,weak,readonly) SDMaskModel<TUserView> *model;
/// This key is from 'sdm_withBindingKey:'
@property (nullable,nonatomic,copy,readonly) id key;

- (nonnull instancetype)initWithSender:(nonnull UIView*)sender model:(nonnull SDMaskModel*)model atIndex:(NSInteger)index;
/// The default behavior that the bind event will trigger dismiss.This method counld keeps the mask on the screen.
- (void)setNeedKeepMask;
@end

