//
//  BAThread.m
//  BiteApple
//
//  Created by jayhuan on 2020/10/27.
//

#import "BAThread.h"

@implementation BAThread

- (void)defaultThread {
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(downLoad) object:nil];
    [thread start];
    
    [NSThread detachNewThreadSelector:@selector(downLoad) toTarget:self withObject:nil];
}

- (void)threadUseGCD {
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_queue_t gQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(gQueue, ^{
        [self downLoad];
        dispatch_async(queue, ^{
            
        });
    });
}

- (void)threadUseOperation {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        [self downLoad];
    }];
}

- (void)downLoad {
    NSLog(@"downloading");
}

@end
