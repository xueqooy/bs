//
//  TCCashierManager.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/14.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCCashierManager.h"
#import "TCHTTPService.h"
#import "TCIAPManager.h"
@implementation TCCashierPaymentNotice
@end

@implementation TCCashierManager
+ (instancetype)sharedInstance {
    static TCCashierManager *instance ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (void)createProductOrderAndExchangeByProductId:(NSString *)productId price:(CGFloat)price productType:(TCProductType)productType {
    _currentProductOrder = nil;
    [QSLoadingView show];
    [TCHTTPService postOrderCreationByPaymentType:price==0?TCPaymentTypeFree:TCPaymentTypeIAP productId:productId productType:productType onSuccess:^(id data) {
        [QSLoadingView dismiss];
        _currentProductOrder = [MTLJSONAdapter modelOfClass:TCOrderModel.class fromJSONDictionary:data error:nil];
        mLog(@"Store-Cashier:商品订单创建%@,",_currentProductOrder? @"成功": @"失败");
        if (_currentProductOrder.needPay.boolValue == YES && [_currentProductOrder.payType isEqualToNumber:@3]) {
            [self postProductExchangeNotificationWithResult:NO productId:productId msg:@"代币余额不足" code:TCCashierNoticeBalanceNotEnough];
            mLog(@"Store-Cashier:代币余额不足");
        } else if (_currentProductOrder.needPay.boolValue == NO) {
            [self postProductExchangeNotificationWithResult:YES productId:productId msg:@"商品兑换成功" code:TCCashierNoticeSuccess];
            mLog(@"Store-Cashier:商品兑换成功");
        } else {
            [self postProductExchangeNotificationWithResult:NO productId:productId msg:@"商品兑换失败，原因未知" code:TCCashierNoticeFailed];
            mLog(@"Store-Cashier:商品兑换失败，原因未知");
        }
      
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error];
        mLog(@"Store-Cashier:商品订单创建请求失败");
        [self postProductExchangeNotificationWithResult:NO productId:productId msg:@"商品订单创建请求失败" code:TCCashierNoticeFailed];
    }];
}




- (void)purchByProductId:(NSString *)productId appStoreProductId:(NSString * _Nullable)appStoreProductId orderId:(nonnull NSNumber *)orderId PaymentType:(TCPaymentType)paymentType onSuccess:(nonnull void (^)(void))success failure:(nonnull void (^)(void))failure {
    if (paymentType == TCPaymentTypeIAP) {
        [QSLoadingView show];
        [TCIAPManager.shareInstance purchWithProductId:appStoreProductId orderId:orderId.stringValue handler:^(TCIAPPurchaseResult type) {
            NSString *msg = @"";
            BOOL result = NO;
            TCCashierNoticeCode code = TCCashierNoticeFailed;
            if (type == TCIAPPurchaseSuccess) {
                msg = @"测点充值成功";
                result = YES;
                code = TCCashierNoticeSuccess;
                if (success) success();
            } else {
                if (type == TCIAPPurchaseFailed) {
                    msg = @"测点充值失败";
                } else if (type == TCIAPPurchaseNoProduct) {
                    msg = @"测点商品不存在";
                } else if (type == TCIAPPurchaseNotAllow) {
                    msg = @"不支持苹果内购";
                } else if (type == TCIAPPurchaseValidateFailed) {
                    msg = @"支付验证失败";
                }
                if (failure) failure();
            }
            [self postEmoneyPurchaseNotificationWithResult:result productId:productId msg:msg code:code];
            [QSLoadingView dismiss];
            if (![NSString isEmptyString:msg]) {
                [QSToast toastWithMessage:msg];
            }

        }];
    }
    
}

- (void)createEmoneyOrderAndPurchByPaymentType:(TCPaymentType)paymentType productId:(NSString *)productId  {
    [QSLoadingView show];
    @weakObj(self);
    [TCHTTPService postEmoneyOrderCreationByPaymentType:paymentType productId:productId onSuccess:^(id data) {
        _currentEmoneyOrder = [MTLJSONAdapter modelOfClass:TCOrderModel.class fromJSONDictionary:data error:nil];
        mLog(@"Store-Cashier:代币订单创建%@,",_currentEmoneyOrder? @"成功": @"失败");

        if (_currentEmoneyOrder) {
            if (_currentEmoneyOrder.needPay.boolValue) {
                NSString *appStoreProductId = productId;
                if(_currentEmoneyOrder.payType.integerValue == TCPaymentTypeIAP) {
                    appStoreProductId = _currentEmoneyOrder.appStoreProductId;
                }
                
                [self purchByProductId:productId appStoreProductId:appStoreProductId orderId:selfweak.currentEmoneyOrder.orderId PaymentType:paymentType onSuccess:^{
                    mLog(@"Store-Cashier:代币购买成功");
                } failure:^{
                    mLog(@"Store-Cashier:代币购买失败");
                }];
                return ;
            } else {
                //不太可能....
                mLog(@"Store-Cashier:无需支付的代币订单");
                [QSLoadingView dismiss];

                [self postEmoneyPurchaseNotificationWithResult:YES productId:productId msg:@"代币购买成功" code:TCCashierNoticeSuccess];
            }
        } else {
            mLog(@"Store-Cashier:代币订单数据为空");
            [QSLoadingView dismiss];

           [self postEmoneyPurchaseNotificationWithResult:NO productId:productId msg:@"代币订单创建异常" code:TCCashierNoticeFailed];
        }
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error];
        mLog(@"Store-Cashier:代币订单创建请求失败");
        [self postEmoneyPurchaseNotificationWithResult:NO productId:productId msg:@"代币订单创建请求失败" code:TCCashierNoticeFailed];

    }];

}

- (void)postProductExchangeNotificationWithResult:(BOOL)result productId:(NSString *)productId msg:(NSString *)msg code:(TCCashierNoticeCode)code{
    TCCashierPaymentNotice *notice = TCCashierPaymentNotice.new;
    notice.result = result;
    notice.productId = productId;
    notice.msg = msg;
    notice.code = code;
    [NSNotificationCenter.defaultCenter postNotificationName:nc_product_exchange_result object:notice];
}

- (void)postEmoneyPurchaseNotificationWithResult:(BOOL)result productId:(NSString *)productId msg:(NSString *)msg code:(TCCashierNoticeCode)code{
    TCCashierPaymentNotice *notice = TCCashierPaymentNotice.new;
    notice.result = result;
    notice.productId = productId;
    notice.msg = msg;
    notice.code = code;
    [NSNotificationCenter.defaultCenter postNotificationName:nc_emoney_purchase_result object:notice];
}
@end
