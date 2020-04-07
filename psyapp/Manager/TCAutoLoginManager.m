//
//  TCAutoLoginManager.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/12.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCAutoLoginManager.h"
#import "UserService.h"
#import "DateUtil.h"
#import "LoginHttpManager.h"

@implementation TCAutoLoginManager
+ (void)startAutoLoginOnPermit:(void (^)(void))permit prohibition:(void (^)(void))prohibition {
    
    NSString *accessToken = UCManager.sharedInstance.formalAccount.accessToken;
    NSString *tokenExpiresIn = UCManager.sharedInstance.formalAccount.tokenExpiresIn;
//    NSString *loginName = UCManager.sharedInstance.formalAccount.loginName;
//    NSString *userId = [NSString stringWithFormat:@"%@",UCManager.sharedInstance.formalAccount.userInfo.userId];

    void (^loginFailedHandler)(void) = ^{
        mLog(@"Device-Test:无正式账号登录");
        [UCManager.sharedInstance clearFormalAccount];
        [self loginDeviceAccountIfTokenExpiredWithCompletion:prohibition];
    };
    
    void (^loginSuccessHandler) (void) = ^{
        //阿里云统计-自动登录
        mLog(@"Device-Test:正式账号Token未过期，获取孩子信息");
        
        LoginHttpManager *loginHttpManager = [LoginHttpManager new];
        [loginHttpManager getUserAndChildrenInfoOnSuccess:^{
            permit();
        } failure:^(LoginErrorType type) {
            if (type == LoginErrorTypeInfoDoseNotPerfect) {
                //账号信息未完善
            }
            loginFailedHandler();

        }];
    };
    
    if([NSString isEmptyString:accessToken]){
        loginFailedHandler();
        return;
    }
    
    [UserService getServerTimer:^(id data) {
        NSString *serverTime = data[@"datetime"];
        if (![NSString isEmptyString:tokenExpiresIn]) {
            if ([DateUtil tokenAvailableWithExpiredDate:tokenExpiresIn currentDate:serverTime]) {
                //判断是否续约(小于2天)
                if ([DateUtil tokenRemainTimeWithExpiredDate:tokenExpiresIn currentDate:serverTime] < 3600 * 48){
                    [UCManager.sharedInstance refreshFormalAccountTokenOnResult:^(BOOL refreshSuccess) {
                        if (refreshSuccess) {
                            loginSuccessHandler();
                        } else {
                            loginFailedHandler();
                        }
                    }];
                } else {
                    loginSuccessHandler();
                }
            } else {
                //token过期
                loginFailedHandler();
            }
        } else {
            loginFailedHandler();
        }
    } failure:^(NSError *error) {
        loginFailedHandler();
    }];
}

+ (void)loginDeviceAccountIfTokenExpiredWithCompletion:(void(^)(void))completion {
    //test 
//    [UCManager.sharedInstance clearDeviceAccount];
    
    NSString *accessToken = UCManager.sharedInstance.deviceAccount.accessToken;
    NSString *tokenExpiresIn = UCManager.sharedInstance.deviceAccount.tokenExpiresIn;
    void (^loginHandler)(void) = ^{
//        [UCManager.sharedInstance clearDeviceAccount];
        mLog(@"Device-Test:设备账号Token过期或不存在，尝试登录设备账号");
        [UCManager loginDeviceAccountOnSuccess:^(BOOL infoLacked) {
            if (completion) completion();
        } failure:^{
            if (completion) completion();
        }];
    };
    if ([NSString isEmptyString:accessToken]) {
        loginHandler();
    } else {
        [UserService getServerTimer:^(id data) {
            NSString *serverTime = data[@"datetime"];
            if (![NSString isEmptyString:tokenExpiresIn]) {
                if (![DateUtil tokenAvailableWithExpiredDate:tokenExpiresIn currentDate:serverTime]) {
                    //token过期 
                    loginHandler();
                } else {
                     mLog(@"Device-Test:设备账号Token未过期，获取孩子信息");
                    //获取孩子信息
                    [UCManager getDeviceAccountChildrenInfoOnSuccess:^{
                        if (completion) completion();
                    } failure:^(BOOL infoLacked) {
                        if (completion) completion();
                    }];
                }
            } else {
               loginHandler();
            }
        } failure:^(NSError *error) {
            loginHandler();
        }];
    }
   
}
@end
