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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ObjcMsgSend *msgSend = [[ObjcMsgSend alloc] init];
    [msgSend hello];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 60)];
    [btn setTitle:@"dianji" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(p_jump) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    BALoader *loader = [[BALoader alloc] init];
    BALoaderChlid *loaderChlid = [[BALoaderChlid alloc] init];
    
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

- (void)p_jump {
    BAJSCoreViewController *vc = [[BAJSCoreViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
