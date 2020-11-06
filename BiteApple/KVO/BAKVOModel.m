//
//  BAKVOModel.m
//  BiteApple
//
//  Created by jayhuan on 2020/11/6.
//

#import "BAKVOModel.h"

static void *BAKVOModelObserverContext = &BAKVOModelObserverContext;

static NSArray *BAKVOModelObservedKeyPaths() {
    static NSArray *ObservedKeyPaths = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ObservedKeyPaths = @[NSStringFromSelector(@selector(enabled)),
                             NSStringFromSelector(@selector(name)),
                             NSStringFromSelector(@selector(psw)),
                             NSStringFromSelector(@selector(number))];
    });
    return ObservedKeyPaths;
}

@interface BAKVOModel ()
@property(nonatomic, strong) NSMutableSet<NSString *> *changedKeyPaths;
@end


@implementation BAKVOModel

- (instancetype)init {
    if (self = [super init]) {
        self.changedKeyPaths = [NSMutableSet set];
        
        for (NSString *keyPath in BAKVOModelObservedKeyPaths()) {
            [self addObserver:self
                   forKeyPath:keyPath
                      options:NSKeyValueObservingOptionNew
                      context:BAKVOModelObserverContext];
        }
    }
}

- (void)dealloc {
    for (NSString *keyPath in BAKVOModelObservedKeyPaths()) {
        [self removeObserver:self
                  forKeyPath:keyPath
                     context:BAKVOModelObserverContext];
    }
}

- (void)printChangedKeyPaths {
    for (NSString *keyPath in self.changedKeyPaths) {
        NSLog(@"%@", keyPath);
    }
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == BAKVOModelObserverContext) {
        NSObject *value = change[NSKeyValueChangeNewKey];
        if (value && ![value isEqual:[NSNull null]]) {
            [self.changedKeyPaths addObject:keyPath];
        } else {
            [self.changedKeyPaths removeObject:keyPath];
        }
    }
}

@end
