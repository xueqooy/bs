//
//  TCOrderModel.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/14.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCOrderModel.h"
@implementation TCOrderSignInfoModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"orderString" : @"order_string",
        @"appId" : @"appid",
        @"prepayId" : @"prepayid",
        @"partnerId" : @"partnerid",
        @"noncestr" : @"noncestr",
        @"timestamp" : @"timestamp",
        @"sign" : @"sign",
    };
}
@end

@implementation TCOrderModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"needPay" : @"need_pay",
        @"orderId" : @"order_id",
        @"orderPrice" : @"order_price",
        @"signInfo" : @"sign_info",
        @"payType" : @"pay_type",
        @"appStoreProductId" : @"apple_store_product_id"
    };
}
@end

@implementation TCIAPOrderValidationResultModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"orderResult" : @"order_result",
        @"orderResultCode" : @"order_result_code",
        @"orderResultDesc" : @"order_result_desc",
        @"appleTradeStatus" : @"apple_trade_status",
        @"appleTradeNo" : @"apple_trade_no",
        @"appleStoreProductId" : @"apple_store_product_id",
        @"payTime" : @"pay_time",
        @"emoneyRemain" : @"emoney_remain"
    };
}
@end
