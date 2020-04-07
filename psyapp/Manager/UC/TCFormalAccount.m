//
//  TCFormalAccount.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/26.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCFormalAccount.h"

static NSString * const accessTokenKey = @"_access_token";
static NSString * const refreshTokenKey = @"_refresh_token";
static NSString * const serverTimeKey = @"_server_time";
static NSString * const tokenExpiresInKey = @"_token_expires_in";
static NSString * const codeKey = @"_code";
static NSString * const careerChildExamIdKey = @"_career_child_exam_id";
static NSString * const loginNameKey = @"_login_name";

@implementation TCFormalAccount

- (TCUserInfo *)userInfo {
    if (_userInfo == nil) {
        _userInfo = TCUserInfo.new;
    }
    return _userInfo;
}

- (TCChildrenInfo *)children {
    if (_children == nil) {
        _children = TCChildrenInfo.new;
    }
    return _children;
}

- (TCChildInfo *)currentChild {
    if (self.children.total > 0) {
        return self.children.items.firstObject;
    } else {
        return nil;
    }
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

- (void)setLoginName:(NSString *)loginName {
    [NSUserDefaults.standardUserDefaults setValue:loginName forKey:loginNameKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (NSString *)loginName {
    return [NSUserDefaults.standardUserDefaults objectForKey:loginNameKey];
}
@end
