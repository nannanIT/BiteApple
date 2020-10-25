#  AFNetworking

## 关键问题
- 简介
对`NSURLSession`封装的简单高效方便的iOS网络框架。
- 实现原理
   * 提供了AFHTTPSessionManager用于HTTP请求(GET，POST，...)
   * 提供AFURLRequestSerialization用于请求封装，添加参数，设置header，传递数据
   * 提供AFURLResponseSerialization用于服务端返回数据的解析和过滤
   * 提供AFSecurityPolicy用于HTTPS协议证书验证
   * 提供了AFNetworkReachabilityManager用于网络状态监听
   * 提供了UIKit主要可用于图片缓存，类似于SDWebImage

## 探索
先熟悉NSURLSession相关Api，再复杂的框架也是对系统方法的封装。
https://juejin.im/post/6844903721541828616
https://www.jianshu.com/p/317508ee2a21

