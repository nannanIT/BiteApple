//
//  ViewController.m
//  BiteApple
//
//  Created by jayhuan on 2020/10/1.
//

#import "ViewController.h"
#import "ObjcMsgSend.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ObjcMsgSend *msgSend = [[ObjcMsgSend alloc] init];
    [msgSend hello];
    
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
}


@end
