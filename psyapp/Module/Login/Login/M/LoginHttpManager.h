//
//  LoginHttpManager.h
//  smartapp
//
//  Created by mac on 2019/7/22.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginHttpManager : NSObject
@property (nonatomic, copy) NSString *currentSessionId; //保存最近一次的会话Id
+ (instancetype)sharedManager;

/**
 获取环境状态，同时获取sessionId，不正常情况下，需要获取图形验证码
 */
- (void)getContextStatusForSessionType:(LoginSessionType)type onCompletion:(void (^)(BOOL isNormal))completion;

/**
 获取图形验证码图片
 */
- (void)getCaptchaImageBySessionId:(NSString *)sessionId onCompletion:(void (^)(UIImage *image))completion;

/**
 判断手机号是否已注册（密码重置、注册、登录前判断）
 */
- (void)judgingWhetherMobileIsRegistered:(NSString *)mobile requstSuccess:(void (^)(BOOL))result;

/**
 请求短信下发,调用前必须判断环境，除非已经确定当前环境不正常（已经出现图形验证码）
 */
- (void)requestSmsCodeForType:(LoginSmsCodeRequestType)type withMobile:(NSString *)mobile captcha:(NSString *)captcha onSuccess:(void (^)(void))success failure:(void (^)(LoginErrorType type))failure;


/**
 密码登录，调用前先判断手机后是否注册、环境是否正常（是否需要图形验证码）
 */
- (void)loginWithAccount:(NSString *)account password:(NSString *)password verifyCode:(NSString *)verifyCode onSuccess:(void (^)(void))success failure:(void (^)(LoginErrorType type))failure;

/**
 短信登录，调用前先判断手机后是否注册、环境是否正常（是否需要图形验证码）
 */
- (void)loginWithMobile:(NSString *)mobile mobileSmsCode:(NSString *)smsCode onSuccess:(void (^)(void))success failure:(void (^)(LoginErrorType type))failure;

/**
 注册（包括三方）
 */
- (void)registerWithMobile:(NSString *)mobile smsCode:(NSString *)code password:(NSString *)password openID:(NSString *)openID platSource:(NSString *)platSource thirdAccessToken:(NSString *)token appID:(NSString *)appID onSuccess:(void (^)(void))success failure:(void (^)(LoginErrorType type))failure;

- (void)registerWithAccount:(NSString *)account password:(NSString *)password onSuccess:(void (^)(void))success failure:(void (^)(LoginErrorType type))failure;

/**
 重置密码
 */
- (void)resetPasswordWithMobile:(NSString *)mobile mobileCode:(NSString *)mobileCode password:(NSString *)password onSuccess:(void (^)(void))success failure:(void (^)(LoginErrorType type))failure;

/**
 获取账户和孩子数据
 */
- (void)getUserAndChildrenInfoOnSuccess:(void (^)(void))success failure:(void(^)(LoginErrorType type))failure;




//-------------------完善信息时调用-----------------------

- (void)perfectUserInfoByNickname:(NSString *)nickname childName:(NSString *)childName gradeNum:(NSString *)gradeNum gender:(NSNumber *)gender OnSuccess:(void (^)(void))success failure:(void(^)(LoginErrorType type))failure;



//----------------------第三方绑定时调用-------------------------
#warning TODO:
//- (void)requestBindingSmsVerificationCodeWithMobile:(NSString *)mobile;

//旧版第三方绑定(bind_mobile = 0)
- (void)old_bindingThirdWithMobile:(NSString *)mobile mobileCode:(NSString *)code OnSuccess:(void (^)(void))success failure:(void(^)(LoginErrorType type))failure;
////新版第三方绑定(bind_mobile = 1)
- (void)new_bindingThirdWithOpenID:(NSString *)openID platSource:(NSString *)platSource thirdAccessToken:(NSString *)token appID:(NSString *)appID mobile:(NSString *)mobile mobileCode:(NSString *)code OnSuccess:(void (^)(void))success failure:(void(^)(LoginErrorType type))failure;


@end



NS_ASSUME_NONNULL_END
