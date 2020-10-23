//
//  BAJSCoreViewController.m
//  BiteApple
//
//  Created by jayhuan on 2020/10/22.
//

#import "BAJSCoreViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>

@interface BAJSCoreViewController ()<WKScriptMessageHandler>
@property(nonatomic, strong) WKWebView *wkWebView;
@end

@implementation BAJSCoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self p_initWebView];
}

- (void)p_initWebView {
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKPreferences *preferences = [[WKPreferences alloc] init];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 30.0;
    configuration.preferences = preferences;
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"index.html" ofType:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:urlStr];
    [self.wkWebView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
    [self.view addSubview:self.wkWebView];
    
    [self p_registerHandler];
}

- (void)p_registerHandler {
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self
                                                                           name:@"share"];
}

- (void)p_shareWithDict:(NSDictionary *)dict {
    
}


#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"share"]) {
        [self p_shareWithDict:message.body];
    }
}

@end
