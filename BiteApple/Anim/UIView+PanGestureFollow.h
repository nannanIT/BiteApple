//
//  UIView+PanGestureFollow.h
//  BiteApple
//
//  Created by jayhuan on 2020/12/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^BAPanGestureBlock)(CGPoint translation, CGPoint velocity);

@interface UIView (PanGestureFollow)

@property(nonatomic, copy) BAPanGestureBlock panGestureBeginBlock;
@property(nonatomic, copy) BAPanGestureBlock panGestureScrollBlock;
@property(nonatomic, copy) BAPanGestureBlock panGestureEndBlock;

@end

NS_ASSUME_NONNULL_END
