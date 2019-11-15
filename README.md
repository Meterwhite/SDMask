# SDMask
Alert mask view, help you to alert custom  view.Like UIAlertview and UIActionSheet.

![image](https://github.com/qddnovo/SDHudView/blob/master/SDHudViewProgram/Show.gif)

## import
- Drag floder `SDMask` to your project.
```objc
#import "SDMask.h"
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
