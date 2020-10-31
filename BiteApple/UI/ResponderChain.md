#  响应者链（Responder Chain）

```
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    // 1.判断下窗口能否接收事件
    if (self.userInteractionEnabled == NO || self.hidden == YES ||  self.alpha <= 0.01) 
        return nil; 
    
    // 2.判断下点在不在窗口上 
    // 不在窗口上 
    if ([self pointInside:point withEvent:event] == NO) 
        return nil;
    
    // 3.从后往前遍历子控件数组 
    int count = (int)self.subviews.count; 
    for (int i = count - 1; i >= 0; i--) { 
        // 获取子控件
        UIView *childView = self.subviews[i]; 
        // 坐标系的转换,把窗口上的点转换为子控件上的点 
        // 把自己控件上的点转换成子控件上的点 
        CGPoint childP = [self convertPoint:point toView:childView]; 
        UIView *fitView = [childView hitTest:childP withEvent:event]; 
        if (fitView) {
            // 如果能找到最合适的view 
            return fitView; 
        }
    } 
    // 4.没有找到更合适的view，也就是没有比自己更合适的view 
    return self;
}

// 作用:判断下传入过来的点在不在方法调用者的坐标系上
// point:是方法调用者坐标系上的点
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return YES;
}

```

手势识别

https://www.jianshu.com/p/8ce8e09c19f3
https://www.cnblogs.com/lxlx1798/articles/9705552.html

