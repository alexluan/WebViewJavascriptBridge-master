//
//  WBNativeApis.h
//  ExampleApp-iOS
//
//  Created by 栾有数 on 15/11/9.
//  Copyright © 2015年 Marcus Westin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol NativeApis <JSExport>

-(void) versionDDD;
-(void) versionDDD1:(NSString *)str;
void maxvalue(int  a,int  b);//失败
-(void)Input:(NSString *) aa Input2:(NSString*)bb;
@end

@interface WBNativeApis : NSObject<NativeApis>

@end
