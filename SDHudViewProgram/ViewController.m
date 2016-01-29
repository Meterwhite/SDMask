//
//  ViewController.m
//  SDHudViewProgram
//
//  Created by Novo on 16/1/29.
//  Copyright © 2016年 Novo. All rights reserved.
//

#import "ViewController.h"
#import "SDHudView.h"

@interface ViewController ()
@property (nonatomic,strong) UIView* aTestView;
@property (nonatomic,weak) SDHudView* hudView;
@property (nonatomic,weak) UIButton* btnSize;
@property (nonatomic,weak) UIButton* btnBottom;
@property (nonatomic,weak) UIButton* btnTop;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btnSize setTitle:@"放大弹出" forState:UIControlStateNormal];
    [self.btnTop setTitle:@"顶部弹出" forState:UIControlStateNormal];
    [self.btnBottom setTitle:@"底部弹出" forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  点击事件
 */
- (void)btnShowClick
{
    self.hudView.isHiddenWhenTouch=YES;
    self.hudView.contentAnimateStyle=EnumSDHudViewAnimateStyleFromSmallSize;
    self.hudView.contentPositionStyle=EnumSDHudViewPositionStyleCenter;
    [self.hudView uiShowWithContentView:self.aTestView];
}

- (void)btnShowBottom
{
    self.hudView.isHiddenWhenTouch=YES;
    self.hudView.contentAnimateStyle=EnumSDHudViewAnimateStyleFromBottom;
    self.hudView.contentPositionStyle=EnumSDHudViewPositionStyleBottom;
    [self.hudView uiShowWithContentView:self.aTestView];
}

- (void)btnShowTop
{
    self.hudView.isHiddenWhenTouch=YES;
    self.hudView.contentAnimateStyle=EnumSDHudViewAnimateStyleFromTop;
    self.hudView.contentPositionStyle=EnumSDHudViewPositionStyleTop;
    [self.hudView uiShowWithContentView:self.aTestView];
}




- (UIView *)aTestView
{
    if(!_aTestView){
        _aTestView = [UIView new];
        _aTestView.frame=CGRectMake(0, 0, 120, 120);
        _aTestView.backgroundColor=[UIColor grayColor];
    }
    return _aTestView;
}

- (SDHudView *)hudView
{
    if(!_hudView){
        SDHudView* newHud =[[SDHudView alloc] initFromSuperView:self.view];
        _hudView=newHud;
    }
    return _hudView;
}



- (UIButton *)btnTop
{
    if(!_btnTop){
        UIButton* btnShow = [UIButton buttonWithType:UIButtonTypeSystem];
        btnShow.frame=CGRectMake(0, 64, 80, 44);
        btnShow.backgroundColor=[UIColor greenColor];
        [btnShow setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btnShow addTarget:self action:@selector(btnShowTop) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnShow];
        [self viewCorner:btnShow];
        _btnTop=btnShow;
    }
    return _btnTop;
}


- (UIButton *)btnSize
{
    if(!_btnSize){
        UIButton* btnShow = [UIButton buttonWithType:UIButtonTypeSystem];
        btnShow.frame=CGRectMake(0, 128, 80, 44);
        btnShow.backgroundColor=[UIColor greenColor];
        [btnShow setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btnShow addTarget:self action:@selector(btnShowClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnShow];
        [self viewCorner:btnShow];
        _btnSize=btnShow;
    }
    return _btnSize;
}

- (UIButton *)btnBottom
{
    if(!_btnBottom){
        UIButton* btnShow = [UIButton buttonWithType:UIButtonTypeSystem];
        btnShow.frame=CGRectMake(0, 194, 80, 44);
        btnShow.backgroundColor=[UIColor greenColor];
        [btnShow setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btnShow addTarget:self action:@selector(btnShowBottom) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnShow];
        [self viewCorner:btnShow];
        _btnBottom=btnShow;
    }
    return _btnBottom;
}

- (void)viewCorner:(UIView*)v
{
    CAShapeLayer* sharp=[CAShapeLayer layer];
    sharp.frame=v.bounds;
    UIBezierPath* path =[UIBezierPath bezierPathWithRoundedRect:v.bounds
                                              byRoundingCorners:UIRectCornerBottomRight|UIRectCornerTopRight
                                                    cornerRadii:CGSizeMake(8, 8)];
    sharp.path = path.CGPath;
    v.layer.mask = sharp;
}

@end
