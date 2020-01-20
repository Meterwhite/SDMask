//
//  SDMaskGuidBGView.m
//  SDMask
//
//  Created by MeterWhite on 2020/1/16.
//  Copyright © 2020 Meterwhite. All rights reserved.
//

#import "SDMaskGuidBGView.h"

@interface SDMaskGuidBGView ()
@property (nonatomic,weak) CALayer *backgroundLayer;
@end

@implementation SDMaskGuidBGView

#pragma mark - Properies
static NSMapTable<SDMaskGuidBGView *,CALayer *> *_bg_layer_map;
static NSMapTable<SDMaskGuidBGView *,UIColor *> *_bg_color_map;
static NSMapTable<SDMaskGuidBGView *,id<SDMaskGuidBGViewDelegate>> *_delegate_map;

- (CALayer *)backgroundLayer {
    if(!_bg_layer_map) return nil;
    return [_bg_layer_map objectForKey:self];
}

- (void)setBackgroundLayer:(CALayer *)backgroundLayer {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _bg_layer_map = [NSMapTable mapTableWithKeyOptions: NSPointerFunctionsWeakMemory | NSPointerFunctionsOpaquePersonality valueOptions: NSPointerFunctionsWeakMemory | NSPointerFunctionsObjectPersonality];
    });
    if(backgroundLayer == nil) {
        [_bg_layer_map removeObjectForKey:self];
    } else {
        [_bg_layer_map setObject:backgroundLayer forKey:self];
    }
}

- (id<SDMaskGuidBGViewDelegate>)delegate {
    if(!_delegate_map) return nil;
    return [_delegate_map objectForKey:self];
}

- (void)setDelegate:(id<SDMaskGuidBGViewDelegate>)delegate {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _delegate_map = [NSMapTable mapTableWithKeyOptions: NSPointerFunctionsWeakMemory | NSPointerFunctionsOpaquePersonality valueOptions: NSPointerFunctionsWeakMemory | NSPointerFunctionsObjectPersonality];
    });
    if(delegate == nil) {
        [_delegate_map removeObjectForKey:self];
    } else {
        [_delegate_map setObject:delegate forKey:self];
    }
}

- (UIColor *)maskColor {
    if(!_bg_color_map) return nil;
    return [_bg_color_map objectForKey:self];
}

- (void)setMaskColor:(UIColor *)maskColor {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _bg_color_map = [NSMapTable mapTableWithKeyOptions: NSPointerFunctionsWeakMemory | NSPointerFunctionsOpaquePersonality valueOptions: NSPointerFunctionsWeakMemory | NSPointerFunctionsObjectPersonality];
    });
    if(_bg_color_map == nil) {
        [_bg_color_map removeObjectForKey:self];
    } else {
        [_bg_color_map setObject:maskColor forKey:self];
    }
}

#pragma mark - UIView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self ninit];
        [self nlayout];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self ninit];
        [self nlayout];
    }
    return self;
}

- (void)addSubview:(UIView *)view {
    [super addSubview:view];
    [view setHidden:view.tag < 0];
}

#pragma mark - Self
- (void)ninit {
    [self setBackgroundColor:[UIColor clearColor]];
    [self setBackgroundLayer:nil];
    [self setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundDidTap:)];
    [self addGestureRecognizer:tap];
}

- (void)nlayout {
    [[self.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"tag<0"]] setValue:@YES forKeyPath:@"hidden"];
    if(self.backgroundLayer) {
        [self.backgroundLayer removeFromSuperlayer];
        [self setBackgroundLayer:nil];
    }
}

#pragma mark - control

- (void)didHook {
    [self ninit];
    [self nlayout];
}

- (void)showPage {
    NSInteger curTag = [self currentTag];
    NSInteger nxtTag = (curTag == NSNotFound) ? -1 : (curTag - 1);
    if(self.page >= self.totalPage) return;
    /// Hide last page.
    if(curTag != NSNotFound) {
        [[self subviewsForTag:curTag] setValue:@YES forKeyPath:@"hidden"];
    }
    NSArray <UIView *> *displayViews = [self subviewsForTag:nxtTag];
    if(displayViews.count == 0) {
        [self.backgroundLayer setName:[NSString stringWithFormat:@"%ld", (long)nxtTag]];
        [self showPage];/// Until found
        return;
    }
    /// Show page
    [displayViews setValue:@NO forKeyPath:@"hidden"];
    /// Background
    UIBezierPath *fill = [UIBezierPath bezierPathWithRect:self.bounds];
    for (UIView *displayItem in displayViews) {
        CGRect rect = displayItem.frame;
        CGFloat corner = (displayItem.layer.masksToBounds ? 0 : displayItem.layer.cornerRadius);
        UIBezierPath *dig = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:corner];
        [fill appendPath:dig];
    }
    [fill setUsesEvenOddFillRule:YES];
    /// Remove old layer
    [self.backgroundLayer removeFromSuperlayer];
    /// New layer
    CAShapeLayer *layer = [CAShapeLayer layer];
    [layer setFrame:self.bounds];
    [layer setPath:[fill CGPath]];
    [layer setFillRule:kCAFillRuleEvenOdd];
    [layer setFillColor:[self.maskColor CGColor]];
    [layer setName:[NSString stringWithFormat:@"%ld", (long)--nxtTag]];
    [self setBackgroundLayer:layer];
    [self.layer insertSublayer:layer atIndex:0];
}

- (NSInteger)page {
    if([self currentTag] == NSNotFound) return 0;
    return ABS([self currentTag]);
}

- (NSUInteger)totalPage {
    NSArray *subviews = [self.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"tag<0"]];
    subviews = [subviews valueForKeyPath:@"tag"];
    return [[NSSet setWithArray:subviews] count];
}

- (void)backgroundDidTap:(UITapGestureRecognizer *)tap {
    NSInteger tag = [self currentTag];
    NSInteger page = self.page;
    if([self.delegate respondsToSelector:@selector(didTapedBackgroud:page:)]) {
        [self.delegate didTapedBackgroud:[self subviewsForTag:tag] page:page];
    }
    if(page >= self.totalPage) {
        if([self.delegate respondsToSelector:@selector(pagesShowCompleted)]) {
            [self.delegate pagesShowCompleted];
        }
    }
}

- (NSInteger)currentTag {
    return self.backgroundLayer ? (self.backgroundLayer.name.integerValue + 1) : NSNotFound;
}

- (NSArray <UIView *>*)subviewsForTag:(NSInteger)tag {
    return [self.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"tag=%ld", tag]];
}
@end
