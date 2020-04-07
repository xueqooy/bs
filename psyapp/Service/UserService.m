//
//  UserService.m
//  app
//
//  Created by linjie on 17/3/8.
//  Copyright © 2017年 jeyie0. All rights reserved.
//

#import "UserService.h"
#import "UCManager.h"
#import <CommonCrypto/CommonDigest.h>
#import "FEDeviceManager.h"
#import "RSA.h"
@implementation UserService

+(NSString *)md5Data:(NSData *)sourceData{
    if (!sourceData) {
        return nil;//判断sourceString如果为空则直接返回nil。
    }
    //需要MD5变量并且初始化
    CC_MD5_CTX  md5;
    CC_MD5_Init(&md5);
    //开始加密(第一个参数：对md5变量去地址，要为该变量指向的内存空间计算好数据，第二个参数：需要计算的源数据，第三个参数：源数据的长度)
    CC_MD5_Update(&md5, sourceData.bytes, (CC_LONG)sourceData.length);
    //声明一个无符号的字符数组，用来盛放转换好的数据
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    //将数据放入result数组
    CC_MD5_Final(result, &md5);
    //将result中的字符拼接为OC语言中的字符串，以便我们使用。
    NSMutableString *resultString = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [resultString appendFormat:@"%02x",result[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return  resultString;
}

//+ (NSString*)getMD5WithData:(NSData *)data{
//    const char* original_str = (const char *)[data bytes];
//    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
//    CC_MD5(original_str, (uint)strlen(original_str), digist);
//    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
//    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
//        [outPutStr appendFormat:@"%02X",digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
//    }
//    
//    return [outPutStr lowercaseString];
//}


+ (NSString *)stringByEncryptSaltMD5WithPasswordContent:(NSString *)content {
    if (!content) {
        return nil;
    }
    //content = [NSString stringWithCString:[content UTF8String] encoding:NSUnicodeStringEncoding];
    content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];

    //static const char *salt = "fdjf,jkgfkl";
    
    static const char *salt = "r7_m4@0w,oV9p#Hi";
    static uint8_t bytes[4] = {163, 172, 161, 163};
    NSMutableData *data = [[NSMutableData alloc] init];
    [data appendBytes:[content UTF8String] length:content.length];
    [data appendBytes:&bytes length:sizeof(bytes)];
    [data appendBytes:salt length:strlen(salt)];
    return [self md5Data:data];
}


+ (void) login:(NSString *) loginName password:(NSString *)pwd success:(success)success failure:(failure) failure {
    
//    if (YES) {
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            NSString *pwdMD5;
//            for (int i=0; i<10000000; i++) {
//                NSString *pwdMD5Temp = [self stringByEncryptSaltMD5WithPasswordContent:pwd];
//                NSLog(@"pwdMD5Temp : %@",pwdMD5Temp);
//                if (pwdMD5) {
//                    BOOL isEquals = [pwdMD5 isEqualToString:pwdMD5Temp];
//                    NSAssert(isEquals, @"前后md5不一致"); //第一个参数是条件,如果第一个参数不满足条件,就会记录和打印第二个参数
//                }
//                pwdMD5 = pwdMD5Temp;
//                //[NSThread sleepForTimeInterval:0.001];
//            }
//            
//        });
//        
//        return;
//    }
    
    
    NSString *newPwd = [self stringByEncryptSaltMD5WithPasswordContent:pwd];
    NSDictionary *params = @{@"account":loginName,@"password":newPwd,@"tenant":@"CHEERSMIND"};//cheersmind
    //9306637e484795b90f17edcbb5fc3314  n
    //318ae7d11c8f86a31bf89eec502415e8 y
    //NSLog(@"login params : %@ | pwd :|%@|",params,pwd);
    [QSRequestBase post:URL_LOGIN parameters:params success:^(id data) {
        [UCManager.sharedInstance updateFormalAccountLoginName:loginName];
        [UCManager.sharedInstance updateFormalAccountTokenDictionary:data];
        if (success) {
            success(data);
        }
    } failure:failure];
}

+ (void)loginThird:(NSString *)openId platSource:(NSString *)platSource thirdAccessToken:(NSString *)thirdAccessToken orgName:(NSString *)orgName success:(success)success failure:(failure)failure{
    
    NSDictionary *params = @{@"open_id":openId,@"plat_source":platSource,@"third_access_token":thirdAccessToken,@"tenant":@"CHEERSMIND"};//cheersmind

    [QSRequestBase post:URL_LOGIN_THIRD parameters:params success:^(id data) {
        [UCManager.sharedInstance updateFormalAccountTokenDictionary:data];
        if (success) {
            success(data);
        }
    } failure:failure];

}

+ (void)thirdRegister:(NSString *)openId platSource:(NSString *)platSource thirdAccessToken:(NSString *)thirdAccessToken realName:(NSString *)realName birthday:(NSString *)birthday groupNo:(NSString *)groupNo sex:(NSString *)sex success:(success)success failure:(failure)failure{
    
    NSDictionary *params = @{@"open_id":openId,@"plat_source":platSource,@"third_access_token":thirdAccessToken,@"real_name":realName,@"birthday":birthday,@"group_no":groupNo,@"sex":sex};
    [QSRequestBase post:URL_REGISTER_THIRD parameters:params success:^(id data) {
//        NSDictionary *userDic = data;
        [UCManager.sharedInstance updateFormalAccountTokenDictionary:data];
//        UCManager *manager = [UCManager sharedInstance];
//        manager.userId = [[userDic valueForKey:@"user_id"] longLongValue];
//        manager.code = [userDic valueForKey:@"code"];
//        manager.refreshToken = [userDic valueForKey:@"refresh_token"];
//        manager.acccessToken = [userDic valueForKey:@"access_token"];
        if (success) {
            success(data);
        }
    } failure:failure];
    
}

+ (void) validInviteCode:(NSString *) inviteCode success:(success)success failure:(failure) failure {
    //NSString *url = URL_VALID_INVITE_CODE;
    //url = [url stringByReplacingOccurrencesOfString:@"{invite_code}" withString:inviteCode];
    //[QSRequestBase get:url success:^(id data) {
    //    NSDictionary *respDic = data;
    //    //NSDictionary *sucDic = respDic[@"data"];
    //    int flag = [respDic[@"flag"] intValue];
    //    if (success) {
    //        success(flag==0?@(YES):@(NO));
    //    }
    //} failure:failure];
    
    
    NSDictionary *params = @{@"invite_code":inviteCode};
    [QSRequestBase post:URL_VALID_INVITE_CODE parameters:params success:^(id data) {
        if (success) {
            NSDictionary *respDic = (NSDictionary *)data;
            BOOL result = [[respDic valueForKey:@"result"] boolValue];
            success(@(result));
        }
    } failure:failure];

}
+ (void) inviteRegister:(NSString *)inviteCode account:(NSString *)account password:(NSString *)pwd orgCode:(NSString *) orgCode success:(success)success failure:(failure) failure {
    NSDictionary *params = @{@"invite_code":inviteCode,@"username":account,@"password":pwd,@"org_code":orgCode};
    [QSRequestBase post:URL_REGISTER parameters:params success:^(id data) {
        NSDictionary *respDic = data;
        NSDictionary *sucDic = respDic[@"data"];
        if (success) {
            success(sucDic);
        }
    } failure:failure];
}

+ (void) userInfoWithSuccess:(success)success failure:(failure) failur {
    //NSString *url = [URL_USER_INFO stringByReplacingOccurrencesOfString:@"{user_id}" withString:[NSString stringWithFormat:@"%llu",userId]];
    
    [QSRequestBase get:URL_USER_INFO success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failur];
}
//废弃
+ (void) childList:(UInt64) userId success:(success)success failure:(failure) failure {

    
    [QSRequestBase get:URL_CHILD_LIST success:success failure:failure];
}



//+ (void) childInfo:(UInt64) childId success:(success)success failure:(failure) failure {
//
//    for (NSDictionary *itemDic in [UCManager sharedInstance].children.itm) {
//        if ([itemDic[@"id"] intValue] == childId) {
//            if (success) {
//                success(itemDic);
//            }
//            return;
//        }
//    }
//    if (failure) {
//        failure(nil);
//    }
//
//    NSString *url = [URL_CHILD_LIST stringByReplacingOccurrencesOfString:@"{user_id}" withString:[NSString stringWithFormat:@"%llu",[UCManager sharedInstance].userId]];
//    
//    [QSRequestBase get:url success:^(id data) {
//        if (success) {
//            NSDictionary *respDic = data;
//            NSArray *childArray = respDic[@"data"][@"items"];
//            for (NSDictionary *itemDic in childArray) {
//                if ([itemDic[@"id"] intValue] == childId) {
//                   success(itemDic);
//                }
//            }
//            
//        }
//    } failure:failure];
//}

+ (void) getServerTimer:(success)success failure:(failure)failure{
    [QSRequestBase get:URL_SERVER_TIME success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//+ (NSString *)getNowTimeTimestamp{
//
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//
//    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"];
//
//    //设置时区,这个对于时间的处理有时很重要
//
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//
//    [formatter setTimeZone:timeZone];
//
//    NSDate *datenow = [NSDate date];
//
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
//
//    return timeSp;
//
//}


//-----------奇思火眼相关--------
//登录
+ (void)userLogin:(NSString *)loginName password:(NSString *)pwd sessionId:(NSString *)sessionId verificationCode:(NSString *)verificationCode success:(success)success failure:(failure)failure{
    NSString *newPwd = [self stringByEncryptSaltMD5WithPasswordContent:pwd];
    NSDictionary *params = @{
                             @"account":loginName,
                             @"password":newPwd,
                             @"session_id":sessionId,
                             @"tenant":@"CHEERSGENIE",
                             @"device_type":@"ios",
                             @"device_desc":[FEDeviceManager getDeviceModelName],
                             @"device_id":[FEDeviceManager getDiviceUUID],
                             @"verification_code":verificationCode
                             };
 
    NSString *url = FE_URL_USER_LOGIN;
    [QSRequestBase post:url parameters:params success:^(id data) {
        [UCManager.sharedInstance updateFormalAccountLoginName:loginName];
        [UCManager.sharedInstance updateFormalAccountTokenDictionary:data];

        if (success) {
            success(data);
        }
    } failure:failure];
}
//第三方登录
+(void)userLoginThird:(NSString *)openId appId:(NSString *)appId platSource:(NSString *)platSource thirdAccessToken:(NSString *)thirdAccessToken orgName:(NSString *)orgName  success:(success)success failure:(failure)failure{
    
    NSMutableDictionary *params = @{
                             @"open_id":openId,
                             @"plat_source":platSource,
                             @"third_access_token":thirdAccessToken,
                             @"tenant":orgName,
                             @"device_type":@"ios",
                             @"device_desc":[FEDeviceManager getDeviceModelName],
                             @"device_id":[FEDeviceManager getDiviceUUID]
                             }.mutableCopy;
    if (![NSString isEmptyString:appId]) {
        [params setObject:appId forKey:@"app_id"];
    }
    NSString *url = FE_URL_LOGIN_THIRD;
    [QSRequestBase post:url parameters:params success:^(id data) {
        [UCManager.sharedInstance updateFormalAccountTokenDictionary:data];
        
        if (success) {
            success(data);
        }
    } failure:failure];
    
}
//第三方绑定
+(void)userThirdBinding:(NSString *)openId platSource:(NSString *)platSource thirdAccessToken:(NSString *)thirdAccessToken appId:(NSString *)appId success:(success)success failure:(failure)failure{
    NSDictionary *params = @{
                             @"open_id":openId,
                             @"plat_source":platSource,
                             @"third_access_token":thirdAccessToken,
                             @"app_id":appId,
                             @"tenant":@"CHEERSMIND"
                             };
    NSString *url = FE_URL_THIRD_BINDING;
    [QSRequestBase post:url parameters:params success:^(id data) {
        
        if (success) {
            success(data);
        }
    } failure:failure];
}
//已存在第三方账号绑定手机号
+(void)thirdBindingPhone:(NSString *)mobile mobileCode:(NSString *)mobileCode sessionId:(NSString *)sessionId success:(success)success failure:(failure)failure{
    NSDictionary *params = @{
                             @"mobile":mobile,
                             @"mobile_code":mobileCode,
                             @"tenant":@"CHEERSMIND",
                             @"area_code":@"+86",
                             @"device_type":@"ios",
                             @"device_desc":[FEDeviceManager getDeviceModelName],
                             @"device_id":[FEDeviceManager getDiviceUUID],
                             @"session_id":sessionId
                             };
    NSString *url = FE_URL_MOBILE_BINDING;
    [QSRequestBase put:url parameters:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//手机验证码登录
+(void)userLoginMobile:(NSString *)mobileNum mobileCode:(NSString *)mobileCode sessionId:(NSString *)sessionId success:(success)success failure:(failure)failure{
    NSDictionary *params = @{
                             @"mobile":mobileNum,
                             @"mobile_code":mobileCode,
                             @"tenant":@"CHEERSMIND",
                             @"device_type":@"ios",
                             @"device_desc":[FEDeviceManager getDeviceModelName],
                             @"device_id":[FEDeviceManager getDiviceUUID],
                             @"session_id":sessionId
                             };
    
    NSString *url = FE_URL_PHONE_SMS_LOGIN;
    [QSRequestBase post:url parameters:params success:^(id data) {
        [UCManager.sharedInstance updateFormalAccountTokenDictionary:data];
        
        if (success) {
            success(data);
        }
    } failure:failure];
}
//手机短信注册（第三方首次登录绑定手机需要传后面三个参数）
+(void)mobileRegister:(NSString *)mobileNum mobileCode:(NSString *)mobileCode password:(NSString *)password openId:(NSString *)openId platSource:(NSString *)platSource thirdAccessToken:(NSString *)thirdAccessToken appId:(NSString *)appId sessionId:(NSString *)sessionId success:(success)success failure:(failure)failure{
  
    NSDictionary *params = @{
                             @"mobile":mobileNum?mobileNum:@"",
                             @"mobile_code":mobileCode?mobileCode: @"",
                             @"password":[self stringByEncryptSaltMD5WithPasswordContent:password],
                             @"open_id":openId?openId:@"",
                             @"plat_source":platSource?platSource:@"",
                             @"third_access_token":thirdAccessToken?thirdAccessToken:@"",
                             @"tenant":@"CHEERSMIND",
                             @"app_id":appId?appId:@"",
                             @"session_id":sessionId?sessionId:@""
                             };
    
    NSString *url = FE_URL_PHONE_SMS_REGISTER;
    [QSRequestBase post:url parameters:params success:^(id data) {
        
//        [UCManager.sharedInstance updateFormalAccountTokenDictionary:data];
        
        if (success) {
            success(data);
        }
    } failure:failure];
}
//退出登录
+(void)userLoginExit:(NSString *)accessToken success:(success)success failure:(failure)failure{
    NSString *url = FE_URL_EXIT_LOGIN;
    url = [url stringByReplacingOccurrencesOfString:@"{access_token}" withString:accessToken];
    [QSRequestBase delete:url parameters:nil success:^(id data) {
                if (success) {
            success(data);
        }
    } failure:failure];
}
//获取用户绑定的第三方平台列表
+(void)getUserLoginThirds:(success)success failure:(failure)failure{
    NSString *url = FE_URL_USER_THIRDS;
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}
//修改密码
+(void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword success:(success)success failure:(failure)failure{
    NSDictionary *params = @{
                             @"old_password":[self stringByEncryptSaltMD5WithPasswordContent:oldPassword],
                             @"new_password":[self stringByEncryptSaltMD5WithPasswordContent:newPassword]
                             };
    
    NSString *url = FE_URL_CHANGE_PASSWORD;
    [QSRequestBase patch:url parameters:params success:^(id data) {
        [UCManager.sharedInstance updateFormalAccountTokenDictionary:data];

        if (success) {
            success(data);
        }
    } failure:failure];
}

//发送短信验证码
+(void)sendSms:(NSString *)mobileNum sessionId:(NSString *)sessionId verificationCode:(NSString *)verificationCode type:(NSInteger)type tenant:(NSString *)tenant areaCode:(NSString *)areaCode success:(success)success failure:(failure)failure{
    
    NSDictionary *params = @{
                             @"mobile":mobileNum,
                             @"type":[NSString stringWithFormat:@"%li",type],
                             @"tenant":@"CHEERSMIND",
                             @"area_code":areaCode,
                             @"session_id":sessionId,
                             @"verification_code" :  verificationCode
                             };
    
    NSString *url = FE_URL_SEND_SMS;
    [QSRequestBase post:url parameters:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}
//创建会话
+(void)createSessions:(NSInteger)sessionType success:(success)success failure:(failure)failure;{
    
//    "session_type":"int",   //会话类型，0：注册(手机)，1：登录(帐号、密码登录)，2：手机找回密码，3：登录(短信登录)，4:下发短信验证码
    NSDictionary *params = @{
                             @"session_type":[NSString stringWithFormat:@"%li",sessionType],
                             @"device_id":[FEDeviceManager getDiviceUUID],
                             @"tenant":@"CHEERSGENIE"
                             };
    NSString *url = FE_URL_SEND_SESSIONS;
    [QSRequestBase post:url parameters:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}
//获取图片验证码
+(void)getVerificationCode:(NSString *)sessionId success:(success)success failure:(failure)failure{
    NSString *url = FE_URL_GET_IMAGE;
    url = [url stringByReplacingOccurrencesOfString:@"{session_id}" withString:sessionId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+(void)verifyVerificationCodeWithSessionId:(NSString *)sessionId verificationCode:(NSString *)verificationCode success:(success)success failure:(failure)failure {
    NSString *url = @"/accounts/sessions/{session_id}/verification_code/actions/valid";
    url = [url stringByReplacingOccurrencesOfString:@"{session_id}" withString:sessionId];
    NSDictionary *params = @{
                             @"verification_code":verificationCode,
                             };
    [QSRequestBase post:url parameters:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//手机找回密码
+(void)mobileSetPassword:(NSString *)mobile mobileCode:(NSString *)mobileCode password:(NSString *)password sessionId:(NSString *)sessionId  success:(success)success failure:(failure)failure{
    
    NSDictionary *params = @{
                             @"mobile":mobile,
                             @"mobile_code":mobileCode,
                             @"tenant":@"CHEERSMIND",
                             @"new_password":[self stringByEncryptSaltMD5WithPasswordContent:password],
                             @"area_code":@"+86",
                             @"session_id":sessionId
                             };
    
    NSString *url = FE_URL_MOBILE_RESET_PASS;
    [QSRequestBase patch:url parameters:params success:^(id data) {
        [UCManager.sharedInstance updateFormalAccountTokenDictionary:data];
        
        if (success) {
            success(data);
        }
    } failure:failure];
}

+(void)userSignIn:(success)success failure:(failure)failure{
    NSString *url = FE_URL_SIGN_IN;
    [QSRequestBase post:url parameters:nil success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+(void)userSignInStage:(success)success failure:(failure)failure{
    NSString *url = FE_URL_SIGN_IN_STATE;
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+(void)userScoreList:(NSInteger)page size:(NSInteger)size success:(success)success failure:(failure) failure{
    NSString *url = FE_URL_SCORE_NUM_LIST;
    url = [url stringByReplacingOccurrencesOfString:@"{page}" withString:[NSString stringWithFormat:@"%li",page]];
    url = [url stringByReplacingOccurrencesOfString:@"{size}" withString:[NSString stringWithFormat:@"%li",size]];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+(void)userScoreAll:(success)success failure:(failure)failure{
    NSString *url = FE_URL_ALL_SCORES;
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+(void)userMessages:(NSInteger)page size:(NSInteger)size success:(success)success failure:(failure)failure{
    NSString *url = FE_URL_USER_MESSAGES;
    url = [url stringByReplacingOccurrencesOfString:@"{page}" withString:[NSString stringWithFormat:@"%li",page]];
    url = [url stringByReplacingOccurrencesOfString:@"{size}" withString:[NSString stringWithFormat:@"%li",size]];
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:UCManager.sharedInstance.currentChild.childId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+(void)userReadMessage:(NSString *)messageId success:(success)success failure:(failure)failure{
    NSString *url = FE_URL_READ_MESSAGE;
    url = [url stringByReplacingOccurrencesOfString:@"{message_id}" withString:messageId];
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:UCManager.sharedInstance.currentChild.childId];
    [QSRequestBase put:url parameters:nil success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+(void)userDeleteMessage:(NSString *)messageId success:(success)success failure:(failure)failure{
    NSString *url = FE_URL_DELETE_MESSAGE;
    url = [url stringByReplacingOccurrencesOfString:@"{message_id}" withString:messageId];
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:UCManager.sharedInstance.currentChild.childId];
    [QSRequestBase delete:url parameters:nil success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+(void)userUnlookMessages:(success)success failure:(failure)failure{
    NSString *url = FE_URL_UNLOOK_MESSAGES;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:UCManager.sharedInstance.currentChild.childId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+ (void)getUserMobile:(success)success failure:(failure)failure{
    NSString *url = FE_URL_USER_MOBILE;
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+ (void)uploadHeadImage:(UIImage *)image success:(success)success failure:(failure)failure{
    
    
    [QSRequestBase uploadImage:image success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if(failure){
            failure(error);
        }
    }];
}

+ (void)addChildInfoByChildName:(NSString *)childName nickname:(NSString *)nickname sex:(NSString *)sex gradeNum:(NSString *)gradeNum birthday:(NSString *)birthday success:(success)success failure:(failure)failure {
    NSDictionary *params = @{@"child_name" : childName,
                             @"nick_name" : nickname,
                             @"sex" : sex,
                             @"grade" : gradeNum,
                             @"birthday" : birthday,
    };
    NSString *url = FE_URL_CHILD_LIST;
    [QSRequestBase post:url parameters:params success:success failure:failure];
}

+(void)userInfoModify:(NSString *)nickName success:(success)success failure:(failure) failure{
    
    NSDictionary *params = @{
                             @"nick_name":nickName
                             };
    
    NSString *url = FE_URL_USER_MODIFY;
    [QSRequestBase patch:url parameters:params success:^(id data) {        
        if (success) {
            success(data);
        }
    } failure:failure];
}

+ (void)getUserInfoWithSuccess:(success)success failure:(failure)failure{
    NSString *url = FE_URL_USER_INFO;
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            
            success(data);
        }
    } failure:failure];
}

+ (void)getChildList:(UInt64)userId success:(success)success failure:(failure)failure{
    NSString *url = FE_URL_CHILD_LIST;
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//+(void)getClassGroupInfo:(NSString *)groupNum success:(success)success failure:(failure)failure{
//    NSString *url = FE_INVITATION_CODE_CHECK;
//    url = [url stringByReplacingOccurrencesOfString:@"{invitation_code}" withString:groupNum];
//    [QSRequestBase get:url success:^(id data) {
//        if (success) {
//            success(data);
//        }
//    } failure:failure];
//}

+(void)perfectUserInfo:(NSString *)groupNum sex:(NSNumber *)sex name:(NSString *)name birthday:(NSString *)birthday parentRole:(NSString *)parentRole nickName:(NSString *)nickName grade:(NSNumber *)grade success:(success)success failure:(failure)failure{
    
    NSMutableDictionary *params = @{
                             @"invitation_code":groupNum,
                             @"sex":sex,
                             @"real_name":name,
                             @"birthday":birthday,
                             @"nick_name":nickName
                             }.mutableCopy;
  
    if (grade !=nil) {
        [params setValue:[NSString stringWithFormat:@"%@", grade] forKey:@"grade"];
    }
    if (parentRole != nil) {
        [params setValue:[NSString stringWithFormat:@"%@", parentRole] forKey:@"parent_role"];
    }

     NSString *url = FE_PERFECT_USER_INFO;
    [QSRequestBase post:url parameters:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//查看用户手机号是否注册
+(void)mobileIsRegister:(NSString *)mobile success:(success)success failure:(failure)failure{
    NSString *url = FE_URL_MOBILE_IS_REGISTER;
    url = [url stringByReplacingOccurrencesOfString:@"{mobile}" withString:mobile];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//+ (void)getInterfacePermissionsWithSchoolID:(NSString *)schoolID childID:(NSString *)childID success:(success)success failure:(failure)failure{
//    NSString *url = [UGTool replacingStrings:@[@"{school_id}", @"{child_id}"] withObj:@[schoolID, childID] forURL:FE_URL_USER_INTERFACE_PERMISSION];
//    [QSRequestBase get:url success:^(id data) {
//        if (success) {
//            success(data);
//        }
//    } failure:failure];
//}




+ (void)getRSAPublicKeyOfEncryptedUUIDOnSuccess:(success)success failure:(failure)failure {
    NSString *URLString = TC_URL_GET_UUID_RSA_PUBLIC_KEY;
    [QSRequestBase get:URLString success:success failure:failure];
}

+ (void)postEncryptedUUID:(NSString *)uuid registerCheckOnSuccess:(success)success failure:(failure)failure {
    NSString *URLString = TC_URL_POST_UUID_REGISTER_CHECK;
    NSDictionary *param = @{
        @"uuid" : uuid
    };
    [QSRequestBase post:URLString parameters:param success:success failure:failure];
}

+ (void)postEncryptedUUID:(NSString *)uuid registerOnSuccess:(success)success failure:(failure)failure {
    NSString *URLString = TC_URL_POST_UUID_REGISTER;
    NSDictionary *param = @{
        @"uuid" : uuid
    };
    [QSRequestBase post:URLString parameters:param success:success failure:failure];
}


+ (void)postPerfectDeviceAccountInfoByGender:(NSNumber *)gender grade:(NSNumber *)grade onSuccess:(success)success failure:(failure)failure {
    NSString *URLString = TC_URL_POST_DEVICE_ACCOUNT_INFO_PERFECTION;
    NSDictionary *param = @{
        @"sex" : gender.stringValue,
        @"grade" : grade.stringValue
    };
    [QSRequestBase post:URLString parameters:param success:success failure:failure];
}

+ (void)postTokenRefreshWithToken:(NSString *)refreshToken onSuccess:(success)success failure:(failure)failure {
    NSString *URLString = [UGTool replacingStrings:@[@"{refresh_token}"] withObj:@[refreshToken] forURL:TC_URL_POST_TOKEN_REFRESH];
    [QSRequestBase post:URLString parameters:nil success:success failure:failure];
}

+ (void)postDeviceAccountLoginByUUID:(NSString *)uuid encryptedUUID:(NSString *)encrypted onSuccess:(success)success failure:(failure)failure {
    NSString *URLString = TC_URL_POST_DEVICE_ACCOUNT_LOGIN;
    NSDictionary *params = @{
        @"uuid" : encrypted,
        @"tenant" : @"CHEERSGENIE",
        @"device_id" : uuid
    };
    
    [QSRequestBase post:URLString parameters:params success:success failure:failure];
}

+ (void)postAccountRegisterByAccount:(NSString *)account password:(NSString *)password onSuccess:(success)success failure:(failure)failure {
    NSString *URLString = PA_URL_POST_ACCOUNT_REGISTER;
    NSDictionary *params = @{
        @"login_name" : account,
        @"password" : password,
    };
    
    [QSRequestBase post:URLString parameters:params success:success failure:failure];
}
@end
