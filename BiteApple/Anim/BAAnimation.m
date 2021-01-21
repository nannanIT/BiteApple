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


// 整体属于CoreAnimation框架

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

/*
 
 - (instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth {
     if (self = [super initWithFrame:frame]) {
         _lineWidth = lineWidth;
         float centerX = self.bounds.size.width / 2.0;
         float centerY = self.bounds.size.height / 2.0;
         //半径
         float radius = (self.bounds.size.width - _lineWidth) / 2.0;
         
         //创建贝塞尔路径
         UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY)
                                                             radius:radius
                                                         startAngle:(-0.5f * M_PI)
                                                           endAngle:1.5f * M_PI
                                                          clockwise:YES];
         
         //添加背景圆环
         
         CAShapeLayer *backLayer = [CAShapeLayer layer];
         backLayer.frame = self.bounds;
         backLayer.fillColor = [UIColor clearColor].CGColor;
         backLayer.qn_strokeColorPicker = QNColorPickerWithColor([CUtil colorWithRGB:0xe36d5f alpha:0.1], [CUtil colorWithRGB:0xcc3136 alpha:0.2]);
         backLayer.lineWidth = _lineWidth;
         backLayer.path = [path CGPath];
         backLayer.strokeEnd = 1;
         backLayer.cornerRadius = self.bounds.size.height / 2;
         [self.layer addSublayer:backLayer];
         
         //创建进度layer
         _progressLayer = [CAShapeLayer layer];
         _progressLayer.frame = self.bounds;
         _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
         //指定path的渲染颜色
         _progressLayer.qn_strokeColorPicker = QNColorPickerWithColor(HEX(0xf35543), HEX(0xcc3156));
         _progressLayer.lineCap = kCALineCapRound;
         _progressLayer.lineWidth = _lineWidth;
         _progressLayer.path = [path CGPath];
         _progressLayer.strokeEnd = 0;
         [self.layer addSublayer:_progressLayer];
     }
     return self;
 }

 - (void)setProgress:(CGFloat)progress {
     _progress = progress;
     _progressLayer.strokeEnd = progress;
     [_progressLayer removeAllAnimations];
 }
 
 */

- (void)useTransform {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.transform = CGAffineTransformMakeTranslation(20, 0);
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 10, 10);
    
// https://www.jianshu.com/p/3bc427f0dd56
}

- (void)trans {
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:1];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    [UIView animateWithDuration:1 animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
    
    [CATransaction commit];
}

// CADisplayLink & CAShapeLayer
// http://www.cocoachina.com/articles/18252
// iOS 渲染流程
// https://www.jianshu.com/p/2eab8599517b
// iOS图像处理之Core Graphics和OpenGL ES小析
// https://www.jianshu.com/p/f66a7ca326dd?nomobile=yes

@end
