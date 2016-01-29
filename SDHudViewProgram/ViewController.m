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
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton* btnShow = [UIButton buttonWithType:UIButtonTypeSystem];
    btnShow.frame=CGRectMake(0, 64, 80, 44);
    btnShow.backgroundColor=[UIColor greenColor];
    [btnShow setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnShow setTitle:@"弹出" forState:UIControlStateNormal];
    [btnShow addTarget:self action:@selector(btnShowClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnShow];
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

- (UIView *)aTestView
{
    if(!_aTestView){
        _aTestView = [UIView new];
        _aTestView.frame=CGRectMake(0, 0, 120, 120);
        _aTestView.backgroundColor=[UIColor whiteColor];
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
@end
