//
//  BACellModel.h
//  BiteApple
//
//  Created by jayhuan on 2020/12/7.
//

#import <Foundation/Foundation.h>
#import "BAItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BACellModel : NSObject

@property(nonatomic, strong, readonly) BAItemModel *itemModel;

/// 各种unitViewModels

@end

NS_ASSUME_NONNULL_END
