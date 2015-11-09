//
//  ExampleUIWebViewController.h
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 1/13/14.
//  Copyright (c) 2014 Marcus Westin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "WBNativeApis.h"

@protocol NativeApis <JSExport>

-(void) versionDDD;

@end
@interface ExampleUIWebViewController : UINavigationController <UIWebViewDelegate>

@end