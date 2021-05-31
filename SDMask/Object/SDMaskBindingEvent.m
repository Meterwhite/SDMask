//
//  SDMaskBindingEvent.m
//  SDMask
//  https://github.com/Meterwhite/SDMask
//
//  Created by MeterWhite on 2019/11/12.
//  Copyright © 2019 MeterWhite. All rights reserved.
//

#import "SDMaskNotificationName.h"
#import "SDMaskBindingEvent.h"
#import "UIResponder+SDMask.h"
#import "SDMaskInterface.h"
#import "SDMaskProtocol.h"
#import "SDMaskModel.h"

@interface SDMaskBindingEvent ()
@property UIView *sender;
@end

@implementation SDMaskBindingEvent {
    BOOL _needKeepMask;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _needKeepMask = NO;
    }
    return self;
}

- (instancetype)initWithSender:(id)sender model:(SDMaskModel *)model atIndex:(NSInteger)index {
    if(self = [self init]){
        _sender = sender;
        _model = model;
        _index = index;
        do {
            /// UIButton
            if([sender respondsToSelector:@selector(addTarget:action:forControlEvents:)]){
                [sender addTarget:self action:@selector(actionTap:) forControlEvents:UIControlEventTouchUpInside];
                break;
            }
            /// Using gesture
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
            [sender addGestureRecognizer:tap];
        } while (0);
    }
    return self;
}

/// First action.
/// @param object object could from UIButton or Gesture.
- (void)actionTap:(id)object {
    SDMaskUserBindingEventBlock eventCenterBlock = [self.model valueForKey:@"_blockForBindingEventsUsingBlock"];
    NSMapTable *                eventMap         = [self.model valueForKey:@"_blockForBindingEventForUsingBlock"];
    SDMaskUserBindingEventBlock eventBlock = nil;
    UIView *                    control    = nil;
    /// Event center first.
    self.model.latestEvent = self;
    if(eventCenterBlock) eventCenterBlock(self);
    /// Single event.
    do {
        if([(control = object) isKindOfClass:UIView.class]) break;
        if ((void)([object isKindOfClass:UIGestureRecognizer.class]), control = [object view]) break;
    } while (0);
    do {
        /// Order : Control -> @index -> key
        if((eventBlock = [eventMap objectForKey:control])) break;
        if ((eventBlock = [eventMap objectForKey:@(self.index)])) break;
        if (self.key && (eventBlock = [eventMap objectForKey:self.key])) break;
    } while (0);
    if(eventBlock) eventBlock(self);
    [[NSNotificationCenter defaultCenter] postNotificationName:SDMaskNotificationName.userInteraction object:control userInfo:@{@"event":self}];
    /// Handling default behavior.
    if(self.index == -1 || _needKeepMask == NO) [self.model.thisMask dismiss];
}

- (NSString *)key {
    return self.sender.sdm_bindingKey;
}

- (void)setNeedKeepMask {
    _needKeepMask = YES;
}
@end
