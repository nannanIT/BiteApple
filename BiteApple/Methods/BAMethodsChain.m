//
//  BAMethodsChain.m
//  BiteApple
//
//  Created by jayhuan on 2020/11/13.
//

#import "BAMethodsChain.h"
#import <objc/runtime.h>
#import <objc/message.h>

/**
 SEL     字符串    方法的唯一表示
 IMP    方法的地址，具体实现
 Method
 struct objc_method {
    SEL _Nonnull method_name                                 OBJC2_UNAVAILABLE;
    char * _Nullable method_types                            OBJC2_UNAVAILABLE;
    IMP _Nonnull method_imp                                  OBJC2_UNAVAILABLE;
 }
 NSMethodSignature      方法签名：包括方法参数类型、数量、返回值类型等描述信息。
 NSInvocation    消息转发封装对象       An NSInvocation object contains all the elements of an Objective-C message: a target, a selector, arguments, and the return value. Each of these elements can be set directly, and the return value is set automatically when the NSInvocation object is dispatched.
 objc_msgSend       消息转发c语言方法
 */

void hellob(id self, SEL _cmd) {
    NSLog(@"helloa");
}

@implementation BAMethodsChain

+ (void)swizzleInstanceMethod:(Class)target original:(SEL)originalSelector swizzled:(SEL)swizzledSelector {
    Method originMethod = class_getInstanceMethod(target, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(target, swizzledSelector);
    if (class_addMethod(target, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(target, swizzledSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }
    else {
        method_exchangeImplementations(originMethod, swizzledMethod);
    }
}

- (void)test {
    if (class_getInstanceMethod([self class], @selector(helloa))) {
        NSLog(@"has method %@", @"helloa");
    }
    if (class_getInstanceMethod([self class], NSSelectorFromString(@"hellob"))) {
        NSLog(@"has method %@", @"hellob");
    }
    
    if (class_addMethod([self class], @selector(helloa), (IMP)hellob, "v@:")) {
        NSLog(@"can add method helloa");
    }
    
    if (class_addMethod([self class], NSSelectorFromString(@"hellob"), (IMP)hellob, "v@:")) {
        NSLog(@"can add method hellob");
    }
    Method method = class_getInstanceMethod([self class], @selector(helloWithMsg:));
    method_getImplementation(method);
    class_getMethodImplementation([self class], @selector(helloWithMsg:));
    class_getMethodImplementation_stret([self class], @selector(helloWithMsg:));
    objc_msgSend(self, @selector(helloa));
//    class_replaceMethod(, , , )
//    method_exchangeImplementations(m1, m2);
}

- (void)helloa {
    
}

- (void)helloWithMsg:(NSString *)msg {
    NSLog(@"");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"1 resolveInstanceMethod-%@", NSStringFromSelector(sel));
//    return [super resolveInstanceMethod:sel];
    return YES;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"2 forwardingTargetForSelector-%@", NSStringFromSelector(aSelector));
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSLog(@"3 methodSignatureForSelector-%@", NSStringFromSelector(aSelector));
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
//    return nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"4 forwardInvocation-%@", NSStringFromSelector(anInvocation.selector));
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"5 doesNotRecognizeSelector : %@", NSStringFromSelector(aSelector));
}

@end
