//
//  UCManager.h
//  app
//
//  Created by linjie on 17/3/9.
//  Copyright © 2017年 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCUserInfo.h"
#import "TCFormalAccount.h"
#import "TCDeviceAccount.h"

#import "BSUser.h"

@interface UCManager : NSObject
@property (nonatomic, assign, readonly) BOOL isVisitorPattern;
@property (nonatomic, assign, readonly) BOOL didFormalAccountLogin;















@property (nonatomic, weak) TCDeviceAccount *deviceAccount;
@property (nonatomic, strong) TCFormalAccount *formalAccount;

+ (instancetype)sharedInstance;

@property (nonatomic, strong, readonly) TCUserInfo *userInfo;
@property (nonatomic, strong, readonly) TCChildrenInfo *children;
@property (nonatomic, weak, readonly) TCChildInfo *currentChild;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy, readonly) NSString *accessToken;
@property (nonatomic, copy, readonly) NSString *refreshToken;
@property (nonatomic, copy, readonly) NSString *serverTime;
@property (nonatomic, copy, readonly) NSString *tokenExpiresIn;
@property (nonatomic, copy, readonly) NSString *code;
@property (nonatomic,strong, readonly)NSString *careerChildExamId;


@property (nonatomic, assign) BOOL needPerfectInfoForDeviceAccount;
- (void)updateFormalAccountUserInfo:(TCUserInfo *)userInfo;
- (void)updateFormalAccountChildren:(TCChildrenInfo *)children;
- (void)updateFormalAccountTokenDictionary:(NSDictionary *)tokenDic;
- (void)updateFormalAccountChildExamId:(NSString *)childExamId;
- (void)updateFormalAccountLoginName:(NSString *)loginName;
- (void)clearFormalAccount;
- (void)refreshFormalAccountTokenOnResult:(void(^)(BOOL refreshSuccess))result;

- (void)updateDeviceAccountUserInfo:(TCUserInfo *)userInfo;
- (void)updateDeviceAccountChildren:(TCChildrenInfo *)children;
- (void)updateDeviceAccountTokenDictionary:(NSDictionary *)tokenDic;
- (void)updateDeviceAccountChildExamId:(NSString *)childExamId;
- (void)updateDeviceAccountLoginName:(NSString *)loginName;
- (void)clearDeviceAccount;
- (void)refreshDeviceAccountTokenOnResult:(void(^)(BOOL refreshSuccess))result;

+ (BOOL)showLoginAlertIfVisitorPatternWithMessage:(NSString *)message;
@end



@interface UCManager (DeviceLogin)
+ (void)startHandlingDeviceAutoLoginWhenNetworkingRestore; //监听网络状态恢复,判断是否需要登录设备账号

+ (void)registerDeviceUUIDOnSuccess:(void(^)(void))success failure:(void(^)(void))failure;
+ (void)perfectDeviceAccountInfoByGender:(NSNumber *)gender grade:(NSNumber *)grade onSuccess:(void(^)(void))success failure:(void(^)(void))failure;

//确保没有正式账号登录的情况下，再登录设备账号
+ (void)loginDeviceAccountOnSuccess:(void(^)(BOOL infoLacked))success failure:(void(^)(void))failure;
+ (void)getDeviceAccountChildrenInfoOnSuccess:(void(^)(void))success failure:(void(^)(BOOL infoLacked))failure;;
@end


