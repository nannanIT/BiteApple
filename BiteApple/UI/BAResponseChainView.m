//
//  BAResponseChainView.m
//  BiteApple
//
//  Created by jayhuan on 2020/10/29.
//

#import "BAResponseChainView.h"

@interface BAResponseChainView ()
@property(nonatomic, strong) UIView *childView;
@property(nonatomic, strong) UIButton *btn;
@property(nonatomic, strong) UIButton *btnA;
@end

@implementation BAResponseChainView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.childView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
            view.backgroundColor = [UIColor orangeColor];
            view;
        });
        [self addSubview:self.childView];
        
        self.btnA = ({
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 50, 30)];
            btn.backgroundColor = UIColor.greenColor;
            [btn addTarget:self action:@selector(btnAClick) forControlEvents:UIControlEventTouchUpInside];
            btn.userInteractionEnabled = NO;
            btn;
        });
        [self.childView addSubview:self.btnA];
        
        self.btn = ({
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 70, 50, 30)];
            btn.backgroundColor = UIColor.redColor;
            [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        [self addSubview:self.btn];
    }
    return self;
}

- (void)btnClick {
    NSLog(@"btn-click btn clicked");
}

- (void)btnAClick {
    NSLog(@"btn-click btnA clicked");
}

@end
