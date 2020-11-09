//
//  BACalculateTwoNumber.m
//  BiteApple
//
//  Created by jayhuan on 2020/11/6.
//

#import "BACalculateTwoNumber.h"

@implementation BACalculateTwoNumber

- (instancetype)initWithBlock:(BACalculateTowNumberBlock)block {
    if (self = [super init]) {
        self.block = [block copy];
    }
    return self;
}

- (NSInteger)calculateTwoNumberOfNumberA:(NSInteger)numberA numberB:(NSInteger)numberB {
    return self.block(numberA, numberB);
}

@end
