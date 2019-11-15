//
//  TUserAlertView.m
//  SDMask
//
//  Created by MeterWhite on 2019/11/13.
//  Copyright © 2019 MeterWhite. All rights reserved.
//

#import "TUserAlertView.h"

@implementation TUserAlertView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setClipsToBounds:YES];
    [self.layer setCornerRadius:4];
}

- (void)dealloc
{
    NSLog(@"dealloc for : %p",self);
}

@end
