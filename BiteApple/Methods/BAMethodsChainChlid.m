//
//  BAMethodsChainChlid.m
//  BiteApple
//
//  Created by jayhuan on 2020/11/14.
//

#import "BAMethodsChainChlid.h"
#import <objc/runtime.h>

void hellobb(id self, SEL _cmd) {
    NSLog(@"hellobb");
}

@implementation BAMethodsChainChlid

- (void)test {
    if (class_getInstanceMethod([self class], @selector(helloa))) {
        NSLog(@"B has method %@", @"helloa");
    }
    if (class_getInstanceMethod([self class], NSSelectorFromString(@"hellob"))) {
        NSLog(@"B has method %@", @"hellob");
    }
    
    if (class_addMethod([self class], @selector(helloa), (IMP)hellobb, "v@:")) {
        NSLog(@"B can add method helloa");
    }
    
    if (class_addMethod([self class], NSSelectorFromString(@"hellobb"), (IMP)hellobb, "v@:")) {
        NSLog(@"B can add method hellob");
    }
}

@end
