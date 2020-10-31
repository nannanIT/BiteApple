//
//  QNChannelGuideHeadView.m
//  BiteApple
//
//  Created by jayhuan on 2020/10/26.
//

#import "QNChannelGuideHeadView.h"

@interface QNChannelGuideHeadView ()
@property(nonatomic, strong) UIImageView *headView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *descLabel;
@property(nonatomic, strong) UIButton *jumpBtn;
@end

@implementation QNChannelGuideHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.headView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            imageView;
        });
        [self addSubview:self.headView];
        
        self.nameLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            
            label;
        });
        [self addSubview:self.nameLabel];
        
        self.descLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            
            label;
        });
        [self addSubview:self.descLabel];
        
        self.jumpBtn = ({
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
            
            btn;
        });
        [self addSubview:self.jumpBtn];
        
        // UIView 部分圆角的设定
        UIBezierPath*maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                      byRoundingCorners:(UIRectCornerTopRight | UIRectCornerTopLeft)
                                                            cornerRadii:CGSizeMake(4,4)];//圆角大小
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }
    return self;
}

@end
