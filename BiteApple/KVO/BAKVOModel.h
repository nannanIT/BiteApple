//
//  BAKVOModel.h
//  BiteApple
//
//  Created by jayhuan on 2020/11/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BAKVOModel : NSObject

@property(nonatomic, assign) BOOL enabled;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *psw;
@property(nonatomic, copy) NSUInteger number;

@end

NS_ASSUME_NONNULL_END
