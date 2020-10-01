//
//  ObjcMsgSend.m
//  BiteApple
//
//  Created by jayhuan on 2020/10/1.
//

#import "ObjcMsgSend.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation ObjcMsgSend

- (void)hello {
    objc_msgSend(self, @selector(p_hello:), @"Apple");
}

- (void)p_hello:(NSString *)msg {
    NSLog(@"Hello world, %@", msg);
}

@end
