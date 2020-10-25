//
//  BADeadLock.m
//  BiteApple
//
//  Created by jayhuan on 2020/10/25.
//

#import "BADeadLock.h"

@interface BADeadLock ()
@property(nonatomic, strong) NSLock *lock;
@end

@implementation BADeadLock

- (instancetype)init {
    if (self = [super init]) {
        self.lock = [[NSLock alloc] init];
    }
    return self;
}

- (void)methodA {
    [self.lock lock];
    NSLog(@"hello world A");
    [self.lock unlock];
}

/**
 * 执行下面代码会死锁，methodA中的锁在没有解锁之前被methodB重复使用，A需要等待B中的锁解锁才能执行，B需要A执行完才能解锁，互相等待造成死锁。
 * 以用NSRecursiveLock或者@synchronized替代NSLock
 * NSRecursiveLock或者@synchronized都是递归锁，
 */
- (void)methodB {
    [self.lock lock];
    NSLog(@"hello world B");
    [self methodA];
    [self.lock unlock];
}

/**
 * 同步任务会阻塞当前线程，然后把 Block 中的任务放到指定的队列中执行，只有等到 Block 中的任务完成后才会让当前线程继续往下运行。
 *
 * dispatch_sync会立即堵塞主线程，然后把 Block 中的任务放到 main_queue 中， main_queue 中的任务被取出来放到主线程中执行，但主线程这个时候已经被阻塞了，所以 Block 中的任务就不能完成，它不完成，dispatch_sync 就会一直阻塞主线程，造成死锁。
 */
- (void)syncInMainQueue {
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"Hello world");
    });
}

@end
