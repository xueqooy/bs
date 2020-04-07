//
//  HttpErrorManager.m
//  smartapp
//
//  Created by lafang on 2018/8/24.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "HttpErrorManager.h"
#import "FECommonAlertView.h"


@implementation HttpErrorManager


+ (NSDictionary *)showErorInfo:(NSError *)error {
    return [self showErorInfo:error showView:mKeyWindow];
}

+(NSDictionary *) showErorInfo:(NSError *)error showView:(UIView *)showView{
    NSDictionary *errorDict;
    
    NSDictionary * errorInfo = error.userInfo;
    
    
    if ([[errorInfo allKeys] containsObject: @"com.alamofire.serialization.response.error.data"]){
        NSData * errorData = errorInfo[@"com.alamofire.serialization.response.error.data"];
        errorDict =  [NSJSONSerialization JSONObjectWithData: errorData options:NSJSONReadingAllowFragments error:nil];
        
        if(errorDict && ![errorDict isKindOfClass:[NSNull class]]){
            NSString *message;

            if ([errorDict.allKeys containsObject:@"error"]) {
                message = errorDict[@"error"];
                if(![NSString isEmptyString:message]){
                    [QSToast toast:showView message:message];
                }else{
                    [QSToast toast:showView message:@"网络无连接，请检查网络设置"];
                }
            } else {
                message = errorDict[@"message"];
                if(![NSString isEmptyString:message] && ![message isKindOfClass:[NSNull class]]){
                    NSString *shortMessage = message;
                    if ([message containsString:@"message:"]) {
                       NSRange range = [shortMessage rangeOfString:@"message:"];
                        shortMessage = [shortMessage substringFromIndex:range.location + range.length];
                    }
                    [QSToast toast:showView message:shortMessage];
                }else{
                    [QSToast toast:showView message:@"网络无连接，请检查网络设置"];
                }
            }
            
        }else{

            [QSToast toast:showView message:@"网络无连接，请检查网络设置"];

        }
    }else{
        [QSToast toast:showView message:@"网络无连接，请检查网络设置"];
    }
    
    return errorDict;
}

+ (NSDictionary *)getErorInfo:(NSError *)error{
    NSDictionary *errorDict;
    
    NSDictionary * errorInfo = error.userInfo;
    if ([[errorInfo allKeys] containsObject: @"com.alamofire.serialization.response.error.data"]){
        NSData * errorData = errorInfo[@"com.alamofire.serialization.response.error.data"];
        errorDict =  [NSJSONSerialization JSONObjectWithData: errorData options:NSJSONReadingAllowFragments error:nil];
    }
    
    return errorDict;
}

+ (NSString *)getNetworkType {
    UIApplication *app = [UIApplication sharedApplication];
    @try {
        NSArray *subviews = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
        NSString *network = @"";
        for (id subview in subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
                int networkType = [[subview valueForKeyPath:@"dataNetworkType"] intValue];
                switch (networkType) {
                    case 0:
                        network = @"NONE";
                        break;
                    case 1:
                        network = @"2G";
                        break;
                    case 2:
                        network = @"3G";
                        break;
                    case 3:
                        network = @"4G";
                        break;
                    case 5:
                        network = @"WIFI";
                        break;
                    default:
                        break;
                }
            }
        }
        if ([network isEqualToString:@""]) {
            network = @"NO DISPLAY";
        }
        return network;
        
    }@catch (NSException *exception) {
        return @"";
    }
    
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

//是否访客模式


//+(void)showLoginAlert:(UIViewController *)vc message:(NSString *)message{
//
//    FECommonAlertView *exitAlert = [[FECommonAlertView alloc] initWithTitle:message leftText:@"取消" rightText:@"确定" icon:nil];
//    exitAlert.resultIndex = ^(NSInteger index) {
//        if(index == 2){
//            AppDelegate *delegagte = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            [delegagte switchRootViewController:NO];
//            
//        }
//    };
//    [exitAlert showCustomAlertView];
//}

@end
