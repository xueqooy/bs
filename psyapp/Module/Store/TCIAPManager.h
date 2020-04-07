//
//  TCIAPManager.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/16.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    TCIAPPurchaseSuccess = 0,       // 购买成功
    TCIAPPurchaseFailed = 1,        // 购买失败
    TCIAPPurchaseValidateFailed = 2,// 验证失败
    TCIAPPurchaseCancle = 3,        // 取消购买
    TCIAPPurchaseNotAllow = 4,      // 不允许内购
    TCIAPPurchaseNoProduct = 5,     // 没有商品
}TCIAPPurchaseResult;

typedef void (^TCIAPHandler)(TCIAPPurchaseResult type);


@interface TCIAPManager : NSObject
+ (instancetype)shareInstance;

- (void)start;
- (void)stop;

- (void)purchWithProductId:(NSString *)productId orderId:(NSString *)orderId handler:(TCIAPHandler)handler;
@end

NS_ASSUME_NONNULL_END
