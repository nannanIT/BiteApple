//
//  BADrawView.m
//  BiteApple
//
//  Created by jayhuan on 2020/11/29.
//

#import "BADrawView.h"

// UIBezierPath 属于UIKit层

@implementation BADrawView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    // UIKit 方法
    /*
    UIBezierPath* p = [UIBezierPathbezierPathWithOvalInRect:CGRectMake(0,0,100,100)];
    [[UIColor blueColor] setFill];
    [p fill];
     */
    
    // CoreGraphics 方法
    /*
    CGContextRef con = UIGraphicsGetCurrentContext();
    // ellipse:椭圆
    CGContextAddEllipseInRect(con, CGRectMake(0, 0, 100, 100));
    CGContextSetFillColorWithColor(con, [UIColor orangeColor].CGColor);
    CGContextFillPath(con);
     */
    
    /*
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(100,100), NO, 0);
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(con, CGRectMake(0,0,100,100));
    CGContextSetFillColorWithColor(con, [UIColor blueColor].CGColor);
    CGContextFillPath(con);
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
     */
    
    // layer和动画 CoreAnimation
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    [super drawLayer:layer inContext:ctx];
    // 该方法基类已经实现，自动调用drawRect
    // 如果实现了drawRect才调用
    
    /*
    UIGraphicsPushContext(ctx);
    UIBezierPath* p = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,100,100)];
    [[UIColor blueColor] setFill];
    [p fill];
    UIGraphicsPopContext();
     */
}

- (void)displayLayer:(CALayer *)layer {
    // 优先加载本方法，基类没有实现
    // 如果实现了drawRect才调用
}

@end
