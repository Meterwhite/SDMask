# SDMask

## 介绍 Introduce
* A perfect mask view that help you to present custom view.User dont need to care about animations and  events.
* Skir的（SD）iOS蒙版.帮助弹出自定义视图，用户不再关心动画和点击事件。
* 随手一赞.好运百万.
* Start me good luck 1 dong.

## Import
- Drag floder `SDMask` to your project.
```objc
#import "SDMask.h"
```
## CocoaPods
```
pod 'Wiil do it'
```
## 处理简单业务 Handling simple business in a block.
```objc
[customAlertView sdm_showAlertUsingBlock:^(id<SDMask>  _Nonnull mask) {
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
id<SDMask> mask = currentController.sdm_actionSheetMaskWith(userView);
[mask userViewDidLoad:^(SDMaskModel * model) {
    model.
    setAutolayoutValueForKey(@(0), @"bottom").
    setAutolayoutValueForKey(@(15), @"left").
    setAutolayoutValueForKey(@(15), @"right").
    setAutolayoutValueForKey(@(350), @"height");
}];
[mask bindEventForControls:@[okButton, helpButton, [deleteButton sdm_withBindingKey:@"del"], ...]];
[mask bindEventForCancelControl:cancelButton];
[mask bindingEventFor:okButton usingBlock:^(SDMaskBindingEvent * event) {
    /// ...
}];
[mask bindingEventFor:@"del" usingBlock:^(SDMaskBindingEvent * event) {
    /// ...
}];
[mask show];
```
## 链式编程 Chain programming
-  链式编程涵盖了大多数方法 Chained programming covers most methods
```objc
[...[[[mask bindEventForControls:@[okButton]] bindEventForCancelControl:cancelButton] bindingEventsUsingBlock:^(SDMaskBindingEvent * event) {
    
}]... show];
```
## Use autolayout
### Tow ways to use autolayout.
- a. Use the methods provided by the SDMask to use autolayout. 
```objc
[mask userViewDidLoad:^(SDMaskModel * model) {
    model.
    setAutolayoutValueForKey(@(0), @"bottom").
    setAutolayoutValueForKey(@(15), @"left").
    setAutolayoutValueForKey(@(15), @"right").
    setAutolayoutValueForKey(@(350), @"height");
}];
```
-b. Autolayout by youself. Like 'masonry'
```objc
[mask userViewDidLoad:^(SDMaskModel * model) {
    [model.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(model.containerView);
        make.left.equalTo(model.containerView.mas_left).offset(20);
        make.right.equalTo(model.containerView.mas_right).offset(-20);
    }];
}];
```
## Use custom animations
- Framelayout
```objc
[[[[[mask userViewPresentationWillAnimate:^(SDMaskModel * model) {
    userView.frame = frameA;
}] userViewPresentationDoAnimations:^(SDMaskModel * model) {
    userView.frame = frameB;
}] userViewDismissionWillAnimate:^(SDMaskModel * model) {
    /// ...
}] userViewDismissionDoAnimations:^(SDMaskModel * model) {
    userView.frame = frameA;
}] disableSystemAnimation];
```
- Autolayout
```objc
[[[[[mask userViewPresentationWillAnimate:^(SDMaskModel * model) {
    userView.bottonConstraint = A;
    //[self.view setNeedsLayout];
    //[self.view layoutIfNeeded];
}] userViewPresentationDoAnimations:^(SDMaskModel * model) {
    userView.bottonConstraint = B;
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}] userViewDismissionWillAnimate:^(SDMaskModel * model) {
    /// ...
}] userViewDismissionDoAnimations:^(SDMaskModel * model) {
    userView.bottonConstraint = A;
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}] disableSystemAnimation];
```
## Email
- meterwhite@outlook.com
