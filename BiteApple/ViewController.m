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
}


@end
