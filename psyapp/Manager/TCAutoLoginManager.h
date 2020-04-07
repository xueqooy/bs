//
//  TCAutoLoginManager.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/12.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCAutoLoginManager : NSObject
//正式账号自动登录
+ (void)startAutoLoginOnPermit:(void(^)(void))permit prohibition:(void(^)(void))prohibition;

//登录设备账号(当正式账号登录时，设备账号无效),必须在无正式账号登录是调用
+ (void)loginDeviceAccountIfTokenExpiredWithCompletion:(void(^)(void))completion;
@end

NS_ASSUME_NONNULL_END
