//
//  BAMultiPageView.m
//  BiteApple
//
//  Created by jayhuan on 2020/10/29.
//

#import "BAMultiPageView.h"

@interface BAMultiPageView ()<UIGestureRecognizerDelegate>

@end

@implementation BAMultiPageView

/*
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"gestureRecognizerShouldBegin");
    return YES;
}
*/

// 是否支持多手势触发，返回YES，则可以多个手势一起触发方法，返回NO则为互斥
// 是否允许多个手势识别器共同识别，一个控件的手势识别后是否阻断手势识别继续向下传播，默认返回NO；
// 如果为YES，响应者链上层对象触发手势识别后，如果下层对象也添加了手势并成功识别也会继续执行，否则上层对象识别后则不再继续传播。
// 响应者链上层指的优先响应手势的对象，第一响应者在最上层。 https://www.dazhuanlan.com/2019/10/10/5d9e3b885552f/
// 第一响应者是从父view到子view依次往下找。
// simultaneously 同时的
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    NSLog(@"shouldRecognizeSimultaneouslyWithGestureRecognizer");
    return NO;
}

@end
