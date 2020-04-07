//
//  TCHTTPService.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/13.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSRequestBase.h"
#import "TCCategoryService.h"
NS_ASSUME_NONNULL_BEGIN

@interface TCHTTPService : NSObject
/**
 https://www.tapd.cn/22217601/markdown_wikis/#1122217601001001797@toc13
 */
//弃用
+ (void)getProductCategoriesByCategoryType:(TCCategoryType)type period:(TCPeriodStage)period onSuccess:(success)success failure:(failure)failure;

/**
 https://www.tapd.cn/22217601/markdown_wikis/#1122217601001001797@toc15
 */
+ (void)getTestProductListByPeriodStage:(TCPeriodStage)stage categoryId:( NSString *_Nullable)categoryId isBest:(  NSNumber *_Nullable)isBest isOwn:( NSNumber *_Nullable)isOwn childId:(NSString *)childId page:(NSInteger)page  size:(NSInteger)size onSuccess:(success)success failure:(failure)failure;
/**
 https://www.tapd.cn/22217601/markdown_wikis/#1122217601001001803@toc33
 */
+ (void)postOrderCreationByPaymentType:(TCPaymentType)paymentType productId:(NSString *)productId productType:(TCProductType)productType onSuccess:(success)success failure:(failure)failure;

+ (void)getCourseProductListByChildId:(NSString *)childId isOwn:(NSNumber *)isOwn page:(NSInteger)page size:(NSInteger)size onSuccess:(success)success failure:(failure)failure;

//https://www.tapd.cn/22217601/markdown_wikis/#1122217601001001832@toc42
+ (void)postValidateIAPReceiptByOrderId:(NSString *)orderId transactionId:(NSString *)transactionId receiptData:(NSString *)receiptData onSuccess:(success)success failure:(failure)failure;

//https://www.tapd.cn/22217601/markdown_wikis/#1122217601001001841@toc45
+ (void)getProductOrderRecordByType:(TCProductType)type page:(NSInteger)page size:(NSInteger)size onSuccess:(success)success failure:(failure)failure;

/**
 /2c/v1/emoney/my_emoney_buy_his
 {
     "total": 1,
     "items": [
         {
             "order_id": 545816852937445400,
             "price": 1200,购买的测点数量，以分为单位
             "pay_time": "2020-02-16T04:31:09.000+0800"  支付时间
         }
     ]
 }
 */
+ (void)getEmoneyOrderRecordByPage:(NSInteger)page size:(NSInteger)size onSuccess:(success)success failure:(failure)failure;

//https://www.tapd.cn/22217601/markdown_wikis/view/#1122217601001001849@toc41
+ (void)getEmoneyProductListOnSuccess:(success)success failure:(failure)failure;

//https://www.tapd.cn/22217601/markdown_wikis/view/#1122217601001001849@toc40
+ (void)getMyEmoneyBalanceOnSuccess:(success)success failure:(failure)failure;

/**
 POST
 /2c/v1/orders/emoney
 {
     "pay_type": 3,
     "product_id": 2
 }
 {
     "product_id": 2
 }
 返回

 {
 "order_id": 547319125605748736,
 "order_price": 1200,
 "need_pay": true,
 "pay_type": 3,
 "apple_store_product_id": "zd12"
 }
 */
+ (void)postEmoneyOrderCreationByPaymentType:(TCPaymentType)paymentType productId:(NSString *)productId onSuccess:(success)success failure:(failure)failure;

//获取APP推荐URL
+ (void)getAppRecommendURLOnSuccess:(success)success failure:(failure)failure;

+ (void)getTestHistory:(NSString *)dimensionId onSuccess:(success)success failure:(failure)failure;;
@end

NS_ASSUME_NONNULL_END
