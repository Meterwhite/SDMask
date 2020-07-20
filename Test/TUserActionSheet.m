//
//  TUserActionSheet.m
//  SDMask
//  https://github.com/Meterwhite/SDMask
//
//  Created by MeterWhite on 2019/11/13.
//  Copyright © 2019 MeterWhite. All rights reserved.
//

#import "TUserActionSheet.h"

@implementation TUserActionSheet
- (void)dealloc
{
    NSLog(@"dealloc for : %p",self);
}

- (void)didTapSomething:(void (^)(void))block{}
@end
