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
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    NSLog(@"shouldRecognizeSimultaneouslyWithGestureRecognizer");
    return YES;
}

@end
