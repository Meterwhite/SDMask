//
//  TUserActionSheet.h
//  SDMask
//  https://github.com/Meterwhite/SDMask
//
//  Created by MeterWhite on 2019/11/13.
//  Copyright © 2019 MeterWhite. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TUserActionSheet : UIView
@property (weak, nonatomic) IBOutlet UILabel *action0;
@property (weak, nonatomic) IBOutlet UIButton *action1;
@property (weak, nonatomic) IBOutlet UILabel *actionCancel_1;

- (void)didTapSomething:(void(^)(void))block;
@end

NS_ASSUME_NONNULL_END
