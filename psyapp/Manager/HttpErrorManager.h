//
//  HttpErrorManager.h
//  smartapp
//
//  Created by lafang on 2018/8/24.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
#import "QSToast.h"
#import "AppDelegate.h"

@interface HttpErrorManager : NSObject

+(NSDictionary *)showErorInfo:(NSError *)error showView:(UIView *)showView;
+(NSDictionary *)showErorInfo:(NSError *)error;

+(NSDictionary *)getErorInfo:(NSError *)error;

+ (NSString *)getNetworkType;

//+ (NSString *)hasNetwork;

+ (UIViewController *)getCurrentVC;


+(void)showLoginAlert:(UIViewController *)vc message:(NSString *)message; //通用退出提示

@end
