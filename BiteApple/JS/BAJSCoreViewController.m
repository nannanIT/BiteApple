//
//  BAJSCoreViewController.m
//  BiteApple
//
//  Created by jayhuan on 2020/10/22.
//

#import "BAJSCoreViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>

@interface BAJSCoreViewController ()
@property(nonatomic, strong) WKWebView *wkWebView;
@end

@implementation BAJSCoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)p_initWebView {
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKPreferences *preferences = [[WKPreferences alloc] init];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 30.0;
    configuration.preferences = preferences;
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    [self.view addSubview:self.wkWebView];
}

@end
