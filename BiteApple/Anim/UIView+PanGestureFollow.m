//
//  UIView+PanGestureFollow.m
//  BiteApple
//
//  Created by jayhuan on 2020/12/15.
//

#import "UIView+PanGestureFollow.h"
#import <objc/runtime.h>

@implementation UIView (PanGestureFollow)

- (void)setPanGestureBeginBlock:(BAPanGestureBlock)panGestureBeginBlock {
    objc_setAssociatedObject(self, @selector(panGestureBeginBlock), panGestureBeginBlock, OBJC_ASSOCIATION_COPY);
}

- (BAPanGestureBlock)panGestureBeginBlock {
    return objc_getAssociatedObject(self, @selector(panGestureBeginBlock));
}

- (void)setPanGestureScrollBlock:(BAPanGestureBlock)panGestureScrollBlock {
    objc_setAssociatedObject(self, @selector(panGestureScrollBlock), panGestureScrollBlock, OBJC_ASSOCIATION_COPY);
}

- (BAPanGestureBlock)panGestureScrollBlock {
    return objc_getAssociatedObject(self, @selector(panGestureScrollBlock));
}

- (void)setPanGestureEndBlock:(BAPanGestureBlock)panGestureEndBlock {
    objc_setAssociatedObject(self, @selector(panGestureEndBlock), panGestureEndBlock, OBJC_ASSOCIATION_COPY);
}

- (BAPanGestureBlock)panGestureEndBlock {
    return objc_getAssociatedObject(self, @selector(panGestureEndBlock));
}

- (void)followPanGesture:(UIPanGestureRecognizer *)panGesture {
    if (!panGesture) {
        return;
    }
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        // begin
    } else if (panGesture.state == UIGestureRecognizerStateChanged) {
        // scroll
        CGPoint point = [panGesture translationInView:self];
        CGPoint center = self.center;
        self.center = CGPointMake(center.x + point.x, center.y + point.y);
    } else {
        // end, 不包括failed
    }
}

@end
