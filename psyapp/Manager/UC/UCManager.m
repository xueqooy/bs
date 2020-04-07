//
//  UCManager.m
//  app
//
//  Created by linjie on 17/3/9.
//  Copyright © 2017年 jeyie0. All rights reserved.
//

#import "UCManager.h"
#import "UserService.h"
#import "RSA.h"

#import "FECommonAlertView.h"

#import "FELoginViewController.h"


#define RETURN_NIL_IF_VISITOR  if(self.isVisitorPattern) return nil;
#define RETURN_OBJ(property) \
    RETURN_NIL_IF_VISITOR\
    if (self.didFormalAccountLogin) {\
        return [self.formalAccount property];\
    } else {\
        return [self.deviceAccount property];\
    }\


@implementation UCManager

+ (instancetype)sharedInstance {
    static UCManager *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[super allocWithZone:NULL] init];
        instance.deviceAccount = TCDeviceAccount.deviceAccount;
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}


- (BOOL)didFormalAccountLogin {
    if (BSUser.currentUser) {
        return YES;
    } else {
        return NO;
    }
//    if ([NSString isEmptyString:self.formalAccount.accessToken] == NO) {
//        return YES;
//    }
//    return NO;
}

- (BOOL)isVisitorPattern {
    if (BSUser.currentUser) {
        return NO;
    } else {
        return YES;
    }
//    if (self.didFormalAccountLogin == YES) {
//        return NO;
//    } else {
//        if ([NSString isEmptyString:self.deviceAccount.accessToken] == NO) {
//            return NO;
//        }
//    }
//    return YES;
}

#pragma mark property
- (NSString *)loginName {
    RETURN_OBJ(loginName);
}

- (TCUserInfo *)userInfo {
    RETURN_OBJ(userInfo)
}

- (TCChildrenInfo *)children {
    RETURN_OBJ(children)
}

- (TCChildInfo *)currentChild {
    RETURN_OBJ(currentChild)
}

- (NSString *)accessToken {
    RETURN_OBJ(accessToken)
}

- (NSString *)refreshToken {
    RETURN_OBJ(refreshToken)
}

- (NSString *)serverTime {
    RETURN_OBJ(serverTime)
}

- (NSString *)tokenExpiresIn {
    RETURN_OBJ(tokenExpiresIn)
}

- (NSString *)code {
    RETURN_OBJ(code)
}

- (NSString *)careerChildExamId {
    RETURN_OBJ(careerChildExamId)
}

#pragma mark - formal account

- (TCFormalAccount *)formalAccount {
    if (_formalAccount == nil) {
        _formalAccount = TCFormalAccount.new;
    }
    return _formalAccount;
}

- (void)updateFormalAccountChildren:(TCChildrenInfo *)children {
    self.formalAccount.children = children;
}

- (void)updateFormalAccountUserInfo:(TCUserInfo *)userInfo {
    self.formalAccount.userInfo = userInfo;
}

- (void)updateFormalAccountTokenDictionary:(NSDictionary *)tokenDic {

    self.formalAccount.accessToken = tokenDic[@"access_token"];
    self.formalAccount.tokenExpiresIn = tokenDic[@"expires_in"];
    self.formalAccount.refreshToken = tokenDic[@"refresh_token"];
    self.formalAccount.code = tokenDic[@"code"];
    self.formalAccount.serverTime = tokenDic[@"server_time"];
    self.formalAccount.userInfo.userId = tokenDic[@"user_id"];
    

}

- (void)updateFormalAccountChildExamId:(NSString *)childExamId {
    self.formalAccount.careerChildExamId = childExamId;
}

- (void)updateFormalAccountLoginName:(NSString *)loginName {
    self.formalAccount.loginName = loginName;
}

- (void)clearFormalAccount {

    [_formalAccount resetData];
    _formalAccount = nil;
}

- (void)refreshFormalAccountTokenOnResult:(void (^)(BOOL refreshSuccess))result {
    [UserService postTokenRefreshWithToken:_formalAccount.refreshToken onSuccess:^(id data) {
        if (![NSString isEmptyString:data[@"access_token"]]) {
            [self updateFormalAccountTokenDictionary:data];
            if (result) result(YES);
        } else {
            if (result) result(NO);
        }
    } failure:^(NSError *error) {
        if (result) result(NO);
    }];
}


#pragma mark - device account
- (void)updateDeviceAccountChildren:(TCChildrenInfo *)children {
    self.deviceAccount.children = children;
}

- (void)updateDeviceAccountUserInfo:(TCUserInfo *)userInfo {
    self.deviceAccount.userInfo = userInfo;

}

- (void)updateDeviceAccountTokenDictionary:(NSDictionary *)tokenDic {
    self.deviceAccount.accessToken = tokenDic[@"access_token"];
    self.deviceAccount.tokenExpiresIn = tokenDic[@"expires_in"];
    self.deviceAccount.refreshToken = tokenDic[@"refresh_token"];
    self.deviceAccount.code = tokenDic[@"code"];
    self.deviceAccount.serverTime = tokenDic[@"server_time"];
    self.deviceAccount.userInfo.userId = tokenDic[@"user_id"];
    
}

- (void)updateDeviceAccountChildExamId:(NSString *)childExamId {
    self.deviceAccount.careerChildExamId = childExamId;
}

- (void)updateDeviceAccountLoginName:(NSString *)loginName {
    self.deviceAccount.loginName = loginName;
}

- (void)clearDeviceAccount {
    [_deviceAccount resetData];
}

- (void)refreshDeviceAccountTokenOnResult:(void (^)(BOOL))result {
    [UserService postTokenRefreshWithToken:_deviceAccount.refreshToken onSuccess:^(id data) {
        if (![NSString isEmptyString:data[@"access_token"]]) {
            [self updateDeviceAccountTokenDictionary:data];
            if (result) result(YES);
        } else {
            if (result) result(NO);
        }
    } failure:^(NSError *error) {
        if (result) result(NO);
    }];
}


+ (BOOL)showLoginAlertIfVisitorPatternWithMessage:(NSString *)message {
    if (UCManager.sharedInstance.isVisitorPattern == NO) return NO;
    NSString *msg = [NSString isEmptyString:message]? @"登录后可继续，确定去登录吗？" : message;
    FECommonAlertView *exitAlert = [[FECommonAlertView alloc] initWithTitle:msg leftText:@"取消" rightText:@"确定" icon:nil];
    exitAlert.resultIndex = ^(NSInteger index) {
        if(index == 2){
            [NSNotificationCenter.defaultCenter postNotificationName:nc_window_root_switch object:WINDOW_ROOT_LOGIN];
        }
    };
    [exitAlert showCustomAlertView];
    return YES;
}

@end


#import "TCDeviceLoginInfoPerfectionViewController.h"
#import "TCUserDataRestter.h"

@implementation UCManager (DeviceLogin)
static BOOL isReachableBefore = YES;//标记之前的网络状态
+ (void)startHandlingDeviceAutoLoginWhenNetworkingRestore {
    //UCManager生命周期就是App的运行周期，不需要释放观察者
    [NSNotificationCenter.defaultCenter addObserverForName:nc_networking_status_change object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        if (UCManager.sharedInstance.didFormalAccountLogin) return ;
        if (note.object) {
            if ([note.object isKindOfClass:NSNumber.class]) {
                AFNetworkReachabilityStatus status = [note.object integerValue];
                if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable) {
                    if (isReachableBefore == NO) return;
                    //从可达到不可达状态的切换
                    isReachableBefore = NO;
                } else {
                    if (isReachableBefore == YES) return;
                    //从不可达到可达状态的切换
                    isReachableBefore = YES;
                    [self handleNetworkingRestore];
                }
            }
        }
    }];
}

+ (void)handleNetworkingRestore {
    if (UCManager.sharedInstance.didFormalAccountLogin) return;
    if (UCManager.sharedInstance.isVisitorPattern ||
        ([NSString isEmptyString:UCManager.sharedInstance.currentChild.childId] &&
         !UCManager.sharedInstance.userInfo.userId)) {
        mLog(@"Device-Test:网络状态恢复，尝试登录设备账号");
        //登录设备账号
        [self loginDeviceAccountOnSuccess:^(BOOL infoLacked) {
            void (^reloadTabControllerHandler)(void) = ^{
                [TCUserDataRestter reset2];
                [NSNotificationCenter.defaultCenter postNotificationName:nc_main_tab_reload object:nil];
            };
            
            if (infoLacked) {
                //设备登录，信息未完善的情况下，完善信息
                UCManager.sharedInstance.needPerfectInfoForDeviceAccount = YES;
                if (UCManager.sharedInstance.needPerfectInfoForDeviceAccount) {
                    UIViewController *visibleViewController = QMUIHelper.visibleViewController;
                    if (visibleViewController) {
                        UCManager.sharedInstance.needPerfectInfoForDeviceAccount = NO;
                        [TCDeviceLoginInfoPerfectionViewController showWithPresentedViewController:visibleViewController onPerfectionSuccess:^{
                            reloadTabControllerHandler();
                        }];
                        return;
                    }
                }
            }
            reloadTabControllerHandler();
        } failure:^{
        }];
    }
}

+ (void)getRSAPublicKeyOnSuccess:(void(^)(NSString *key))success failure:(void(^)(void))failure {
    [UserService getRSAPublicKeyOfEncryptedUUIDOnSuccess:^(id data) {
        NSString *key = data[@"rsa_public_key"];
        if (success) success(key);
    } failure:^(NSError *error) {
        mLog(@"Device-Test:获取公钥失败");
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error];
        if (failure) failure();
    }];
}

static NSString *_encryptedUUID;
+ (void)checkDeviceUUIDRegisteredOnResult:(void (^)(BOOL))result failure:(void (^)(void))failure{
    [self getRSAPublicKeyOnSuccess:^(NSString *key) {
        NSString *UUID = [FEDeviceManager getDiviceUUIDFromKeyChain];
        _encryptedUUID = [RSA encryptString:UUID publicKey:key];
        [UserService postEncryptedUUID:_encryptedUUID registerCheckOnSuccess:^(id data) {
            BOOL _result = [data[@"result"] boolValue];
            if (_result == NO) {
                [UCManager.sharedInstance clearDeviceAccount];
                mLog(@"Device-Test:设备账号未注册");
            } else {
                mLog(@"Device-Test:设备账号已注册");
            }
            if (result) result(_result);
        } failure:^(NSError *error) {
            mLog(@"Device-Test:检查设备账号注册请求失败");
            [HttpErrorManager showErorInfo:error];
            [QSLoadingView dismiss];
            if (failure) failure();
        }];
    } failure:^{
        if (failure) failure();
    }];
}

+ (void)registerDeviceUUIDOnSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    [self checkDeviceUUIDRegisteredOnResult:^(BOOL registered) {
        if (registered == NO) {
            [UserService postEncryptedUUID:_encryptedUUID registerOnSuccess:^(id data) {
                mLog(@"Device-Test:设备账号注册成功");
                [UCManager.sharedInstance updateDeviceAccountTokenDictionary:data];
                if (success) success();
            } failure:^(NSError *error) {
                mLog(@"Device-Test:设备账号注册失败");
                [HttpErrorManager showErorInfo:error];
                if (failure) failure();
            }];
        } else {
            if (success) success();
        }
    } failure:^{
        if (failure) failure();
    }];
}

+ (void)perfectDeviceAccountInfoByGender:(NSNumber *)gender grade:(NSNumber *)grade onSuccess:(void (^)(void))success failure:(void (^)(void))failure{
    if (UCManager.sharedInstance.isVisitorPattern) {
        mLog(@"Device-Test:设备账号未注册");
        if (failure) failure();
        return;
    }
    
    [UserService postPerfectDeviceAccountInfoByGender:gender grade:grade onSuccess:^(id data) {
        TCChildInfo *child = TCChildInfo.new;
        child.childId = data[@"child_id"];
        TCChildrenInfo *children = TCChildrenInfo.new;
        children.items = @[child];
        children.total = 1;
        [UCManager.sharedInstance updateDeviceAccountChildren:children];
        [self getDeviceAccountChildrenInfoOnSuccess:nil failure:nil];
        mLog(@"Device-Test:设备信息完善成功");
        if (success) success();
    } failure:^(NSError *error) {
        mLog(@"Device-Test:设备信息完善失败");
        [HttpErrorManager showErorInfo:error];
        if (success) success();
    }];
}

+ (void)loginDeviceAccountOnSuccess:(void (^)(BOOL infoLacked))success failure:(void (^)(void))failure {
    [self checkDeviceUUIDRegisteredOnResult:^(BOOL registered) {
        if (registered) {
            mLog(@"Device-Test:设备账号请求登录");
            [UserService postDeviceAccountLoginByUUID:[FEDeviceManager getDiviceUUIDFromKeyChain] encryptedUUID:_encryptedUUID onSuccess:^(id data) {
                [UCManager.sharedInstance updateDeviceAccountTokenDictionary:data];
                //获取用户信息
                mLog(@"Device-Test:设备账号登录成功，获取孩子信息");
                [self getDeviceAccountChildrenInfoOnSuccess:^{
                    mLog(@"Device-Test:设备账号获取孩子信息成功");
                    if (success) success(NO);
                } failure:^(BOOL infoLacked) {
                    if (infoLacked) {
                        mLog(@"Device-Test:设备账号信息未完善");
                    } else {
                        mLog(@"Device-Test:设备账号获取孩子信息失败");
                    }
                    if (success) success(infoLacked);
                }];
            }failure:^(NSError *error) {
                [UCManager.sharedInstance clearDeviceAccount];
                if (failure) failure();
            }];
        } else {
            if (failure) failure();
        }
    } failure:^{
        if (failure) failure();
    }];
}

+ (void)getDeviceAccountChildrenInfoOnSuccess:(void(^)(void))success failure:(void(^)(BOOL infoLacked))failure; {
    [UserService getUserInfoWithSuccess:^(id data) {
        //设置用户信息
        TCUserInfo *userInfo = [MTLJSONAdapter modelOfClass:TCUserInfo.class fromJSONDictionary:data error:nil];
        [UCManager.sharedInstance updateDeviceAccountUserInfo:userInfo];

        [UserService getChildList:0 success:^(id data) {
            TCChildrenInfo *children = [MTLJSONAdapter modelOfClass:TCChildrenInfo.class fromJSONDictionary:data error:nil];
            [UCManager.sharedInstance updateDeviceAccountChildren:children];
            if (UCManager.sharedInstance.deviceAccount.children.items.count > 0) {
                //信息已经完善
                UCManager.sharedInstance.needPerfectInfoForDeviceAccount = NO;
                if (success) success();
            }else{
                UCManager.sharedInstance.needPerfectInfoForDeviceAccount = YES;
                if (failure) failure(YES);
            }
        } failure:^(NSError *error) {
            [UCManager.sharedInstance clearDeviceAccount];
            [HttpErrorManager showErorInfo:error];
            if (failure) failure(NO);
        }];
    } failure:^(NSError *error) {
        NSDictionary * errorInfo = [HttpErrorManager getErorInfo:error];
    
        if(errorInfo && ![errorInfo isKindOfClass:[NSNull class]]){
            if([errorInfo[@"code"] isEqualToString:@"PSY_USER_NOT_FOUND"]){
                 UCManager.sharedInstance.needPerfectInfoForDeviceAccount = YES;
                if (failure) failure(YES);
            }else{
                [UCManager.sharedInstance clearDeviceAccount];
                [HttpErrorManager showErorInfo:error];
                if (failure) failure(NO);
            }
        } else {
            [UCManager.sharedInstance clearDeviceAccount];
            if (failure) failure(NO);
        }
    }];
}


@end

