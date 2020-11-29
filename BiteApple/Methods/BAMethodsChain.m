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

/**
 self 是类的隐藏的参数，指向当前当前调用方法的类，另一个隐藏参数是 _cmd，代表当前类方法的 selector。这里只关注这个 self。

 super 是个啥? super 并不是隐藏的参数，它只是一个“编译器指示符”，它和 self 指向的是相同的消息接收者，拿上面的代码为例，不论是用 [self setName] 还是 [super setName]，接收“setName”这个消息的接收者都是 PersonMe* me 这个对象。不同的是，super 告诉编译器，当调用 setName 的方法时，要去调用父类的方法，而不是本类里的。

 当使用 self 调用方法时，会从当前类的方法列表中开始找，如果没有，就从父类中再找;而当使用 super 时，则从父类的方法列表中开始找。然后调用父类的这个方法。
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
    objc_msgSend(self, @selector(helloWithMsg:), @"hello");
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
