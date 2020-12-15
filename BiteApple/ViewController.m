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
#import "BiteApple-Swift.h"

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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self setAppIconWithName:@"starimage"];
    });
    
    // oc 调用 swift
    BASwiftApple *bs = [[BASwiftApple alloc] init];
    [bs functionAWithName:@"hello 122222" :12];
    [bs functionBWithName:@"hello 133333" age:13];
    
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
    int a = 100;
    int b = 100;
    const int *A = &a;
    A = &b;
//    *A = 123; // 报错
    int *const B = &b;
//    B = &a; 报错
    *B = 123;
    
    const NSString *hello = @"hello";
    hello = @"world";
    NSString *const hello2 = @"hello";
//    hello2 = @"world2";
    NSLog(@"");
    
    /*
     常量指针：就是指向常量的指针，关键字 const 出现在 * 左边，表示指针所指向的地址的内容是不可修改的，但指针自身可变。
     指针常量：指针自身是一个常量，关键字 const 出现在 * 右边，表示指针自身不可变，但其指向的地址的内容是可以被修改的。
     在此例中：我们知道，NSString永远是immutable的，也是一个指针常量，所以NSString * const 是有效的，而const NSString * 则是无效的。而使用错误的写法，则无法阻止修改该指针指向的地址，使得本应该是常量的值能被修改，造成了隐患。这是需要注意的一个常见错误。
     */
}

- (void)setAppIconWithName:(NSString *)iconName {
    if (![[UIApplication sharedApplication] supportsAlternateIcons]) {
        return;
    }
    
    if ([iconName isEqualToString:@""]) {
        iconName = nil;
    }
    [[UIApplication sharedApplication] setAlternateIconName:iconName completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"更换app图标发生错误了 ： %@",error);
        }
    }];
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
    [self presentViewController:pageVC animated:YES completion:nil];
}

@end
