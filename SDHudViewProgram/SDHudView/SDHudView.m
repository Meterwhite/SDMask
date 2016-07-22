//
//  SDHudHudView.m
//  Novo
//
//  Created by Novo on 16/1/6.
//  Copyright © 2016年 Novo. All rights reserved.
//

//弱引用
#define macroWeakSelf_VAL \
typeof(self) __weak weakSelf = self
#define macroUIView_VAL(valStr) \

//屏幕宽度高度
#define macroScreenWidth  [UIScreen mainScreen].bounds.size.width
#define macroScreenHeight [UIScreen mainScreen].bounds.size.height

#import "SDHudView.h"

@interface SDHudView ()
@property (nonatomic,copy) void(^blockShow)() ;
@property (nonatomic,copy) void(^blockHidden)() ;
@property (nonatomic,copy) void(^blockLayoutContentView)(UIView* contentView);

@property (nonatomic,strong) UIView* contentView;
@end


@implementation SDHudView
#pragma mark - 添加
- (void)addContentView:(id)view
{
    if([view isKindOfClass:[UIView class]]){
        self.contentView = view;
    }
}

- (void)addToSuperView:(UIView*)superView
{
    [superView addSubview:self];
    [superView sendSubviewToBack:self];
}
- (void)uiFrameCopySuper
{
    if(!self.superview) return;
    self.frame=self.superview.frame;
}
#pragma mark - 核心
- (void)uiShowWithContentView:(id)view
{
    self.contentView=view;
    [self uiShow];
}

- (void)uiShow
{
    self.alpha = self.alphaContentEnd;
    [self.superview bringSubviewToFront:self];//调整层级
    if(!self.contentView)   return;
    [self.superview addSubview:self.contentView];//内容加到共同父级
    self.contentView.hidden = YES;
    [self.superview bringSubviewToFront:self.contentView];
    
    //内容原始位置
    CGFloat originX;
    CGFloat originY;
    switch (self.contentPositionStyle) {
            
        case EnumSDHudViewPositionStyleTop:
        {
            originX = (self.frame.size.width - self.contentView.frame.size.width)/2 + self.contentXOffset +self.frame.origin.x;
            originY = self.contentYOffset +self.frame.origin.y;
            self.contentView.frame = CGRectMake( originX , originY, self.contentView.frame.size.width, self.contentView.frame.size.height);
        }
            break;
        case EnumSDHudViewPositionStyleBottom:
        {
            originX = (self.frame.size.width - self.contentView.frame.size.width)/2 + self.contentXOffset + self.frame.origin.x;
            originY = (self.frame.size.height - self.contentView.frame.size.height)+ self.contentYOffset +self.frame.origin.y;
            self.contentView.frame = CGRectMake( originX , originY , self.contentView.frame.size.width, self.contentView.frame.size.height);
        }
            break;
        case EnumSDHudViewPositionStyleCenter:
        {
            CGPoint center=self.center;
            center.x += self.contentXOffset;
            center.y += self.contentYOffset;
            self.contentView.center = center;
            originX = self.contentView.frame.origin.x;
            originY = self.contentView.frame.origin.y;
        }
        default:
            break;
    }
    
    //使用用户布局
    if(self.blockLayoutContentView){
        
        self.blockLayoutContentView(self.contentView);
        originX=self.contentView.frame.origin.x;
        originY=self.contentView.frame.origin.y;
    }
    
    //动画
    switch (self.contentAnimateStyle) {
            case EnumSDHudViewAnimateStyleFromBottom://从下往上
        {

            self.contentView.frame = CGRectMake( originX , macroScreenHeight,
                                                self.contentView.frame.size.width, self.contentView.frame.size.height);
            
            self.hidden = NO;
            self.alpha = 0.0;
            self.contentView.hidden=NO;
            [UIView animateWithDuration:self.timeShowDuring animations:^{

                self.contentView.frame = CGRectMake( originX , originY ,
                                                    self.contentView.frame.size.width, self.contentView.frame.size.height);
                self.alpha=self.alphaContentEnd;
            } completion:^(BOOL finished) {
                if(self.blockShow){
                    self.blockShow();
                }
            }];
        }
            break;
            case EnumSDHudViewAnimateStyleFromTop://从上往下
        {

            self.contentView.frame = CGRectMake( originX , self.frame.origin.y-self.contentView.frame.size.height,
                                                self.contentView.frame.size.width, self.contentView.frame.size.height);
            
            self.hidden = NO;
            self.alpha = 0.0;
            self.contentView.hidden=NO;
            [UIView animateWithDuration:self.timeShowDuring animations:^{
                self.contentView.frame = CGRectMake( originX , originY ,
                                                    self.contentView.frame.size.width , self.contentView.frame.size.height);
                self.alpha=self.alphaContentEnd;
            } completion:^(BOOL finished) {
                if(self.blockShow){
                    self.blockShow();
                }
            }];
        }
            break;
        case EnumSDHudViewAnimateStyleFromSmallSize:
        {
            self.hidden=NO;;
            self.alpha=0.0;
            self.contentView.hidden=NO;

            self.contentView.transform=CGAffineTransformScale(CGAffineTransformIdentity, 0.2, 0.2);
            [UIView animateWithDuration:self.timeShowDuring animations:^{
                self.alpha=self.alphaContentEnd;
                self.contentView.transform=CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
            } completion:^(BOOL finished) {
                if(self.blockShow){
                    self.blockShow();
                }
            }];
        }
            break;
        case EnumSDHudViewAnimateStyleImmedia://默认
        default:
        {
            self.hidden = NO;
            self.alpha = 0.0;
            self.contentView.hidden = NO;
            self.contentView.alpha = 0.75;
            [UIView animateWithDuration:self.timeShowDuring animations:^{
                self.alpha = self.alphaContentEnd;
                self.contentView.alpha = 1.0;
            } completion:^(BOOL finished) {
                
                if(self.blockShow){
                    self.blockShow();
                }
            }];
        }
            break;
    }
}

- (void)uiHidden
{
    //内容原始当前
    CGFloat originX=self.contentView.frame.origin.x;
    
    switch (self.contentAnimateStyle) {
        case EnumSDHudViewAnimateStyleFromBottom:
        {
            
            [UIView animateWithDuration:self.timeHiddenDuring animations:^{
                
                self.alpha=0.0;
                self.contentView.frame = CGRectMake( originX, macroScreenHeight,
                                                    self.contentView.frame.size.width, self.contentView.frame.size.height);
            } completion:^(BOOL finished) {
                
                if(self.blockHidden){
                    self.blockHidden();
                }
                [self.superview sendSubviewToBack:self];
                if(!finished) return ;
                [self.contentView removeFromSuperview];
                self.contentView = nil;
            }];
        }
            break;
        case EnumSDHudViewAnimateStyleFromTop:
        {
            [UIView animateWithDuration:self.timeHiddenDuring animations:^{
                
                self.alpha=0.0;
                self.contentView.frame = CGRectMake( originX, self.frame.origin.y-self.contentView.frame.size.height,
                                                    self.contentView.frame.size.width , self.contentView.frame.size.height);
            } completion:^(BOOL finished) {
                
                [self.contentView removeFromSuperview];
                [self.superview sendSubviewToBack:self];
                if(self.blockHidden){
                    self.blockHidden();
                }
                self.contentView = nil;
            }];
        }
            break;
        case EnumSDHudViewAnimateStyleFromSmallSize:
        {
            [UIView animateWithDuration:self.timeHiddenDuring animations:^{
                
                self.contentView.transform=CGAffineTransformScale(CGAffineTransformIdentity, 0.2, 0.2);
            } completion:^(BOOL finished) {
                self.alpha=0.0;
                [self.contentView removeFromSuperview];
                [self.superview sendSubviewToBack:self];
                if(self.blockHidden){
                    self.blockHidden();
                }
                self.contentView.transform=CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                self.contentView = nil;
            }];
        }
            break;
        case EnumSDHudViewAnimateStyleImmedia:
        default:
        {
            
            self.contentView.hidden = YES;
            [UIView animateWithDuration:self.timeHiddenDuring animations:^{
                
                self.alpha = 0.0;
            } completion:^(BOOL finished) {
                
                self.hidden = YES;
                [self.contentView removeFromSuperview];
                [self.superview sendSubviewToBack:self];
                if(self.blockHidden){
                    self.blockHidden();
                }
                self.contentView = nil;
            }];
        }
            break;
    }
}
#pragma mark - 构造
- (instancetype)initFromSuperView:(UIView *)superView
{
    if(self=[super init]){
        [self addToSuperView:superView];
        [self uiFrameCopySuper];
    }
    return self;
}

- (void)eventDidContentViewShow:(void(^)())block
{
    self.blockShow = block;
}

- (void)eventDidContentViewHidden:(void(^)())block
{
    self.blockHidden = block;
}

- (void)contentLayoutInSuperUsingBlock:(void(^)(UIView* contentView))block
{
    self.blockLayoutContentView=block;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupNormal];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupNormal];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupNormal];
    }
    return self;
}

- (void)setIsHiddenWhenTouch:(BOOL)isHiddenWhenTouch
{
    _isHiddenWhenTouch = isHiddenWhenTouch;
}

- (void)eventDidHudTap:(UITapGestureRecognizer*)tapGes
{
    if(_isHiddenWhenTouch)  [self uiHidden];
}

- (void)setupNormal
{
    //常量
    self.contentAnimateStyle = EnumSDHudViewAnimateStyleImmedia;
    self.contentPositionStyle = EnumSDHudViewPositionStyleCenter;
    self.isHiddenWhenTouch = NO;
    self.alphaContentEnd=0.6;
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:self.alphaContentEnd];
    self.contentXOffset=0.0;
    self.contentYOffset=0.0;
    self.timeHiddenDuring=0.256;
    self.timeShowDuring=0.256;
    //触摸
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eventDidHudTap:)];
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
//    tap.delegate=self;
    [self addGestureRecognizer:tap];
}
@end
