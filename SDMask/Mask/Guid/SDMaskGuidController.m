//
//  SDMaskGuidController.m
//  SDMask
//
//  Created by MeterWhite on 2020/1/16.
//  Copyright © 2020 Meterwhite. All rights reserved.
//

#import "SDMaskGuidController.h"
#import "SDMaskGuidBGView.h"
#import <objc/runtime.h>
#import "SDMaskModel.h"

@interface SDMaskGuidController () <SDMaskGuidBGViewDelegate>
@property (nullable,nonatomic,readonly,weak) SDMaskGuidBGView *myView;
@end

@implementation SDMaskGuidController
{
    SDMaskUserBlock _userViewDidLoadBlock;
    SDMaskUserBlock _userViewDidDisappear;
    SDMaskUserBlock _pageDidLoad;
}
#pragma mark - Controller

- (instancetype)init {
    self = [super init];
    if (self) {
        [self ninit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self ninit];
    }
    return self;
}

- (void)ninit {
    [self setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    _model = [[SDMaskModel alloc] init];
    [_model setAnimte:SDMaskAnimationGuid];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /// Set view
    if(![self.view isKindOfClass:[SDMaskGuidBGView class]]){
        object_setClass(self.view, [SDMaskGuidBGView class]);
        [self.myView didHook];
    }
    self.myView.delegate = self;
    /// Load user view
    [self.userView setValue:@(UIViewAutoresizingNone) forKeyPath:@"autoresizingMask"];
    /// UI work
    [self.myView setAutoresizingMask:UIViewAutoresizingNone];
    [self loadUserview];
    if(_userViewDidLoadBlock) _userViewDidLoadBlock(self.model);
    [self.myView setMaskColor:self.model.backgroundColor?:SDMaskModel.defaultBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.myView showPage];
    self.model.guidPage = self.myView.page;
    if(_pageDidLoad) _pageDidLoad(self.model);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if(self->_userViewDidDisappear){
        self->_userViewDidDisappear(self.model);
    }
}

#pragma mark - Self

- (void)loadUserview {
    for (UIView *view in _userView) {
        [self.myView addSubview:view];
    }
}

- (SDMaskGuidBGView *)myView {
    return (id)self.view;
}

- (instancetype)pageDidLoad:(void (^)(SDMaskModel *))block {
    _pageDidLoad = [block copy];
    return self;
}

#pragma mark - SDMaskGuidBGViewDelegate
- (void)didTapedBackgroud:(NSArray<UIView *> *)guidViews page:(NSInteger)page {
    if(page == self.myView.totalPage) return;
    [self.myView showPage];
    self.model.guidPage = self.myView.page;
    if(_pageDidLoad) _pageDidLoad(self.model);
}

- (void)pagesShowCompleted {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SDMaskProtocol
@synthesize userView = _userView;
@synthesize model    = _model;

- (void)show {
    UIViewController *presenter = self.model.maskOwner ?: self.model.associatedWindow.rootViewController;
    [self.model.associatedWindow makeKeyAndVisible];
    [presenter presentViewController:self animated:YES completion:nil];
}

- (void)dismiss:(id)obj {
    if(self.model.dismissDelayTime > 0){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.model.dismissDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
        });
    }else{
        [self dismiss];
    }
}

- (void)dismiss {
    UIViewController *presenter = self.model.maskOwner ?: self.model.associatedWindow.rootViewController;
    [presenter dismissViewControllerAnimated:YES completion:nil];
}

- (id<SDMaskGuidProtocol>)userViewDidLoad:(SDMaskUserBlock)block {
    _userViewDidLoadBlock = [block copy];
    return self;
}

- (id<SDMaskGuidProtocol>)userViewDidDisappear:(SDMaskUserBlock)block {
    _userViewDidDisappear = [block copy];
    return self;
}

- (instancetype)initWithUserView:(NSArray <UIView *> *)uView {
    if(self = [self init]) {
        _userView = [uView copy];
        [self ninit];
        [_model setValue:uView forKey:@"_userView"];
        [_model setValue:self forKey:@"_thisMask"];
    }
    return self;
}

- (NSArray <UIView *> *)userView {
    return _userView;
}

- (SDMaskModel *)model {
    return _model;
}
@end
