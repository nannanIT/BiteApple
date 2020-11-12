//
//  BAScrollViewController.m
//  BiteApple
//
//  Created by jayhuan on 2020/11/10.
//

#import "BAScrollViewController.h"

@interface BAScrollViewController ()

@property(nonatomic, strong) UIView *bgViewA;
@property(nonatomic, strong) UIView *bgViewB;

@end

@implementation BAScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat itemWidth = width - 20;
    
    self.bgViewB = [[UIView alloc] initWithFrame:CGRectMake(10, 200, itemWidth, 300)];
    self.bgViewB.backgroundColor = [UIColor purpleColor];
    self.bgViewB.alpha = 0.f;
    [self.view addSubview:self.bgViewB];
    
    self.bgViewA = [[UIView alloc] initWithFrame:CGRectMake(10, 200, itemWidth, 300)];
    self.bgViewA.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.bgViewA];
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(p_handleGesture:)];
    [self.view addGestureRecognizer:panGes];
}

- (void)p_handleGesture:(UIPanGestureRecognizer *)ges {
    NSLog(@"");
    static NSInteger flag = 1;
    static BOOL animing = NO;
    
    if (ges.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [ges translationInView:self.view];
        CGFloat offsetX = fabs(point.x);
        if (offsetX < 50) {
            NSLog(@"too small");
            return;
        }
        if (point.x < 0) {
            NSLog(@"%@", @(point.x));
            if (!animing) {
                animing = YES;
                /*
                self.bgViewB.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.3, 0.3);
                [UIView animateWithDuration:0.5 animations:^{
                    self.bgViewA.alpha = flag % 2;
//                    self.bgViewB.alpha = (flag - 1) % 2;
                    self.bgViewB.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                } completion:^(BOOL finished) {
                    flag++;
                    animing = NO;
                }];
                 */
                
                // 根据箭头的方向决定anchorPoint的位置
//                self.bgViewB.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
                
                // 设置了anchorPoint后frame会改变，需要还原frame
//                self.bgViewB.frame = CGRectMake(10, 200, self.bgViewB.frame.size.width, 300);
                self.bgViewB.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
//                CATransition *trans = [CATransition animation];
//                trans.type = @"cameraIrisHollowOpen";
//                trans.duration = 1.f;
//                [self.bgViewB.layer addAnimation:trans forKey:@"trans"];
                self.bgViewB.alpha = 0.f;
                self.bgViewA.alpha = 1.f;
                [UIView animateWithDuration:1.f
                                      delay:0
                     usingSpringWithDamping:1.f
                      initialSpringVelocity:0.f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                    self.bgViewA.alpha = 0.f;
                    self.bgViewB.alpha = 1.f;
                    self.bgViewB.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                } completion:^(BOOL finished) {
                    flag++;
                    animing = NO;
                }];
            }
        } else {
            NSLog(@"%@", @(point.x));
        }
    }
}

@end
