//
//  ExampleUIWebViewController.m
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 1/13/14.
//  Copyright (c) 2014 Marcus Westin. All rights reserved.
//

#import "ExampleUIWebViewController.h"
#import "WebViewJavascriptBridge.h"
#import "JSONKit.h"
@interface ExampleUIWebViewController ()<NativeApis>
@property WebViewJavascriptBridge* bridge;
@end

@implementation ExampleUIWebViewController
-(void) versionDDD{
    NSLog(@"asdfasdf");


}
- (void)viewWillAppear:(BOOL)animated {
    //字典转json
    NSDictionary *myClassDict;
    myClassDict = [NSDictionary dictionaryWithObjectsAndKeys:
                   @"1", @"my1",
                   @"2", @"my2",
                   @"3", @"my3",
                   @"4", @"my4", nil];
    NSString * rString=[myClassDict JSONString];
    NSLog(@"%@",rString);
    
    if (_bridge) { return; }
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    JSContext *jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    // call javascript
//    [jsContext evaluateScript:@"window.objectApis.doSomething()"];
    WBNativeApis *nativeApis = [[WBNativeApis alloc] init];
    jsContext[@"nativeApis"] = nativeApis;
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"来自objc的message Response for message from ObjC ");
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"send" message:data delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
        [alert show];
    }];
    //桥接，注册网页按钮方法
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {//fire_html按钮回调方法
        NSLog(@"testObjcCallback called: %@", data);
        responseCallback(@"Response from testObjcCallback");//回调网页内的方法
    }];
       
    [_bridge send:@"A string sent from ObjC before Webview has loaded." responseCallback:^(id responseData) {
        NSLog(@"objc got response! %@", responseData);
    }];
    
    [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
    
    [self renderButtons:webView];
    [self loadExamplePage:webView];
    
    [_bridge send:@"A string sent from ObjC after Webview has loaded."];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
}

- (void)renderButtons:(UIWebView*)webView {
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [messageButton setTitle:@"Send message" forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:messageButton aboveSubview:webView];
    messageButton.frame = CGRectMake(10, 414, 100, 35);
    messageButton.titleLabel.font = font;
    messageButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    
    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [callbackButton setTitle:@"Call handler" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(callHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:callbackButton aboveSubview:webView];
    callbackButton.frame = CGRectMake(110, 414, 100, 35);
    callbackButton.titleLabel.font = font;
    
    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reloadButton setTitle:@"Reload webview" forState:UIControlStateNormal];
    [reloadButton addTarget:webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:reloadButton aboveSubview:webView];
    reloadButton.frame = CGRectMake(210, 414, 100, 35);
    reloadButton.titleLabel.font = font;
}

- (void)sendMessage:(id)sender {
    [_bridge send:@"send A string sent from ObjC to JS" responseCallback:^(id response) {
        NSLog(@"sendMessage got response: %@", response);
    }];
}

- (void)callHandler:(id)sender {
    id data = @{ @"greetingFromObjC": @"Hi there, JS! 回调从objc到html" };
    [_bridge callHandler:@"testJavascriptHandler" data:data responseCallback:^(id response) {
        NSLog(@"testJavascriptHandler responded: %@", response);
    }];
}

- (void)loadExamplePage:(UIWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}
@end
