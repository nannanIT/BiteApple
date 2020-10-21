//
//  BACrashHandler.m
//  BiteApple
//
//  Created by jayhuan on 2020/10/21.
//

#import "BACrashHandler.h"

@implementation BACrashHandler

- (void)setSignalHandler {
    /// 注册信号Handler，Unix 信号捕获
    signal(SIGABRT, BA_SignalHandler);
    signal(SIGBUS, BA_SignalHandler);
    signal(SIGSEGV, BA_SignalHandler);
    signal(SIGKILL, BA_SignalHandler);
}

void BA_SignalHandler(int signal) {
    NSArray<NSString *> *symbols = [NSThread callStackSymbols];
    NSLog(@"symbols is %@", symbols);
}

@end
