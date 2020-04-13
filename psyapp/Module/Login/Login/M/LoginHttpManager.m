//
//  LoginHttpManager.m
//  smartapp
//
//  Created by mac on 2019/7/22.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "LoginHttpManager.h"
#import "UserService.h"
#import "RSA.h"

#import <AVOSCloud/AVOSCloud.h>

@implementation LoginHttpManager

#pragma mark -- 初始化
+ (instancetype)sharedManager {
    static LoginHttpManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}


#pragma mark - 请求登录和密码重置短信验证码

#pragma mark - 请求短信验证码
- (void)requestSmsCodeForType:(LoginSmsCodeRequestType)type withMobile:(NSString *)mobile captcha:(NSString *)captcha onSuccess:(void (^)(void))success failure:(nonnull void (^)(LoginErrorType))failure{
    [UserService sendSms:mobile sessionId:self.currentSessionId verificationCode:[NSString isEmptyString:captcha]? @"" : captcha type:type tenant:@"CHEERSMIND" areaCode:@"+86" success:^(id data) {
        [QSLoadingView dismiss];
        
        if(![API_HOST isEqualToString:@"https://psytest-server.cheersmind.com"]){//如果在开发环境,不会下发短信,需要弹窗提示
            NSLog(@"开发环境短信验证码:%@",data[@"code"]);
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"测试验证码" message:data[@"code"] delegate:self
                                                       cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        if (success) success();
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        NSDictionary *errorDic = [HttpErrorManager getErorInfo:error];
        
        if ([errorDic[@"message"] isEqualToString:@"需要验证码"]) {
            [QSToast toast:mKeyWindow message:@"图片验证码输入错误"];
            if (failure) failure(LoginErrorTypeWrongCaptcha);
        } else if ([errorDic[@"message"] containsString:@"上限" ] || [errorDic[@"message"] containsString:@"短信发送过于频繁"]) {  //短信发送上限或太频繁  就不再弹窗输入验证码了
            if (failure) failure(LoginErrorTypeSmsCodeLimitation);
            [HttpErrorManager showErorInfo:error showView:mKeyWindow];
        } else {
            [HttpErrorManager showErorInfo:error showView:mKeyWindow];
            if (failure) failure(LoginErrorTypeUnknown);
        }
        
    }];
}
        
    

#pragma mark - 短信验证码登录
- (void)loginWithMobile:(NSString *)mobile mobileSmsCode:(nonnull NSString *)smsCode onSuccess:(nonnull void (^)(void))success failure:(nonnull void (^)(LoginErrorType))failure{
    [QSLoadingView show];
    
    [UserService userLoginMobile:mobile mobileCode:smsCode sessionId:_currentSessionId success:^(id data) {
        [QSLoadingView dismiss];
        [UCManager sharedInstance].loginName = mobile;
        if (success) success();
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error showView:mKeyWindow];
        if (failure) failure(LoginErrorTypeUnknown);
    }];
        
}

#pragma mark - 账号密码登录以及异常状态的判断
- (void)loginWithAccount:(NSString *)account password:(NSString *)password verifyCode:(NSString *)verifyCode onSuccess:(nonnull void (^)(void))success failure:(nonnull void (^)(LoginErrorType))failure {
    [BSUser logInWithUsernameInBackground:account password:password block:^(AVUser * _Nullable user, NSError * _Nullable error) {
        BSUser *currentUser = BSUser.currentUser;
        if (user) {
            if ([NSString isEmptyString:currentUser.nickname]) {
                if (failure) failure(LoginErrorTypeInfoDoseNotPerfect);
            } else {
                success();
            }
        } else {
            NSDictionary *errorDic = [HttpErrorManager getErorInfo:error];
            if ([errorDic[@"code"] isEqualToNumber:@211]) {
                if(failure) failure(LoginErrorTypeAccountDoesNotExist);
            } else if ([errorDic[@"code"] isEqualToNumber:@210]) {
                [QSToast toastWithMessage:@"账号不存在或密码错误"];
                if (failure) failure(LoginErrorTypeUnknown);
            } else  {
                [HttpErrorManager showErorInfo:error];
                if (failure) failure(LoginErrorTypeUnknown);
            }
        }
    }];
}

#pragma mark - 注册手机号
- (void)registerWithMobile:(NSString *)mobile smsCode:(NSString *)code password:(NSString *)password openID:(NSString *)openID platSource:(NSString *)platSource thirdAccessToken:(NSString *)token appID:(NSString *)appID onSuccess:(nonnull void (^)(void))success failure:(nonnull void (^)(LoginErrorType))failure{
    [QSLoadingView show];
    [UserService mobileRegister:mobile mobileCode:code password:password openId:openID platSource:platSource thirdAccessToken:token appId:appID sessionId:_currentSessionId success:^(id data) {
        [QSLoadingView dismiss];
        [UCManager.sharedInstance updateFormalAccountTokenDictionary:data];
    
        [QSToast toastWithMessage:@"恭喜你！注册成功"];
        if (success) success();
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error showView:mKeyWindow];
        if (failure) failure(LoginErrorTypeUnknown);
    }];
}

- (void)registerWithAccount:(NSString *)account password:(NSString *)password onSuccess:(void (^)(void))success failure:(void (^)(LoginErrorType))failure {
    [QSLoadingView show];
    BSUser *user = BSUser.user;
    user.username = account;
    user.password = password;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [QSLoadingView dismiss];
        if (succeeded) {
            if (success) success();
        } else {
            [HttpErrorManager showErorInfo:error];
            if (failure) failure(LoginErrorTypeUnknown);
        }
    }];
    
}

- (void)perfectUserInfoByNickname:(NSString *)nickname childName:(NSString *)childName gradeNum:(NSString *)gradeNum gender:(NSNumber *)gender OnSuccess:(void (^)(void))success failure:(void (^)(LoginErrorType))failure {
    [QSLoadingView show];
    @weakObj(self);
    BSUser *currentUser = BSUser.currentUser;
    if (currentUser) {
        currentUser.nickname = nickname;
        currentUser.realName = childName;
        currentUser.gender = gender;
        currentUser.gradeNum = @(gradeNum.intValue);

        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [QSLoadingView dismiss];
            if (succeeded) {
                [selfweak _swithToMainForLoginSuccess];
                if (success) success();
            } else {
                [HttpErrorManager showErorInfo:error];
                if (failure) failure(LoginErrorTypeUnknown);
            }
        }];
    } else {
        [QSLoadingView dismiss];
        if (failure) failure(LoginErrorTypeAccountDoesNotExist);
    }

}


- (void)_swithToMainForLoginSuccess {
    mLog(@"登录成功");
    [NSNotificationCenter.defaultCenter postNotificationName:nc_window_root_switch object:WINDOW_ROOT_MAIN];
}

#pragma mark - 重置密码
- (void)resetPasswordWithMobile:(NSString *)mobile mobileCode:(NSString *)mobileCode password:(nonnull NSString *)password onSuccess:(nonnull void (^)(void))success failure:(nonnull void (^)(LoginErrorType))failure{

    if ([NSString isEmptyString:_currentSessionId]) {
        [QSToast toast:mKeyWindow message:@"请先获取短信验证码"];
        return;
    }
    [QSLoadingView show];
    [UserService mobileSetPassword:mobile mobileCode:mobileCode password:password sessionId:_currentSessionId success:^(id data) {
        [QSLoadingView dismiss];
        [QSToast toastWithMessage:@"密码重置成功"];
        if (success) success();
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error showView:mKeyWindow];
        if (failure) failure(LoginErrorTypeUnknown);
    }];
}



#pragma mark - 第三方绑定 旧
- (void)old_bindingThirdWithMobile:(NSString *)mobile mobileCode:(NSString *)code OnSuccess:(nonnull void (^)(void))success failure:(nonnull void (^)(LoginErrorType))failure{
    [QSLoadingView  show];
    @weakObj(self);
    [UserService thirdBindingPhone:mobile mobileCode:code sessionId:_currentSessionId success:^(id data) {
        
        [self getUserAndChildrenInfoOnSuccess:^{
            [selfweak _swithToMainForLoginSuccess];
            if (success) success();
        } failure:^(LoginErrorType type) {
            if (failure) failure(type);
        }];
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error showView:mKeyWindow];
        if (failure) failure(LoginErrorTypeUnknown);
    }];
}

#pragma mark - 第三方绑定新
- (void)new_bindingThirdWithOpenID:(NSString *)openID platSource:(NSString *)platSource thirdAccessToken:(NSString *)token appID:(NSString *)appID mobile:(NSString *)mobile mobileCode:( NSString *)code OnSuccess:(nonnull void (^)(void))success failure:(nonnull void (^)(LoginErrorType))failure{
    [QSLoadingView show];
    [UserService userLoginMobile:mobile mobileCode:code sessionId:_currentSessionId success:^(id data) {
        [UCManager sharedInstance].loginName = mobile;
        //绑定第三方账号
        @weakObj(self);

        [UserService userThirdBinding:openID platSource:platSource thirdAccessToken:token appId:appID success:^(id data) {
            [self getUserAndChildrenInfoOnSuccess:^{
                [selfweak _swithToMainForLoginSuccess];
                if (success) success();
            } failure:^(LoginErrorType type) {
                if (failure) failure(type);
            }];
        } failure:^(NSError *error) {
            [HttpErrorManager showErorInfo:error showView:mKeyWindow];
            [self getUserAndChildrenInfoOnSuccess:^{
                [selfweak _swithToMainForLoginSuccess];
                if (success) success();
            } failure:^(LoginErrorType type) {
                if (failure) failure(type);
            }];
        }];

    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error showView:mKeyWindow];
        if (failure) failure(LoginErrorTypeUnknown);

    }];

}



#pragma mark - 手机号是否注册判断
- (void)judgingWhetherMobileIsRegistered:(NSString *)mobile requstSuccess:(void (^)(BOOL))result {
    [UserService mobileIsRegister:mobile success:^(id data) {
        BOOL mobileIsRegister = [data[@"result"] boolValue];
        result(mobileIsRegister);
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error showView:mKeyWindow];
    }];
}

#pragma mark - 更新sessionID和图形验证码
- (void)getContextStatusForSessionType:(LoginSessionType)type onCompletion:(void (^)(BOOL))completion {
    [UserService createSessions:type success:^(id data) {
        if (data) {
            _currentSessionId = data[@"session_id"];
            
            if (completion) {
                completion([data[@"normal"] boolValue]);
            }
        }
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [QSToast toast:mKeyWindow message:@"服务器繁忙,请稍后再试"];
    }];
}


//
//- (void)p_createSessionWhenErrorOccuredWithSessionType:(LoginHttpManagerVerifyCodeImageType)type {
//    NSInteger sessionType;
//    //只要是请求短信sessionType都是4
//    if (type == LoginHttpManagerVerifyCodeImageTypeResetPassword || type == LoginHttpManagerVerifyCodeImageTypeRegister || type == LoginHttpManagerVerifyCodeImageTypeSmsLogin) {
//        sessionType = 4;
//    } else { //账号密码登录时sessionType = 1
//        sessionType = 1;
//    }
//    [UserService createSessions:sessionType success:^(id data) {
//        if(data){
//            _sessionID = data[@"session_id"];
//            if(![data[@"normal"] boolValue]) {
//                [self p_downloadVerificationCodePictureForType:type];//重新获取验证码图片
//            } else {
//            }
//        }
//    } failure:^(NSError *error) {
//        if (_delegate) {
//            [_delegate http_loginResult:NO for:LoginHttpManagerResultTypeCreateSession ifFailure:error];
//        }
//    }];
//}

 
#pragma mark - 获取用户和孩子信息, 并且判断用户权限 (登录成功调用)
-(void)getUserAndChildrenInfoOnSuccess:(void (^)(void))success failure:(void (^)(LoginErrorType))failure{
    [UserService getUserInfoWithSuccess:^(id data) {
        //设置用户信息
        TCUserInfo *userInfo = [MTLJSONAdapter modelOfClass:TCUserInfo.class fromJSONDictionary:data error:nil];
        [UCManager.sharedInstance updateFormalAccountUserInfo:userInfo];
    
        
        [UserService getChildList:0 success:^(id data) {
            TCChildrenInfo *children = [MTLJSONAdapter modelOfClass:TCChildrenInfo.class fromJSONDictionary:data error:nil];
            [UCManager.sharedInstance updateFormalAccountChildren:children];

            if (UCManager.sharedInstance.children.items.count > 0) {

                [QSLoadingView  dismiss];
                if (success) success();
            }else{
                 [QSLoadingView dismiss];
//                [QSToast toast:mKeyWindow message:@"请先完善个人信息"];
                if (failure) failure(LoginErrorTypeInfoDoseNotPerfect);
            }
            
        } failure:^(NSError *error) {
            [QSLoadingView  dismiss];
            [HttpErrorManager showErorInfo:error showView:mKeyWindow];
            if(failure) failure(LoginErrorTypeUnknown);
        }];
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        LoginErrorType type = LoginErrorTypeUnknown;
        
        NSDictionary *errorDict;
        
        NSDictionary * errorInfo = error.userInfo;
        if ([[errorInfo allKeys] containsObject: @"com.alamofire.serialization.response.error.data"]){
            NSData * errorData = errorInfo[@"com.alamofire.serialization.response.error.data"];
            errorDict =  [NSJSONSerialization JSONObjectWithData: errorData options:NSJSONReadingAllowFragments error:nil];
        }
        
        if(errorDict && ![errorDict isKindOfClass:[NSNull class]]){
            //用户已经注册，但是没有完善用户信息，去完善用户信息界面
            if([errorDict[@"code"] isEqualToString:@"PSY_USER_NOT_FOUND"]){
                type = LoginErrorTypeInfoDoseNotPerfect;
            }else{
                NSString *message = errorDict[@"message"];
                if(message && ![message isKindOfClass:[NSNull class]]){
//                    [QSToast toastWithMessage:@"请先完善个人信息"];
                }else{
                    if([[HttpErrorManager getNetworkType] isEqualToString:@"NONE"] || [[HttpErrorManager getNetworkType] isEqualToString:@"NO DISPLAY"]){
                        [QSToast toast:mKeyWindow message:@"网络无连接，请检查网络设置"];
                    }else{
                        [QSToast toast:mKeyWindow message:@"服务器繁忙，请稍后再试！"];
                    }
                }
            }
        }
        
        if (failure) failure(type);
    }];
}

#pragma mark - 下载图形验证码
- (void)getCaptchaImageBySessionId:(NSString *)sessionId onCompletion:(void (^)(UIImage * _Nonnull))completion {
    NSString *url = FE_URL_GET_IMAGE;
    
    url = [url stringByReplacingOccurrencesOfString:@"{session_id}" withString:sessionId];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        
        NSFileManager* fileManager=[NSFileManager defaultManager];
        BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:path];
        if(blHave){
            [fileManager removeItemAtPath:path error:nil];
        }
        
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSString *imgFilePath = [filePath path];
         UIImage *img = [UIImage imageWithContentsOfFile:imgFilePath];
        
        [QSLoadingView dismiss];

        if (completion) {
            completion(img);
        }
    
    }];
    [downloadTask resume];
}

//- (void)p_downloadVerificationCodePictureForType:(LoginHttpManagerVerifyCodeImageType) type {
//    _smsVerifyCodeImage = nil;
//    _verifyCodeImage = nil;
//    _registerVerifyCodeImage = nil;
//    _resetPasswordVerifyCodeImage = nil;
//
//    NSString *url = FE_URL_GET_IMAGE;
//    NSString *requestSessionID;
//    if (type == LoginHttpManagerVerifyCodeImageTypeSmsLogin ||type == LoginHttpManagerVerifyCodeImageTypeResetPassword ) {
//        requestSessionID = _smsSessionID;
//    } else if (type == LoginHttpManagerVerifyCodeImageTypeAccountAndPasswordLogin) {
//        requestSessionID = _sessionID;
//    } else {
//        requestSessionID = _registerSessionID;
//    }
//
//    url = [url stringByReplacingOccurrencesOfString:@"{session_id}" withString:requestSessionID];
//
//    NSURL *URL = [NSURL URLWithString:url];
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
//
//        NSFileManager* fileManager=[NSFileManager defaultManager];
//        BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:path];
//        if(blHave){
//            [fileManager removeItemAtPath:path error:nil];
//        }
//
//        return [NSURL fileURLWithPath:path];
//
//    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//        NSString *imgFilePath = [filePath path];
//         UIImage *img = [UIImage imageWithContentsOfFile:imgFilePath];
//        if (img) {
//            if (type == LoginHttpManagerVerifyCodeImageTypeSmsLogin) {
//                smsVerficationCodeImageTimes ++;
//                _smsVerifyCodeImage = img;
//            } else if (type == LoginHttpManagerVerifyCodeImageTypeAccountAndPasswordLogin) {
//                verificationCodeImageTimes ++;
//                _verifyCodeImage = img;
//            } else if (type == LoginHttpManagerVerifyCodeImageTypeRegister){
//                registerVerificationCodeImageTimes ++;
//                _registerVerifyCodeImage = img;
//            } else if (type == LoginHttpManagerVerifyCodeImageTypeResetPassword){
//                resetPasswordVerificationCodeImageTimes ++;
//                _resetPasswordVerifyCodeImage = img;
//            }
//        }
//
//        if (type == LoginHttpManagerVerifyCodeImageTypeSmsLogin) {
//            if (smsVerficationCodeImageTimes == 1) {
//                [QSToast toast:mKeyWindow message:@"需要输入验证码"];
//            }
//        } else if (type == LoginHttpManagerVerifyCodeImageTypeAccountAndPasswordLogin) {
//            if (verificationCodeImageTimes == 1) {
//                [QSToast toast:mKeyWindow message:@"需要输入验证码"];
//            }
//        } else if (type == LoginHttpManagerVerifyCodeImageTypeRegister) {
//            if (registerVerificationCodeImageTimes == 1) {
//                [QSToast toast:mKeyWindow message:@"需要输入验证码"];
//            }
//        } else if (type == LoginHttpManagerVerifyCodeImageTypeResetPassword) {
////            if (resetPasswordVerificationCodeImageTimes == 1) {
////                [QSToast toast:mKeyWindow message:@"需要输入验证码"];
////            }
//        }
//        [QSLoadingView dismiss];
//
//        [_delegate http_loadVerificationCodeImageWhenAbnormalContextWithImage:img forType:type];//通知VC加载验证码图片
//
//    }];
//    [downloadTask resume];
//}

#pragma mark - 界面切换是更新变量
//- (void)resetWhenInterfaceSwitchingOccurs {
//    self.currentOperationalMobile = @"";
//    verificationCodeImageTimes = 0;
//    smsVerficationCodeImageTimes = 0;
//    registerVerificationCodeImageTimes = 0;
//    resetPasswordVerificationCodeImageTimes = 0;
//}

#pragma mark - 设置当前操作的手机号 (未调用)
//- (void)setCurrentOperationalMobile:(NSString *)currentOperationalMobile {
//    if (![_currentOperationalMobile isEqualToString: currentOperationalMobile]) {//请求的手机号更换
//        _currentOperationalMobile = currentOperationalMobile;
//
//        _sessionID = @"";
//        _smsSessionID = @"";
//        _registerSessionID = @"";
//        _resetPasswordSessionID = @"";
//
//        _registerVerifyCodeImage = nil;
//        _smsVerifyCodeImage = nil;
//        _verifyCodeImage = nil;
//        _resetPasswordVerifyCodeImage = nil;
//    }
//}

@end
