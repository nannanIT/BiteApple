#  Notes

### lipo命令

lipo 是管理Fat File 的工具，可以查看cpu 架构，提取特定架构，整合和拆分库文件。

```
cd QNEngine.framework
lipo -info QNEngine

lipo -info QNEngine.a

xcodebuild -showsdks
```
