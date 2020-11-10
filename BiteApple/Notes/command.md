#  Notes

### lipo命令

lipo 是管理Fat File 的工具，可以查看cpu 架构，提取特定架构，整合和拆分库文件。

```
cd QNEngine.framework
lipo -info QNEngine

lipo -info QNEngine.a

xcodebuild -showsdks
```


static const

0、static 修饰局部变量：只初始化一次，内存中一直有一份，整个生命周期有效
const 修饰全局变量，不允许全局有重复定义，不允许修改
1、文件中使用的局部变量使用 static const 修饰
2、文件中对外暴露的变量使用 const 和 extern const修饰 
NSString * const NAME = @"name";
const只对右边的变量有修饰作用
