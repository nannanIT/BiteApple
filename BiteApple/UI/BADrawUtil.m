//
//  BADrawUtil.m
//  BiteApple
//
//  Created by jayhuan on 2020/12/21.
//

#import "BADrawUtil.h"
#import <UIKit/UIKit.h>

@implementation BADrawUtil

+ (UIImage *)p_pointImage {
    CGFloat wh = 6;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(wh, wh), NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor orangeColor] setFill];
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, wh, wh)
                                                byRoundingCorners:UIRectCornerAllCorners
                                                      cornerRadii:CGSizeMake(wh, wh)];
    CGContextAddPath(ctx, path.CGPath);
    
    CGContextDrawPath(ctx, kCGPathFillStroke);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
