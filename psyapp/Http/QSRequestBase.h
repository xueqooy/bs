//
//  QSRequestBase.h
//  app
//
//  Created by linjie on 17/3/8.
//  Copyright © 2017年 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void (^success)(id data);
typedef void (^failure)(NSError *error);

@interface QSRequestBase : NSObject

/**
 *  post方法(无文件)
 *
 *  @param url     url地址
 *  @param params  请求参数:NSDictionary或NSArray类型，无参数时传入nil
 *  @param success 成功回调block(主线程)
 *  @param failure 失败回调block(主线程)
 */
+(void) post:(NSString *) url parameters:(id) params success:(success)success failure:(failure) failure;


/**
 *  get方法
 *
 *  @param url     url地址
 *  @param success 成功回调block(主线程)
 *  @param failure 失败回调block(主线程)
 */
+(void) get:(NSString *) url success:(success) success failure:(failure) failure;

/**
 *  put方法
 *
 *  @param url     url地址
 *  @param params  请求参数:NSDictionary或NSArray类型，无参数时传入nil
 *  @param success 成功回调block(主线程)
 *  @param failure 失败回调block(主线程)
 */
+(void) put:(NSString *) url parameters:(id) params success:(success) success failure:(failure) failure;


/**
 *  patch方法
 *
 *  @param url     url地址
 *  @param params  请求参数:NSDictionary或NSArray类型，无参数时传入nil
 *  @param success 成功回调block(主线程)
 *  @param failure 失败回调block(主线程)
 */
+(void) patch:(NSString *) url parameters:(id) params success:(success) success failure:(failure) failure;

/**
 *  delete方法(无文件)
 *
 *  @param url     url地址
 *  @param params  请求参数:NSDictionary或NSArray类型，无参数时传入nil
 *  @param success 成功回调block(主线程)
 *  @param failure 失败回调block(主线程)
 */
+(void) delete:(NSString *) url parameters:(id) params success:(success)success failure:(failure) failure;

/**
 * post 上传头像
 */
+(void)uploadImage:(UIImage *)image success:(success)success failure:(failure)failure;


@end
