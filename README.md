# SDHudView
简洁使用的蒙版。Just for Hud.Content View in MaskView.Easy to use.
## What is this?
* 轻`蒙版`控件。
* 使得蒙版的控制集中和简化。
* 持续更新，做到更好。

![image](https://github.com/qddnovo/SDHudView/blob/master/SDHudViewProgram/Show.gif)

##使用
```objc
SDHudView.h
```
##创建
```objc
SDHudView* newHud =[[SDHudView alloc] initFromSuperView:self.view];
```
##弹出
```objc
[newHud uiShowWithContentView:self.aTestView];
```
##隐藏
```objc
[newHud uiHidden];
```

##更多属性控制细节
```objc
newHud.isHiddenWhenTouch=YES;
newHud.contentAnimateStyle=EnumSDHudViewAnimateStyleFromBottom;
newHud.contentPositionStyle=EnumSDHudViewPositionStyleBottom;
[self.hudView uiShowWithContentView:self.aTestView];
//... ...
//... ...
```
##完全使用代码布局

##Bug-mail address，join us address  *[quxingyi@outlook.com](quxingyi@outlook.com)*
* 一朝做鸟程序员，十年相伴是飞机。没有八哥猛如虎，谁喂东西谁是主。
