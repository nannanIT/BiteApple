#  exception

```
@try
{
    // 业务逻辑
}
@catch (异常类型名1 ex)
{
    //异常处理代码
}
@catch (异常类型名2 ex)
{
    //异常处理代码
}
// 可以捕捉 N 个 异常 ...
@finally
{
//回收资源
}
  
```

Apple虽然同时提供了错误处理（NSError）和异常处理（exception）两种机制，但是Apple更加提倡开发者使用NSError来处理程序运行中可恢复的错误。而异常被推荐用来处理不可恢复的错误。

如果需要指出程序员的编码错误，则应该使用NSException。例如，一个方法只能接收奇数作为参数，但是程序员在调用该方法时传入了一个偶数，这时应该抛出异常，有点像断言（Assert），方便调试程序。（但是断言可以方便禁用，发布配置中默认定义了NS_BLOCK_ASSERTIONS）
对于预期（expected）错误，如用户错误和设备环境错误，应该使用NSError。例如，一个方法需要读取用户照片，但是没有访问权限，这时应该向方法调用者返回一个NSError对象，指出不能执行的原因。

下面是官方文档的说明

NSError is designed for non-fatal, recoverable errors. The problems that are designed to be captured by an NSError are often user errors (or are errors that can be presented to the user), can often be recovered from (hence -presentError: and NSErrorRecoveryAttempting), and are usually expected or predictable errors (like trying to open a file that you don't have access to, or trying to convert between incompatible string encodings).

NSException is designed for potentially fatal, programmer errors. These errors are designed to signify potential flaws in your application where you have not correctly checked the pre-conditions for performing some operations (like trying to access an array index that is beyond its bounds, or attempts to mutate an immutable object). The introduction to the Exception Programming Guide explains this a little bit


## 在iOS程序的崩溃中，主要有两种异常引起的。一个是Mach异常，一个是Object-C异常（NSException，OC层的异常）。

iOS Crash 文件分析，符号化

在Mac平台下，可以使用nm命令来查看一个文件的符号表信息。

