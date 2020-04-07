//
//  UserService.h
//  app
//
//  Created by linjie on 17/3/8.
//  Copyright © 2017年 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSRequestBase.h"
#import <UIKit/UIKit.h>

@interface UserService : NSObject

+ (void) login:(NSString *) loginName password:(NSString *)pwd success:(success)success failure:(failure) failure;

+ (void) loginThird:(NSString *) openId platSource:(NSString *)platSource thirdAccessToken:(NSString *)thirdAccessToken orgName:(NSString *)orgName success:(success)success failure:(failure) failure;

+ (void) thirdRegister:(NSString *) openId platSource:(NSString *)platSource thirdAccessToken:(NSString *)thirdAccessToken realName:(NSString *)realName birthday:(NSString *)birthday groupNo:(NSString *)groupNo sex:(NSString *)sex success:(success)success failure:(failure) failure;

+ (void) validInviteCode:(NSString *) inviteCode success:(success)success failure:(failure) failure;

+ (void) inviteRegister:(NSString *)inviteCode account:(NSString *)account password:(NSString *)pwd orgCode:(NSString *) orgCode success:(success)success failure:(failure) failure;

+ (void) userInfoWithSuccess:(success)success failure:(failure) failure;

+ (void) childList:(UInt64) userId success:(success)success failure:(failure) failure;

//+ (void) childInfo:(UInt64) childId success:(success)success failure:(failure) failure;

+ (void) getServerTimer:(success)success failure:(failure) failure;


//----------奇思火眼相关--------


//登录
+ (void) userLogin:(NSString *) loginName password:(NSString *)pwd sessionId:(NSString *)sessionId verificationCode:(NSString *)verificationCode success:(success)success failure:(failure) failure;
//第三方登录
+ (void) userLoginThird:(NSString *)openId appId:(NSString *)appId platSource:(NSString *)platSource thirdAccessToken:(NSString *)thirdAccessToken orgName:(NSString *)orgName success:(success)success failure:(failure) failure;
//手机短信登录
+(void)userLoginMobile:(NSString *) mobileNum mobileCode:(NSString *)mobileCode sessionId:(NSString *)sessionId success:(success)success failure:(failure) failure;
//手机短信注册
+(void)mobileRegister:(NSString *) mobileNum mobileCode:(NSString *)mobileCode password:(NSString *)password openId:(NSString *)openId platSource:(NSString *)platSource thirdAccessToken:(NSString *)thirdAccessToken appId:(NSString *)appId sessionId:(NSString *)sessionId success:(success)success failure:(failure) failure;
//退出登录
+(void)userLoginExit:(NSString *) accessToken  success:(success)success failure:(failure) failure;
//获取用户已经绑定第三方平台
+(void)getUserLoginThirds:(success)success failure:(failure) failure;
//第三方账号绑定
+(void)userThirdBinding:(NSString *) openId platSource:(NSString *)platSource thirdAccessToken:(NSString *)thirdAccessToken appId:(NSString *)appId success:(success)success failure:(failure) failure;
//已存在第三方账号绑定手机号
+(void)thirdBindingPhone:(NSString *)mobile mobileCode:(NSString *)mobileCode sessionId:(NSString *)sessionId success:(success)success failure:(failure) failure;
//修改密码
+(void)changePassword:(NSString *) oldPassword newPassword:(NSString *)newPassword success:(success)success failure:(failure) failure;
//发送验短信证码
+(void)sendSms:(NSString *)mobileNum sessionId:(NSString *)sessionId verificationCode:(NSString *)verificationCode type:(NSInteger)type tenant:(NSString *)tenant areaCode:(NSString *)areaCode success:(success)success failure:(failure) failure;
//手机找回密码
+(void)mobileSetPassword:(NSString *)mobile mobileCode:(NSString *)mobileCode password:(NSString *)password sessionId:(NSString *)sessionId success:(success)success failure:(failure) failure;
//创建会话
+(void)createSessions:(NSInteger)sessionType success:(success)success failure:(failure)failure;
//获取图片验证码
+(void)getVerificationCode:(NSString *)sessionId success:(success)success failure:(failure) failure;
//验证图片验证码
+(void)verifyVerificationCodeWithSessionId:(NSString *)sessionId verificationCode:(NSString *)verificationCode success:(success)success failure:(failure) failure;

//用户签到
+(void)userSignIn:(success)success failure:(failure) failure;
//用户签到状态
+(void)userSignInStage:(success)success failure:(failure) failure;
//用户积分列表
+(void)userScoreList:(NSInteger)page size:(NSInteger)size success:(success)success failure:(failure) failure;
//用户总积分，可用积分
+(void)userScoreAll:(success)success failure:(failure) failure;
//获取用户消息列表
+(void)userMessages:(NSInteger)page size:(NSInteger)size success:(success)success failure:(failure) failure;
//设置消息为已读
+(void)userReadMessage:(NSString *)messageId success:(success)success failure:(failure) failure;
//删除消息
+(void)userDeleteMessage:(NSString *)messageId success:(success)success failure:(failure) failure;
//获取用户未读消息数
+(void)userUnlookMessages:(success)success failure:(failure) failure;

//用户上传头像
+(void)uploadHeadImage:(UIImage *)image success:(success)success failure:(failure) failure;

//添加孩子信息
+ (void)addChildInfoByChildName:(NSString *)childName nickname:(NSString *)nickname sex:(NSString *)sex gradeNum:(NSString *)gradeNum birthday:(NSString *)birthday success:(success)success failure:(failure) failure;

//修改用户信息
+(void)userInfoModify:(NSString *)nickName success:(success)success failure:(failure) failure ;

//获取用户手机号
+ (void) getUserMobile:(success)success failure:(failure)failure;

//查看手机号是否注册
+ (void) mobileIsRegister:(NSString *)mobile success:(success)success failure:(failure) failure;

+ (void) getUserInfoWithSuccess:(success)success failure:(failure) failure;

+ (void) getChildList:(UInt64) userId success:(success)success failure:(failure) failure;

//+(void) getClassGroupInfo:(NSString *)groupNum success:(success)success failure:(failure) failure;

+(void)perfectUserInfo:(NSString *)groupNum sex:(NSNumber *)sex name:(NSString *)name birthday:(NSString *)birthday parentRole:(NSString *)parentRole nickName:(NSString *)nickName grade:(NSNumber *)grade success:(success)success failure:(failure) failure;
////获取视图权限
//+(void)getInterfacePermissionsWithSchoolID:(NSString *)schoolID childID:(NSString *)childID success:(success)success failure:(failure) failure;;


#pragma mark - 游客(设备)注册相关
//https://www.tapd.cn/22217601/markdown_wikis/view/#1122217601001001881@toc32

//获取加密UUID的公钥
+ (void)getRSAPublicKeyOfEncryptedUUIDOnSuccess:(success)success failure:(failure) failure;

//检查uuid是否注册
+ (void)postEncryptedUUID:(NSString *)uuid registerCheckOnSuccess:(success)success failure:(failure)failure;

//uuid注册并登录（之前检测不存在设备账户时）
+ (void)postEncryptedUUID:(NSString *)uuid registerOnSuccess:(success)success failure:(failure)failure;

//完善设备账号信息
+ (void)postPerfectDeviceAccountInfoByGender:(NSNumber *)gender grade:(NSNumber *)grade onSuccess:(success)success failure:(failure)failure;

//Token续约
+ (void)postTokenRefreshWithToken:(NSString *)refreshToken onSuccess:(success)success failure:(failure)failure;

//设备账号登录
+ (void)postDeviceAccountLoginByUUID:(NSString *)uuid encryptedUUID:(NSString *)encrypted onSuccess:(success)success failure:(failure)failure;


#pragma mark - mjb
+ (void)postAccountRegisterByAccount:(NSString *)account password:(NSString *)password onSuccess:(success)success failure:(failure)failure;
@end
