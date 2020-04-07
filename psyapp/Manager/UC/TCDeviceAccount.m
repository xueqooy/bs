//
//  TCDeviceAccount.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/26.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCDeviceAccount.h"
#import <Mantle.h>
static NSString * const accessTokenKey = @"_access_token_device";
static NSString * const refreshTokenKey = @"_refresh_token_device";
static NSString * const serverTimeKey = @"_server_time_device";
static NSString * const tokenExpiresInKey = @"_token_expires_in_device";
static NSString * const codeKey = @"_code_device";
static NSString * const careerChildExamIdKey = @"_career_child_exam_id_device";
static NSString * const childrenKey = @"_children_device";
static NSString * const userInfoKey = @"_userInfo_device";


@implementation TCDeviceAccount {
    TCChildrenInfo *_children;
    TCUserInfo *_userInfo;
}
+ (instancetype)deviceAccount {
    static TCDeviceAccount *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self deviceAccount];
}

- (void)resetData {
    self.userInfo = nil;
    self.children = nil;
    self.accessToken = nil;
    self.refreshToken = nil;
    self.serverTime = nil;
    self.careerChildExamId = nil;
    self.tokenExpiresIn = nil;
    self.code = nil;
    self.loginName = nil;
}
//设备账号将用户、孩子信息持久化存储
- (TCUserInfo *)userInfo {
    if (_userInfo == nil) {
        NSData *data  = [NSUserDefaults.standardUserDefaults objectForKey:userInfoKey];
        TCUserInfo *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (userInfo) {
            _userInfo = userInfo;
        } else {
            _userInfo = TCUserInfo.new;
        }
    }
    return _userInfo;
}

- (void)setUserInfo:(TCUserInfo *)userInfo{
    _userInfo = userInfo;
    if (userInfo) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    
        [NSUserDefaults.standardUserDefaults setValue:data forKey:userInfoKey];
        [NSUserDefaults.standardUserDefaults synchronize];
    }

}


- (TCChildrenInfo *)children {
    if (_children == nil) {
        NSData *data  = [NSUserDefaults.standardUserDefaults objectForKey:childrenKey];
        TCChildInfo *child = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        _children = TCChildrenInfo.new;
        if (child) {
            NSArray *items = @[child];
            _children.items = items ;
        }
    }
    return _children;
}

- (void)setChildren:(TCChildrenInfo *)children {
    _children = children;
    if (children.items && children.items.count > 0) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:children.items.firstObject];
    
        [NSUserDefaults.standardUserDefaults setValue:data forKey:childrenKey];
        [NSUserDefaults.standardUserDefaults synchronize];
    }
}



- (TCChildInfo *)currentChild {
    if (self.children.total > 0) {
        return self.children.items.firstObject;
    } else {
        return nil;
    }
}


- (NSString *)loginName {
    return [FEDeviceManager getDiviceUUIDFromKeyChain];
}

- (void)setAccessToken:(NSString *)acccessToken {
    [NSUserDefaults.standardUserDefaults setValue:acccessToken forKey:accessTokenKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}
- (NSString *)accessToken {
    return [NSUserDefaults.standardUserDefaults objectForKey:accessTokenKey];
}

- (void)setRefreshToken:(NSString *)refreshToken {
    [NSUserDefaults.standardUserDefaults setValue:refreshToken forKey:refreshTokenKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (NSString *)refreshToken {
    return [NSUserDefaults.standardUserDefaults objectForKey:refreshTokenKey];
}

- (void)setTokenExpiresIn:(NSString *)tokenExpiresIn {
    [NSUserDefaults.standardUserDefaults setValue:tokenExpiresIn forKey:tokenExpiresInKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (NSString *)tokenExpiresIn {
    return [NSUserDefaults.standardUserDefaults objectForKey:tokenExpiresInKey];
}

- (void)setCode:(NSString *)code {
    [NSUserDefaults.standardUserDefaults setValue:code forKey:codeKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (NSString *)code {
    return [NSUserDefaults.standardUserDefaults objectForKey:codeKey];
}

-(void)setServerTime:(NSString *)serverTime{
    [[NSUserDefaults standardUserDefaults] setValue:serverTime forKey:serverTimeKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

-(NSString *)serverTime{
    return [[NSUserDefaults standardUserDefaults] objectForKey:serverTimeKey];
}

- (void)setCareerChildExamId:(NSString *)careerChildExamId{
    [NSUserDefaults.standardUserDefaults setValue:careerChildExamId forKey:careerChildExamIdKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (NSString *)careerChildExamId{
    return [NSUserDefaults.standardUserDefaults objectForKey:careerChildExamIdKey];
}
@end
