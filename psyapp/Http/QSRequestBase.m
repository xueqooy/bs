//
//  QSRequestBase.m
//  app
//
//  Created by linjie on 17/3/8.
//  Copyright © 2017年 jeyie0. All rights reserved.
//



#import "QSRequestBase.h"
#import <AFNetworking/AFNetworking.h>
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

#import "UCManager.h"
#import "AppDelegate.h"
#import "HttpErrorManager.h"
#import "QSLoadingView.h"
#import "ConstantConfig.h"
#import "HttpConfig.h"
#import "TCUserDataRestter.h"
@implementation QSRequestBase

+(NSString*) mixRandomCode:(int)count{
    NSString* mix = [NSString new];
    NSString* str = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    for (int i=0; i<count; i++) {
        int x = arc4random() % 62;
        mix = [mix stringByAppendingString:[NSString stringWithFormat:@"%c",[str characterAtIndex:x] ]];
    }
    //return @"ABCabc12";
    return mix;
}


+ (NSString *)hmacsha1:(NSString *)data secret:(NSString *)key {
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    NSString *hash = [HMAC base64EncodedStringWithOptions:0];
    return hash;
}




+(AFHTTPSessionManager *) getAFHTTPSessionManagerWithUrl:(NSString *)url method:(NSString *)method{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
   
    
//    [manager.requestSerializer setValue:API_APP_ID forHTTPHeaderField:@"CHEERSMIND-APPID"];
    
    [manager.requestSerializer setValue:@"agent" forHTTPHeaderField:@"X-IOS"];
    [manager.requestSerializer setValue:@"local" forHTTPHeaderField:@"zh"];
    [manager.requestSerializer setValue:@"version" forHTTPHeaderField:[[UIDevice currentDevice] systemVersion]];
    [manager.requestSerializer setValue:@"device"forHTTPHeaderField:[[UIDevice currentDevice] model]];
    
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    return manager;
}

/**
 *  post方法(无文件)
 *
 *  @param url     url地址
 *  @param params  请求参数:NSDictionary或NSArray类型，无参数时传入nil
 *  @param success 成功回调block(主线程)
 *  @param failure 失败回调block(主线程)
 */
+(void) post:(NSString *) url parameters:(id) params success:(success)success failure:(failure) failure {
    AFHTTPSessionManager *manager = [self getAFHTTPSessionManagerWithUrl:url method:@"POST"];

    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            if ([dic valueForKey:@"flag"] && [[dic valueForKey:@"flag"] intValue] != 0) {
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                
                NSString *message = @"";
                if (![responseObject[@"message"] isKindOfClass:[NSNull class]]) {
                    message = responseObject[@"message"];
                }
                
                if ([@"" isEqualToString:message] && ![responseObject[@"msg"] isKindOfClass:[NSNull class]]) {
                    message = responseObject[@"msg"];
                }
                NSLog(@"POST ERROR ------->message : %@",message?message:@"");
                [userInfo setValue:message forKey:@"message"];
                NSError *err = [NSError errorWithDomain:@"REGISTER ERROR" code:100 userInfo:userInfo];

                
                if (failure) {
                    failure(err);
                }
                return;
            }
        }
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _handleRequestFailed(error, failure, url, params);

    }];
    
   
}


/**
 *  get方法
 *
 *  @param url     url地址
 *  @param success 成功回调block(主线程)
 *  @param failure 失败回调block(主线程)
 */
+(void) get:(NSString *) url success:(success) success failure:(failure) failure {
    //AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [self getAFHTTPSessionManagerWithUrl:url method:@"GET"];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _handleRequestFailed(error, failure, url, nil);

    }];

}


/**
 *  patch方法(无文件)
 *
 *  @param url     url地址
 *  @param params  请求参数:NSDictionary或NSArray类型，无参数时传入nil
 *  @param success 成功回调block(主线程)
 *  @param failure 失败回调block(主线程)
 */
+(void) patch:(NSString *) url parameters:(id) params success:(success)success failure:(failure) failure {
    AFHTTPSessionManager *manager = [self getAFHTTPSessionManagerWithUrl:url method:@"PATCH"];
    [manager PATCH:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            if ([dic valueForKey:@"flag"] && [[dic valueForKey:@"flag"] intValue] != 0) {
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                
                NSString *message = @"";
                if (![responseObject[@"message"] isKindOfClass:[NSNull class]]) {
                    message = responseObject[@"message"];
                }
                
                if ([@"" isEqualToString:message] && ![responseObject[@"msg"] isKindOfClass:[NSNull class]]) {
                    message = responseObject[@"msg"];
                }
                NSLog(@"PATCH ERROR ------->message : %@",message?message:@"");
                [userInfo setValue:message forKey:@"message"];
                NSError *err = [NSError errorWithDomain:@"REGISTER ERROR" code:100 userInfo:userInfo];
                
                
                if (failure) {
                    failure(err);
                }
                return;
            }
        }
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _handleRequestFailed(error, failure, url, params);

    }];
    
   
}

/**
 *  delete方法(无文件)
 *
 *  @param url     url地址
 *  @param params  请求参数:NSDictionary或NSArray类型，无参数时传入nil
 *  @param success 成功回调block(主线程)
 *  @param failure 失败回调block(主线程)
 */
+(void) delete:(NSString *) url parameters:(id) params success:(success)success failure:(failure) failure {
    AFHTTPSessionManager *manager = [self getAFHTTPSessionManagerWithUrl:url method:@"DELETE"];
    [manager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            if ([dic valueForKey:@"flag"] && [[dic valueForKey:@"flag"] intValue] != 0) {
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                
                NSString *message = @"";
                if (![responseObject[@"message"] isKindOfClass:[NSNull class]]) {
                    message = responseObject[@"message"];
                }
                
                if ([@"" isEqualToString:message] && ![responseObject[@"msg"] isKindOfClass:[NSNull class]]) {
                    message = responseObject[@"msg"];
                }
                NSLog(@"DELETE ERROR ------->message : %@",message?message:@"");
                [userInfo setValue:message forKey:@"message"];
                NSError *err = [NSError errorWithDomain:@"REGISTER ERROR" code:100 userInfo:userInfo];
                
                
                if (failure) {
                    failure(err);
                }
                return;
            }
        }
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _handleRequestFailed(error, failure, url, params);

    }];
   
}

/**
 *  patch方法(无文件)
 *
 *  @param url     url地址
 *  @param params  请求参数:NSDictionary或NSArray类型，无参数时传入nil
 *  @param success 成功回调block(主线程)
 *  @param failure 失败回调block(主线程)
 */
+(void) put:(NSString *) url parameters:(id) params success:(success)success failure:(failure) failure {
    AFHTTPSessionManager *manager = [self getAFHTTPSessionManagerWithUrl:url method:@"PUT"];
    [manager PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            if ([dic valueForKey:@"flag"] && [[dic valueForKey:@"flag"] intValue] != 0) {
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                
                NSString *message = @"";
                if (![responseObject[@"message"] isKindOfClass:[NSNull class]]) {
                    message = responseObject[@"message"];
                }
                
                if ([@"" isEqualToString:message] && ![responseObject[@"msg"] isKindOfClass:[NSNull class]]) {
                    message = responseObject[@"msg"];
                }
                NSLog(@"PUT ERROR ------->message : %@",message?message:@"");
                [userInfo setValue:message forKey:@"message"];
                NSError *err = [NSError errorWithDomain:@"REGISTER ERROR" code:100 userInfo:userInfo];
                
                
                if (failure) {
                    failure(err);
                }
                return;
            }
        }
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _handleRequestFailed(error, failure, url, params);
    }];
    
}



//处理用户使用过程token过期，需要弹窗提示重新登录
void checkTokenValidity(NSError *error) {
    NSString *responseCode = [HttpErrorManager getErorInfo:error][@"code"];
    if(![responseCode isKindOfClass:[NSNull class]] &&([responseCode isEqualToString:@"AC_AUTH_INVALID_TOKEN"] || [responseCode isEqualToString:@"AC_AUTH_TOKEN_EXPIRED"]) ){
        //设备账号的token失效
        if (UCManager.sharedInstance.didFormalAccountLogin == NO && UCManager.sharedInstance.isVisitorPattern == NO) {
            [TCUserDataRestter reset3];
            return;
        }
        
        NSLog(@"HTTP ERROR ------->code : %@",responseCode);
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前登录已失效，请重新登录！" preferredStyle:UIAlertControllerStyleAlert];
  
            [TCUserDataRestter reset1];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                     [NSNotificationCenter.defaultCenter postNotificationName:nc_window_root_switch object:WINDOW_ROOT_LOGIN];

                      
                       
            }];
            [alert addAction:okAction];
            [QMUIHelper.visibleViewController presentViewController:alert animated:true completion:nil];
            [QSLoadingView dismiss];
            
        });
    }
}


void _handleRequestFailed(NSError * _Nonnull error, failure failure, NSString *requestedURL, NSDictionary *params) {
    if (error) {
        checkTokenValidity(error);
        NSDictionary *errorResponse = [HttpErrorManager getErorInfo:error];
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
        NSString *message = @"";
        if (![errorResponse[@"message"] isKindOfClass:[NSNull class]]) {
            message = errorResponse[@"message"];
        }
        
        if ([@"" isEqualToString:message] && ![errorResponse[@"msg"] isKindOfClass:[NSNull class]]) {
            message = errorResponse[@"msg"];
        }
        NSLog(@"HTTP ERROR ------->message : %@",message?message:@"");
        [userInfo setValue:message forKey:@"message"];
        NSError *err = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
        
        if (failure) {
            failure(err);
        }
    }
}




@end
