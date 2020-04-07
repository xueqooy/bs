//
//  LoginCommon.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/11.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#ifndef LoginCommon_h
#define LoginCommon_h


typedef NS_OPTIONS(NSUInteger, LoginAction) {//jump:enum
    
    LoginActionQQ = 2,//三方登录
    LoginActionWX = 3,
    LoginActionVistor = 18,//游客 (废弃)

    LoginActionServiceAgreement = 19, //服务协议
    LoginActionSecretAgreement = 21,// 隐私政策
    
    LoginActionPerfectUserinfo = 16, //用户信息完善
    
    LoginActionLoginBySmsCode = 10, //注册/登录验证
    LoginActionThirdBinding = 12, //三方绑定手机号
    
    
    LoginActionLoginByPassword = 4,//账号密码登录
    LoginActionPasswordForget = 5,//点击忘记密码
    LoginActionModeSwitch = 6,//注册/登录切换
   
    LoginActionCaptchaImageChange = 20,//切换图形验证码
    LoginActionPasswordResttingSmsCodeRequest = 17,//重置密码获取短信验证码
    LoginActionPasswordResttingNext = 7,//重置密码界面点击完成
    
    LoginActionSmsCodeResend = 15,//短信重发
    LoginActionRegistrationCompletion = 14, //注册填写验证码和设置密码的登录按钮
    LoginActionLoginSmsCodeInputCompletion = 9, //登录验证码输入完成

    
    LoginActionResetComplete = 8,
    LoginActionRegisterInviteNext = 13, //邀请码下一步
    LoginActionRegisterToPhoneSigin = 11,//注册页面前往账号密码登录界面
  
};

typedef NS_OPTIONS(NSUInteger, LoginSessionType) {
    LoginSessionTypeSmsCodeRequest = 4,
    LoginSessionTypePasswordLogin = 1
};


typedef NS_OPTIONS(NSUInteger, LoginSmsCodeRequestType) {
    LoginSmsCodeRequestTypeRegistration = 0,
    LoginSmsCodeRequestTypeSignIn = 1,
    LoginSmsCodeRequestTypePasswordReset = 3
};

typedef NS_OPTIONS(NSUInteger, LoginErrorType) {
    LoginErrorTypeUnknown = 200,
    LoginErrorTypeAccountDoesNotExist = 100,
    LoginErrorTypeWrongAccountOrPassword = 101,
    LoginErrorTypeWrongSmsCode = 102,
    LoginErrorTypeWrongCaptcha = 103,
    LoginErrorTypeSmsCodeLimitation = 104,
    LoginErrorTypeInfoDoseNotPerfect = 105
};

typedef NS_OPTIONS(NSUInteger, LoginWayType) {
    LoginWayTypeGeneral = 0,
    LoginWayTypeeWX,
    LoginWayTypeQQ
};
#endif /* LoginCommon_h */
