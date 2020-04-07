//
//  TCCashierManager.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/14.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCOrderModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef enum TCCashierNoticeCode {
    TCCashierNoticeSuccess = 100,
    TCCashierNoticeFailed = 200,
    TCCashierNoticeBalanceNotEnough = 201
}TCCashierNoticeCode;

@interface TCCashierPaymentNotice : NSObject
@property (nonatomic, assign) BOOL result;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, assign) TCCashierNoticeCode code;
@end

@interface TCCashierManager : NSObject
@property (nonatomic, strong, nullable) TCOrderModel *currentProductOrder;
@property (nonatomic, strong, nullable) TCOrderModel *currentEmoneyOrder;

+ (instancetype)sharedInstance;

//paymentType暂时都传3

//使用代币兑换商品
- (void)createProductOrderAndExchangeByProductId:(NSString *)productId price:(CGFloat)price productType:(TCProductType)productType;






//商品由代币来兑换，商品创建订单成功后即代表购买成功，不需要调用支付接口
- (void)purchByProductId:(NSString *)productId appStoreProductId:(NSString * _Nullable)appStoreProductId orderId:(NSNumber *)orderId PaymentType:(TCPaymentType)paymentType onSuccess:(void (^)(void))success failure:(void (^)(void))failure;


//购买代币，创建订单，然后使用苹果内购购买代币
- (void)createEmoneyOrderAndPurchByPaymentType:(TCPaymentType)paymentType productId:(NSString *)productId;
@end

NS_ASSUME_NONNULL_END
