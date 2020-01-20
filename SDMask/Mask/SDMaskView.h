//
//  SDMaskView.h
//  SDMask
//
//  Created by MeterWhite on 2019/11/15.
//  Copyright © 2019 Meterwhite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDMaskProtocol.h"

#pragma mark - Class : SDMaskView
/// Display SDMask in a view.Documentation in 'SDMaskInterface.h' 
@interface SDMaskView : UIButton
<
    SDMaskProtocol
>
@end

