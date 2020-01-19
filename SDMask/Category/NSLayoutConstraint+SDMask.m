//
//  NSLayoutConstraint+SDMask.m
//  SDMask
//
//  Created by MeterWhite on 2019/11/25.
//  Copyright © 2019 Meterwhite. All rights reserved.
//

#import "NSLayoutConstraint+SDMask.h"

static NSMapTable<NSLayoutConstraint*,NSNumber*> *_constraintSnapshot_map;
static dispatch_semaphore_t _constraintSnapshot_map_lock;

@implementation NSLayoutConstraint (SDMask)

- (CGFloat)constantSnapshot {
    if(!_constraintSnapshot_map) return CGFLOAT_MAX;
    NSNumber *nconstant = [_constraintSnapshot_map objectForKey:self];
    if(!nconstant) return CGFLOAT_MAX;
#if defined(__LP64__) && __LP64__
    return [nconstant doubleValue];
#else
    return [nconstant floatValue];
#endif
}

- (void)takeConstantSnapshot {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _constraintSnapshot_map = [NSMapTable mapTableWithKeyOptions: NSPointerFunctionsWeakMemory | NSPointerFunctionsOpaquePersonality valueOptions: NSPointerFunctionsStrongMemory | NSPointerFunctionsObjectPersonality];
        _constraintSnapshot_map_lock = dispatch_semaphore_create(1);
    });
    dispatch_semaphore_wait(_constraintSnapshot_map_lock, DISPATCH_TIME_FOREVER);
#if defined(__LP64__) && __LP64__
    [_constraintSnapshot_map setObject:[NSNumber numberWithDouble:self.constant] forKey:self];
#else
    [_constraintSnapshot_map setObject:[NSNumber numberWithFloat:self.constant] forKey:self];
#endif
    dispatch_semaphore_signal(_constraintSnapshot_map_lock);
}

@end
