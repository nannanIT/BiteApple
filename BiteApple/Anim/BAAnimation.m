//
//  BAAnimation.m
//  BiteApple
//
//  Created by jayhuan on 2020/11/6.
//

#import "BAAnimation.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CALayer.h>
#import <UIKit/UIKit.h>

static CGFloat const kQNRadius = 10.f;
static CGFloat const kQNLineWidth = 1.0;
static CGFloat const kQNAnimDuration = 1.25f;
static CGFloat const kQNAnimWaitTime = 0.41f;

/**
 - CAAnimation 抽象类，各种animation的基类：CABasicAnimation, CAKeyframeAnimation, CAAnimationGroup, or CATransition.
 参数:
 timingFunction : CAMediaTimingFunction, 动画节奏
 delegate : id <CAAnimationDelegate>, 开始和结束
 
 - CAAnimationGroup 同时执行多个动画 allows multiple animations to be grouped and run concurrently(同时地).
 各个动画的执行时间以group设置的为准
 */

@implementation BAAnimation

- (void)addGroupAnimForLayer {
    // 创建一个圆
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    const CGFloat radius = 10.f;
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:(CGPoint){radius, radius}
                                                              radius:radius
                                                          startAngle:0
                                                            endAngle:2 * M_PI
                                                           clockwise:YES];
    shapeLayer.path = circlePath.CGPath;
    shapeLayer.strokeStart = 0.f;
    shapeLayer.strokeEnd = 0.1;
    
    // 增加start动画
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @(0.f);
    strokeStartAnimation.toValue = @(0.9);
    strokeStartAnimation.beginTime = kQNAnimWaitTime;
    strokeStartAnimation.speed = (1 + kQNAnimWaitTime / (kQNAnimDuration - kQNAnimWaitTime));
    // 动画先减速后加速
    strokeStartAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    // 增加end动画
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @(0.1);
    strokeEndAnimation.toValue = @(1);
    // 先加速后减速
    strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    // 增加旋转动画
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @(-0.35 * 2 * M_PI);           // 初始位置
    rotationAnimation.toValue = @((0.1 + 1 - 0.35) * 2 * M_PI);  // 0.1是调整位置
    
    // 使用group管理动画
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = kQNAnimDuration;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeRemoved;
    group.beginTime = 0.f;
    group.repeatCount = MAXFLOAT;
    group.animations = @[ strokeStartAnimation, strokeEndAnimation, rotationAnimation ];
    
    [shapeLayer addAnimation:group forKey:nil];
}

- (void)waveAnim {
    CABasicAnimation *waveAAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    waveAAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
    waveAAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    waveAAnimation.repeatCount = NSIntegerMax;
    waveAAnimation.duration = 2.f;
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@1, @1, @0.9, @0.8, @(0.7), @(0.5), @(0)];
    opacityAnimation.keyTimes = @[@0, @(1 / 6.f), @(2 / 6.f),@(3 / 6.f),@(4 / 6.f),@(5 / 6.f),@1];
    opacityAnimation.duration = 2.f;
    opacityAnimation.repeatCount = NSIntegerMax;
    
    // https://www.jianshu.com/p/bdf492023feb
}

@end
