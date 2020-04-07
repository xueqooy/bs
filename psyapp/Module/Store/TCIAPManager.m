//
//  TCIAPManager.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/16.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCIAPManager.h"
#import "TCHTTPService.h"
#import "TCOrderModel.h"
#import "NSDate+Utils.h"
#import "TCSandBoxHelper.h"
#import <StoreKit/StoreKit.h>
@interface TCIAPManager () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

@implementation TCIAPManager {
    NSString *_productId;
    NSString *_orderId;
    NSString *_receipt;
    SKPaymentTransaction *_transaction;
    TCIAPHandler _handler;
    
}
+ (instancetype)shareInstance {
    static TCIAPManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self shareInstance];
}

- (void)start {
    [SKPaymentQueue.defaultQueue addTransactionObserver:self];
    //检查是否有未处理的凭证，有的话，进行验证
    [self checkIAPFilesAndValidate];
}

- (void)stop{
    [SKPaymentQueue.defaultQueue removeTransactionObserver:self];
}



- (void)purchWithProductId:(NSString *)productId orderId:(nonnull NSString *)orderId handler:(nonnull TCIAPHandler)handler  {
    if (![NSString isEmptyString:productId] && ![NSString isEmptyString:orderId]) {
        _handler = handler;
        //开始购买服务
        if (SKPaymentQueue.canMakePayments) {
            _productId = productId;
            _orderId = orderId;
            NSSet *set = [NSSet setWithObject:_productId];
            //请求商品
            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
            request.delegate = self;
            [request start];
            mLog(@"Store-IAP:开始请求商品");
        } else {
            [self handleActionWithType:TCIAPPurchaseNotAllow];
        }
    } else {
        [self handleActionWithType:TCIAPPurchaseFailed];

        mLog(@"Store-IAP:商品ID或订单ID为空");
    }
}

- (void)handleActionWithType:(TCIAPPurchaseResult)type{
#if DEBUG
    switch (type) {
        case TCIAPPurchaseSuccess:
            NSLog(@"Store-IAP:购买成功");
            break;
        case TCIAPPurchaseFailed:
            NSLog(@"Store-IAP:购买失败");
            break;
        case TCIAPPurchaseValidateFailed:
            NSLog(@"Store-IAP:验证失败");
            break;
        case TCIAPPurchaseCancle:
            NSLog(@"Store-IAP:用户取消购买");
            break;
        case TCIAPPurchaseNotAllow:
            NSLog(@"Store-IAP:不允许苹果内购");
            break;
        case TCIAPPurchaseNoProduct:
            NSLog(@"Store-IAP:没有商品");
            break;

        default:
            break;
    }
#endif
    
    if (_handler) {
        GCD_ASYNC_MAIN(^{
            _handler(type);
            _handler = nil;
        })
        
    }
}


#pragma mark - RequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *products = response.products;
    
    if (products.count <= 0) {
        [self handleActionWithType:TCIAPPurchaseNoProduct];
        return;
    }
    //核对商品
    SKProduct *targetProduct;
    for (SKProduct *product in products) {
        if ([product.productIdentifier isEqualToString:_productId]) {
            targetProduct = product;
            break;
        }
    }
    mLog(@"----------Store-IAP----------")
    mLog(@"Store-IAP：productID:%@", response.invalidProductIdentifiers);
    mLog(@"Store-IAP：产品付费数量:%lu",(unsigned long)[products count]);
    mLog(@"Store-IAP：%@",[targetProduct description]);
    mLog(@"Store-IAP：%@",[targetProduct localizedTitle]);
    mLog(@"Store-IAP：%@",[targetProduct localizedDescription]);
    mLog(@"Store-IAP：%@",[targetProduct price]);
    mLog(@"Store-IAP：%@",[targetProduct productIdentifier]);
    mLog(@"Store-IAP：发送购买请求");
    mLog(@"-----------Store-IAP------------")
    SKPayment *payment = [SKPayment paymentWithProduct:targetProduct];
    [SKPaymentQueue.defaultQueue addPayment:payment];
}

- (void)requestDidFinish:(SKRequest *)request {
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    mLog(@"Store-IAP:商品请求失败:%@", error.localizedDescription);
    [self handleActionWithType:TCIAPPurchaseNoProduct];
}

#pragma mark - ObserverDelegate
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                mLog(@"Store-IAP:正在支付");
                //保存可能会发生丢单的OrderId,便于下次事务恢复是读取
                [NSUserDefaults.standardUserDefaults setObject:_orderId forKey:transaction.payment.productIdentifier];
                [NSUserDefaults.standardUserDefaults synchronize];
                break;
                
            case SKPaymentTransactionStatePurchased:
                mLog(@"Store-IAP:订单已支付");
                _transaction = transaction;
                [self getReceipt];
                [self saveReceipt];
                [self checkIAPFilesAndValidate];
                [self completeTransaction:transaction];

                break;

            case SKPaymentTransactionStateRestored:
                mLog(@"Store-IAP:商品重复购买");
                [self restoreTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            
            default:
                break;
        }
    }
}


#pragma mark - Private

- (void)getReceipt {
    NSData *receiptData = [NSData dataWithContentsOfURL:[NSBundle.mainBundle appStoreReceiptURL]];
    _receipt = [receiptData base64EncodedStringWithOptions:0];
    mLog(@"Store-IAP:获取支付凭证");
}

static NSString *const receiptKey = @"iap_receipt";
static NSString *const orderIdKey = @"iap_orderId";
static NSString *const transactionIdKey = @"iap_transactionId";
static NSString *const dateKey = @"iap_date";
static NSString *const userIdKey = @"iap_userId";

- (void)saveReceipt {
    //1.正常支付过程中，保存订单数据，此时的orderId不会为空，一旦存入本地，丢单可能性较小
    //2.支付过程中，用户输入密码后，未等待事务返回purchased（即未将订单数据存入本地），关闭了App，此时等待下一次进入App，事务恢复时，如果没有orderId，导致无法验证订单，发生丢单，故需要实现保存OrderId
    if ([NSString isEmptyString:_orderId]) {
        mLog(@"Store-IAP:事务恢复,订单ID为空,从本地读取");
        NSString *orderId = [NSUserDefaults.standardUserDefaults objectForKey:_transaction.payment.productIdentifier];
        if (![NSString isEmptyString:orderId]) {
            _orderId = orderId;
            [NSUserDefaults.standardUserDefaults removeObjectForKey:_transaction.payment.productIdentifier];
             mLog(@"Store-IAP:找到匹配的本地订单ID");
        } else {
            mLog(@"Store-IAP:未找到匹配的本地订单ID");
            return;
        };
    }
    NSString *date = [[NSDate date] formattedDateDescription];
    NSString *fileName = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSString *userId = [NSString stringWithFormat:@"%li", (long)UCManager.sharedInstance.userInfo.userId.integerValue];
    NSString *orderId = _orderId;
    NSString *savePath = [NSString stringWithFormat:@"%@/%@.plist", TCSandBoxHelper.iapReceiptFilePath, fileName];
    NSDictionary *dic = @{
        userIdKey : userId,
        dateKey   : date,
        orderIdKey: orderId,
        receiptKey: _receipt,
        transactionIdKey : _transaction.transactionIdentifier
    };
    BOOL result = [dic writeToFile:savePath atomically:YES];
    mLog(@"Store-IAP:凭证写入文件%@", result? @"成功" : @"失败");
}

- (void)checkIAPFilesAndValidate {
    NSFileManager *fileManager =NSFileManager.defaultManager;
    NSError *error = nil;
    NSArray *cacheFileNameArray = [fileManager contentsOfDirectoryAtPath:TCSandBoxHelper.iapReceiptFilePath error:&error];
    if (error == nil) {
        for (NSString *name in cacheFileNameArray) {
            if ([name hasSuffix:@".plist"]) { //存储凭证的文件
                NSString *filePath = [NSString stringWithFormat:@"%@/%@", TCSandBoxHelper.iapReceiptFilePath, name];
                [self validateReceiptWithFilePathOfPlist:filePath];
                mLog(@"Store-IAP:开始验证支付凭证");
                return;
            }
        }
    }
    mLog(@"Store-IAP:未能在本地找到支付凭证");
}

- (void)validateReceiptWithFilePathOfPlist:(NSString *)filePath {
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSString *orderId = dic[orderIdKey];
    NSString *transactionId = dic[transactionIdKey];
    NSString *receipt = dic[receiptKey];
    
    
    NSNumber *revalidateCount = @2;
 
    [TCHTTPService postValidateIAPReceiptByOrderId:orderId transactionId:transactionId receiptData:receipt onSuccess:^(id data) {
        TCIAPOrderValidationResultModel *result = [MTLJSONAdapter modelOfClass:TCIAPOrderValidationResultModel.class fromJSONDictionary:data error:nil];
        if ([result.appleTradeNo isEqualToString:transactionId]) {
            if (result.orderResult.boolValue) {
                mLog(@"Store-IAP:凭证验证通过");
                [self removeReceipt];
                [self handleActionWithType:TCIAPPurchaseSuccess ];

            } else if (!result.orderResult.boolValue && [result.orderResultCode isEqualToNumber:@(1210)]){
                //重复请求
                mLog(@"Store-IAP:凭证验证通过");
                [self removeReceipt];
                [self handleActionWithType:TCIAPPurchaseSuccess ];

            } else if (!result.orderResult.boolValue && [result.orderResultCode isEqualToNumber:@(1211)]) {
                mLog(@"Store-IAP:凭证验证不通过,苹果产品ID不匹配");
                [self revalidateWithOrderId:orderId transactionId:transactionId receipt:receipt count:revalidateCount];
    
            } else if (result.orderResult.boolValue && [result.orderResultCode isEqualToNumber:@(1212)]) {
                mLog(@"Store-IAP:凭证验证不通过,苹果产品ID已使用");
                [self revalidateWithOrderId:orderId transactionId:transactionId receipt:receipt count:revalidateCount];
            } else {
                mLog(@"Store-IAP:凭证验证不通过");
                [self revalidateWithOrderId:orderId transactionId:transactionId receipt:receipt count:revalidateCount];
            }
        } else {
            mLog(@"Store-IAP:验证返回的transaction_id不匹配");
            [self revalidateWithOrderId:orderId transactionId:transactionId receipt:receipt count:revalidateCount];
        }
        
    } failure:^(NSError *error) {
        mLog(@"Store-IAP:请求验证接口失败");
        [self revalidateWithOrderId:orderId transactionId:transactionId receipt:receipt count:revalidateCount];
    }];
}

- (void)revalidateWithOrderId:(NSString *)orderId transactionId:(NSString *)transactionId receipt:(NSString *)receipt count:(NSNumber *)count {
    __block NSNumber *revalidateCount = count;
    mLog(@"Store-IAP:再次验证--%li",2 - revalidateCount.integerValue);

    [TCHTTPService postValidateIAPReceiptByOrderId:orderId transactionId:transactionId receiptData:receipt onSuccess:^(id data) {
        TCIAPOrderValidationResultModel *result = [MTLJSONAdapter modelOfClass:TCIAPOrderValidationResultModel.class fromJSONDictionary:data error:nil];
        if ([result.appleTradeNo isEqualToString:transactionId]) {
            if (result.orderResult.boolValue) {
                mLog(@"Store-IAP:凭证验证通过");
                [self removeReceipt];
                [self handleActionWithType:TCIAPPurchaseSuccess ];

            } else if (!result.orderResult.boolValue && [result.orderResultCode isEqualToNumber:@(1210)]){
                //重复请求
                mLog(@"Store-IAP:凭证验证通过");
                [self removeReceipt];
                [self handleActionWithType:TCIAPPurchaseSuccess ];

            } else if (!result.orderResult.boolValue && [result.orderResultCode isEqualToNumber:@(1211)]) {
                mLog(@"Store-IAP:凭证验证不通过,苹果产品ID不匹配");
                revalidateCount = @(revalidateCount.integerValue - 1);
                if (revalidateCount.integerValue <= 0) {
                    [self handleActionWithType:TCIAPPurchaseValidateFailed];
                } else {
                    [self revalidateWithOrderId:orderId transactionId:transactionId receipt:receipt count:revalidateCount];
                }
            } else if (result.orderResult.boolValue && [result.orderResultCode isEqualToNumber:@(1212)]) {
                mLog(@"Store-IAP:凭证验证不通过,苹果产品ID已使用");
                revalidateCount = @(revalidateCount.integerValue - 1);
                if (revalidateCount.integerValue <= 0) {
                    [self handleActionWithType:TCIAPPurchaseValidateFailed];
                } else {
                    [self revalidateWithOrderId:orderId transactionId:transactionId receipt:receipt count:revalidateCount];
                }
            } else {
                mLog(@"Store-IAP:凭证验证不通过");
                revalidateCount = @(revalidateCount.integerValue - 1);
                if (revalidateCount.integerValue <= 0) {
                    [self handleActionWithType:TCIAPPurchaseValidateFailed];
                } else {
                    [self revalidateWithOrderId:orderId transactionId:transactionId receipt:receipt count:revalidateCount];
                }
            }
        } else {
            mLog(@"Store-IAP:验证返回的transaction_id不匹配");
            revalidateCount = @(revalidateCount.integerValue - 1);
            if (revalidateCount.integerValue <= 0) {
                [self handleActionWithType:TCIAPPurchaseValidateFailed];
            } else {
                [self revalidateWithOrderId:orderId transactionId:transactionId receipt:receipt count:revalidateCount];
            }
        }
        
    } failure:^(NSError *error) {
        mLog(@"Store-IAP:请求验证接口失败");
        revalidateCount = @(revalidateCount.integerValue - 1);
        if (revalidateCount.integerValue <= 0) {
            [self handleActionWithType:TCIAPPurchaseValidateFailed];
        } else {
            [self revalidateWithOrderId:orderId transactionId:transactionId receipt:receipt count:revalidateCount];
        }
    }];
}

- (void)removeReceipt {
    NSFileManager *fileManager = NSFileManager.defaultManager;
    if ([fileManager fileExistsAtPath:TCSandBoxHelper.iapReceiptFilePath]) {
        [fileManager removeItemAtPath:TCSandBoxHelper.iapReceiptFilePath error:nil];
        mLog(@"Store-IAP:删除已验证通过的支付凭证");
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    [SKPaymentQueue.defaultQueue finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    [self handleActionWithType:TCIAPPurchaseSuccess];
    [SKPaymentQueue.defaultQueue finishTransaction: transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if (transaction.error.code != SKErrorPaymentCancelled) {
        [self handleActionWithType:TCIAPPurchaseFailed];
    } else {
        [self handleActionWithType:TCIAPPurchaseCancle];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

}
@end
