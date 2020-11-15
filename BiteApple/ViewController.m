//
//  ViewController.m
//  BiteApple
//
//  Created by jayhuan on 2020/10/1.
//

#import "ViewController.h"
#import "ObjcMsgSend.h"
#import "BAJSCoreViewController.h"
#import "BALoader.h"
#import "BALoaderChlid.h"
#import "BALoader+BACategory.h"
#import "BAMultiPageViewController.h"
#import "BAResponseChainView.h"
#import "BAScrollViewController.h"
#import "BAMethodsChain.h"
#import "BAMethodsChainChlid.h"

@interface ViewController ()
@property(nonatomic, strong) UILabel *channelBackView;
@property(nonatomic, strong) BAResponseChainView *chainView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ObjcMsgSend *msgSend = [[ObjcMsgSend alloc] init];
    [msgSend hello];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 60)];
    [btn setTitle:@"dianji" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(p_jump) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
//    BALoader *loader = [[BALoader alloc] init];
//    BALoaderChlid *loaderChlid = [[BALoaderChlid alloc] init];
    
    [self.view addSubview:self.channelBackView];
    
    self.chainView = [[BAResponseChainView alloc] initWithFrame:CGRectMake(200, 300, 300, 300)];
    [self.view addSubview:self.chainView];
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_chainViewClick)];
    [self.chainView addGestureRecognizer:ges];
    
    BAMethodsChain *methodsChain = [[BAMethodsChain alloc] init];
//    [((id)(methodsChain)) hello];
    [methodsChain test];
    BAMethodsChainChlid *methodsChainChlid = [[BAMethodsChainChlid alloc] init];
    [methodsChainChlid test];
    
    
    /*
    NSArray<NSString *> *symbols = [NSThread callStackSymbols];
    NSLog(@"symbols is %@", symbols);
    
    NSMutableArray<NSString *> *mArray = @[].mutableCopy;
    @try {
        NSString *item = [mArray objectAtIndex:0];
    } @catch (NSException *exception) {
        NSLog(@"exception is %@", exception);
    } @finally {
        NSLog(@"final hello world!");
    }
    
    NSLog(@"Hello worldA!");
    NSInteger a = 0;
    @try {
        CGFloat r = 6 / a;
    } @catch (NSException *exception) {
        NSLog(@"exception is %@", exception);
    } @finally {
        NSLog(@"final");
    }
    
    NSLog(@"Hello worldB!");
     */
}

- (void)hello {
    
}

- (void)p_chainViewClick {
    NSLog(@"btn-click chainView click");
}

- (UIView *)channelBackView {
    if (!_channelBackView) {
        _channelBackView = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 100, 36)];
        _channelBackView.textAlignment = UIListContentTextAlignmentCenter;
        _channelBackView.textColor = [UIColor whiteColor];
        _channelBackView.backgroundColor = [UIColor blueColor];
        _channelBackView.layer.masksToBounds = YES;
        _channelBackView.layer.cornerRadius = 17;
        _channelBackView.text = @"娱乐";
    }
    return _channelBackView;
}

- (void)p_jump {
//    BAJSCoreViewController *vc = [[BAJSCoreViewController alloc] init];
//    [self presentViewController:vc animated:YES completion:nil];
    
//    BAMultiPageViewController *pageVC = [[BAMultiPageViewController alloc] init];
    BAScrollViewController *pageVC = [[BAScrollViewController alloc] init];
    [self presentViewController:pageVC animated:NO completion:nil];
}

@end
