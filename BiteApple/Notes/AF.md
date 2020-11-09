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

/*

 NSURLSession is a replacement API for NSURLConnection.  It provides
 options that affect the policy of, and various aspects of the
 mechanism by which NSURLRequest objects are retrieved from the
 network.
 NSURLSession 是NSURLConnection的替代API，它为NSURLRequest获取网络数据的机制提供了多种选项，可影响其策略以及其它各方面。

 An NSURLSession may be bound to a delegate object.  The delegate is
 invoked for certain events during the lifetime of a session, such as
 server authentication or determining whether a resource to be loaded
 should be converted into a download.
 NSURLSession需要关联一个delegate，处理session生命周期中的各种回调事件：如服务器认证校验等
 
 NSURLSession instances are threadsafe.
 线程安全

 The default NSURLSession uses a system provided delegate and is
 appropriate to use in place of existing code that uses
 +[NSURLConnection sendAsynchronousRequest:queue:completionHandler:]
 
 NSURLSession *session = [NSURLSession sharedSession];
 [[session dataTaskWithURL:[NSURL URLWithString:"YOUR URL"]
           completionHandler:^(NSData *data,
                               NSURLResponse *response,
                               NSError *error) {
             // handle response

   }] resume];
 
 @interface NSURLSession (NSURLSessionAsynchronousConvenience)
 - (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;
 - (NSURLSessionDataTask *)dataTaskWithURL:(NSURL *)url completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;
 
 Like most networking APIs, the NSURLSession API is highly asynchronous. It returns data in one of two ways, depending on the methods you call:

 To a completion handler block that returns data to your app when a transfer finishes successfully or with an error.
 By calling methods on your custom delegate as the data is received.
 By calling methods on your custom delegate when download to a file is complete.
 

 An NSURLSession creates NSURLSessionTask objects which represent the
 action of a resource being loaded.  These are analogous to
 NSURLConnection objects but provide for more control and a unified
 delegate model.
 analogous 类似的
 
 NSURLSessionTask objects are always created in a suspended state and
 must be sent the -resume message before they will execute.
 resume开启sessionTask

 Subclasses of NSURLSessionTask are used to syntactically
 differentiate between data and file downloads.
 syntactically 语法上的

 An NSURLSessionDataTask receives the resource as a series of calls to
 the URLSession:dataTask:didReceiveData: delegate method.  This is type of
 task most commonly associated with retrieving objects for immediate parsing
 by the consumer.

 An NSURLSessionUploadTask differs from an NSURLSessionDataTask
 in how its instance is constructed.  Upload tasks are explicitly created
 by referencing a file or data object to upload, or by utilizing the
 -URLSession:task:needNewBodyStream: delegate message to supply an upload
 body.

 An NSURLSessionDownloadTask will directly write the response data to
 a temporary file.  When completed, the delegate is sent
 URLSession:downloadTask:didFinishDownloadingToURL: and given an opportunity 
 to move this file to a permanent location in its sandboxed container, or to
 otherwise read the file. If canceled, an NSURLSessionDownloadTask can
 produce a data blob that can be used to resume a download at a later
 time.

 Beginning with iOS 9 and Mac OS X 10.11, NSURLSessionStream is
 available as a task type.  This allows for direct TCP/IP connection
 to a given host and port with optional secure handshaking and
 navigation of proxies.  Data tasks may also be upgraded to a
 NSURLSessionStream task via the HTTP Upgrade: header and appropriate
 use of the pipelining option of NSURLSessionConfiguration.  See RFC
 2817 and RFC 6455 for information about the Upgrade: header, and
 comments below on turning data tasks into stream tasks.

 An NSURLSessionWebSocketTask is a task that allows clients to connect to servers supporting
 WebSocket. The task will perform the HTTP handshake to upgrade the connection
 and once the WebSocket handshake is successful, the client can read and write
 messages that will be framed using the WebSocket protocol by the framework.
 */


