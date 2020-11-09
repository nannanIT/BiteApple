//
//  BACalculateTwoNumber.h
//  BiteApple
//
//  Created by jayhuan on 2020/11/6.
//

#import <Foundation/Foundation.h>

typedef NSInteger (^BACalculateTowNumberBlock)(NSInteger numberA, NSInteger numberB);

@protocol BACalculateTwoNumberProtocol <NSObject>

- (NSInteger)calculateTwoNumberOfNumberA:(NSInteger)numberA numberB:(NSInteger)numberB;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BACalculateTwoNumber : NSObject<BACalculateTwoNumberProtocol>

@property(nonatomic, copy) BACalculateTowNumberBlock block;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithBlock:(BACalculateTowNumberBlock)block;

@end

NS_ASSUME_NONNULL_END
