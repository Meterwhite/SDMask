> [XIB执行命令行！](https://github.com/Meterwhite/XICommand)
>> [Let XIB execute the command line!](https://github.com/Meterwhite/XICommand)
# SDMask
![SDMask icon](https://raw.githubusercontent.com/Meterwhite/SDMask/master/Cover.png)
![SDMaskGuidController icon](https://raw.githubusercontent.com/Meterwhite/SDMask/master/Cover2.png)
## 介绍 Introduce
* A perfect iOS mask view that help you to present custom view.User dont need to care about animations and events.
* Skir的（SD）iOS蒙版蒙层遮罩.弹出自定义视图，用户不再关心动画和点击事件。
* 点赞富一生.
* Good luck for one start .

## Import
- Drag floder `SDMask` to your project.
```objc
#import "SDMask.h"
```
## CocoaPods
```
pod 'SDMask'
```
## New! 引导控制器 SDMaskGuidController
### 在一个XIB文件中设置多个页面的约束进行适配，可以适应90%的设计需求。Set multiple guid pages in one controller XIB file ! By changing the constraints in XIB to adapt the device, this solution can address 90% of the design needs.
```objc
[[[MySDMaskGuidController new] userViewDidLoad:^(SDMaskModel * _Nonnull model) {
    /// Set the same color as user view to background.
    [model setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
}] show];
```

## 处理简单业务 Handling simple business in a block.
```objc
[SDMaskUserView(customAlertView) sdm_showAlertUsingBlock:^(SDMask<UserView*>*  _Nonnull mask) {
    /// You can bind control events to SDMask
    [mask bindEventForControls:@[okButton]] 
    [mask bindEventForCancelControl:cancelButton];
    [mask bindingEventsUsingBlock:^(SDMaskBindingEvent * event) {
        if(event.index == 0){
            /// okButton...
        }
    }];
    ... ...
}];
```
## 分步处理复杂的业务 Step-by-step processing of complex business.
```objc
SDMask<UserView*>* mask = SDAlertMaskWith(currentController, userView);
[mask userViewDidLoad:^(SDMaskModel<UserView*> * model) {
    model.
    setAutolayoutValueForKey(@(0), @"bottom").
    setAutolayoutValueForKey(@(15), @"left").
    setAutolayoutValueForKey(@(15), @"right").
    setAutolayoutValueForKey(@(350), @"height");
}];
[mask bindEventForControls:@[okButton, helpButton, [deleteButton sdm_withBindingKey:@"del"], ...]];
[mask bindEventForCancelControl:cancelButton];
[mask bindingEventFor:okButton usingBlock:^(SDMaskBindingEvent<UserView*> * event) {
    /// ...
}];
[mask bindingEventFor:@"del" usingBlock:^(SDMaskBindingEvent<UserView*> * event) {
    /// ...
}];
[mask show];
```
## 链式编程 Chain programming
-  链式编程涵盖了大多数方法 Chained programming covers most methods
```objc
[...[[[mask bindEventForControls:@[okButton]] bindEventForCancelControl:cancelButton] bindingEventsUsingBlock:^(SDMaskBindingEvent<UserView*>* event) {
    
}]... show];
```
## Use autolayout
### 自动布局的两种方式 Tow ways to use autolayout.
- a. 框架提供 Use the methods provided by the SDMask to use autolayout. 
```objc
[mask userViewDidLoad:^(SDMaskModel<UserView*> * model) {
    model.
    setAutolayoutValueForKey(@(0), @"bottom").
    setAutolayoutValueForKey(@(15), @"left").
    setAutolayoutValueForKey(@(15), @"right").
    setAutolayoutValueForKey(@(350), @"height");
}];
```
- b. 三方或手动布局 Autolayout by youself. Like 'masonry'
```objc
[mask userViewDidLoad:^(SDMaskModel<UserView*> * model) {
    [model.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(model.containerView);
        make.left.equalTo(model.containerView.mas_left).offset(20);
        make.right.equalTo(model.containerView.mas_right).offset(-20);
    }];
}];
```
## 自定义动画 Use custom animations
- Framelayout
```objc
[[[[[mask userViewPresentationWillAnimate:^(SDMaskModel<UserView*> * model) {
    userView.frame = frameA;
}] userViewPresentationDoAnimations:^(SDMaskModel<UserView*> * model) {
    userView.frame = frameB;
}] userViewDismissionWillAnimate:^(SDMaskModel<UserView*> * model) {
    /// ...
}] userViewDismissionDoAnimations:^(SDMaskModel<UserView*> * model) {
    userView.frame = frameA;
}] disableSystemAnimation];
```
- Autolayout
```objc
[[[[[mask userViewPresentationWillAnimate:^(SDMaskModel<UserView*> * model) {
    userView.bottonConstraint = A;
    //[self.view setNeedsLayout];
    //[self.view layoutIfNeeded];
}] userViewPresentationDoAnimations:^(SDMaskModel<UserView*> * model) {
    userView.bottonConstraint = B;
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}] userViewDismissionWillAnimate:^(SDMaskModel<UserView*> * model) {
    /// ...
}] userViewDismissionDoAnimations:^(SDMaskModel<UserView*> * model) {
    userView.bottonConstraint = A;
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}] disableSystemAnimation];
```
## block对泛型的支持 Block support for generics
* Avoid type declarations and weak declarations.

## Email
- meterwhite@outlook.com
