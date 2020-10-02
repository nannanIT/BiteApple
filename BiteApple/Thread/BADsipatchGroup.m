//
//  BADsipatchGroup.m
//  BiteApple
//
//  Created by jayhuan on 2020/10/2.
//

#import "BADsipatchGroup.h"

@implementation BADsipatchGroup

- (void)useGroupAsync {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        sleep(1);
        NSLog(@"Hello");
    });
    dispatch_group_async(group, queue, ^{
        sleep(2);
        NSLog(@"World");
    });
    dispatch_group_notify(group, queue, ^{
        NSLog(@"Hello world!");
    });
}

- (void)useGroupEnterAndLeave {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        sleep(1);
        NSLog(@"Hello");
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        sleep(2);
        NSLog(@"World");
        dispatch_group_leave(group);
    });
    
    /// 同步等待所有任务完成
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"Hello World!");
    });
}

@end
