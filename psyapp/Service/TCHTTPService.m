//
//  TCHTTPService.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/13.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCHTTPService.h"

@implementation TCHTTPService
+ (void)getProductCategoriesByCategoryType:(TCCategoryType)type period:(TCPeriodStage)period onSuccess:(success)success failure:(failure)failure {
    NSString *URLString ;
    URLString = [UGTool replacingStrings:@[@"{period}", UCManager.sharedInstance.isVisitorPattern?@"child_id={child_id}":@"{child_id}", @"{client_type}", @"{type}"] withObj:@[@(period), UCManager.sharedInstance.isVisitorPattern? @"" : UCManager.sharedInstance.currentChild.childId, @"2", @(type)] forURL:TC_URL_GET_PRODUCT_CATEGORY];
    
    [QSRequestBase get:URLString success:success failure:failure];
}

+ (void)getTestProductListByPeriodStage:(TCPeriodStage)stage  categoryId:(NSString * _Nullable)categoryId isBest:(NSNumber * _Nullable)isBest isOwn:(NSNumber * _Nullable)isOwn childId:(nonnull NSString *)childId page:(NSInteger)page size:(NSInteger)size onSuccess:(nonnull success)success failure:(nonnull failure)failure {
    NSString *URLString = [UGTool replacingStrings:@[@"{page}", @"{size}"] withObj:@[@(page), @(size) ] forURL:TC_URL_GET_TEST_PRODUCT_LIST];
    
    if (stage != TCPeriodStageNone) {
        URLString = [UGTool replacingStrings:@[@"{period}"] withObj:@[@(stage)] forURL:URLString];
    } else {
        URLString = [URLString stringByReplacingOccurrencesOfString:@"&period={period}" withString:@""];
    }
    
    if (isBest) {
        categoryId = nil;
        NSNumber *_isBest = @0;
        if (isBest.boolValue) {
            _isBest = @1;
        }
        URLString = [UGTool replacingStrings:@[@"{is_best}"] withObj:@[_isBest.boolValue?@"true":@"false"] forURL:URLString];
    } else {
        URLString = [URLString stringByReplacingOccurrencesOfString:@"&is_best={is_best}" withString:@""];
    }
    
    if (categoryId) {
        URLString = [UGTool replacingStrings:@[@"{category_id}"] withObj:@[categoryId] forURL:URLString];
    } else {
        URLString = [URLString stringByReplacingOccurrencesOfString:@"&category_id={category_id}" withString:@""];
    }
    
    if (isOwn) {
        NSNumber *_isOwn = @0;
        if (isOwn.boolValue) {
            _isOwn = @1;
        }
        URLString = [UGTool replacingStrings:@[@"{is_own}"] withObj:@[_isOwn.boolValue?@"true":@"false"] forURL:URLString];
    } else {
        URLString = [URLString stringByReplacingOccurrencesOfString:@"&is_own={is_own}" withString:@""];
    }
    
    
    if (![NSString isEmptyString:childId]) {
        URLString = [UGTool replacingStrings:@[@"{child_id}"] withObj:@[childId] forURL:URLString];
    } else {
        URLString = [URLString stringByReplacingOccurrencesOfString:@"&child_id={child_id}" withString:@""];
    }
    [QSRequestBase get:URLString success:success failure:failure];
}

+ (void)postOrderCreationByPaymentType:(TCPaymentType)paymentType productId:(NSString *)productId productType:(TCProductType)productType onSuccess:(success)success failure:(failure)failure {
    if (productId == nil) return;
    NSDictionary *param = @{
        @"pay_type" : @(paymentType),
        @"product_id" : productId,
        @"product_type" : @(productType)
    };
    
    [QSRequestBase post:TC_URL_POST_ORDER_CREATE parameters:param success:success failure:failure];
}

+ (void)getCourseProductListByChildId:(NSString *)childId isOwn:(NSNumber *)isOwn page:(NSInteger)page size:(NSInteger)size onSuccess:(success)success failure:(failure)failure {
    NSString *URLString = TC_URL_GET_COURSE_PRODUCT_LIST;
    if (![NSString isEmptyString:childId] && isOwn) {
        URLString= [UGTool putParams:@{
            @"child_id" : childId,
            @"is_own" : isOwn.boolValue? @"true":@"false",
            @"page" : @(page),
            @"size" : @(size)
        } forURL:URLString];
    } else if ([NSString isEmptyString:childId]) {
        URLString =[UGTool putParams:@{
            @"page" : @(page),
            @"size" : @(size)
        } forURL:URLString];
    } else if (![NSString isEmptyString:childId] && !isOwn) {
        URLString = [UGTool putParams:@{
            @"child_id" : childId,
            @"page" : @(page),
            @"size" : @(size)
        } forURL:URLString];
    }
    [QSRequestBase get:URLString success:success failure:failure];
}

+ (void)postValidateIAPReceiptByOrderId:(NSString *)orderId transactionId:(NSString *)transactionId receiptData:(NSString *)receiptData onSuccess:(success)success failure:(failure)failure {
    NSString *URLString = TC_URL_POST_IAP_ORDER_VALIDATE;
    NSDictionary *param = @{
        @"order_id" : orderId,
        @"transaction_id" : transactionId,
        @"receipt_data" : receiptData
    };
    [QSRequestBase post:URLString parameters:param success:success failure:failure];
}

+ (void)getProductOrderRecordByType:(TCProductType)type page:(NSInteger)page size:(NSInteger)size onSuccess:(success)success failure:(failure)failure {
    NSString *URLString = TC_URL_GET_ORDER_RECORD;
    URLString = [UGTool replacingStrings:@[@"{product_type}", @"{page}", @"{size}"] withObj:@[@(type), @(page), @(size)] forURL:URLString];
    [QSRequestBase get:URLString success:success failure:failure];

}

+ (void)getEmoneyOrderRecordByPage:(NSInteger)page size:(NSInteger)size onSuccess:(success)success failure:(failure)failure {
    NSString *URLString = TC_URL_GET_EMONEY_ORDER_RECORD;
    URLString = [UGTool replacingStrings:@[@"{page}", @"{size}"] withObj:@[@(page), @(size)] forURL:URLString];
    [QSRequestBase get:URLString success:success failure:failure];
}

+ (void)getEmoneyProductListOnSuccess:(success)success failure:(failure)failure {
    NSString *URLString = TC_URL_GET_EMONEY_PRODUCT_LIST;
    [QSRequestBase get:URLString success:success failure:failure];
}

+ (void)getMyEmoneyBalanceOnSuccess:(success)success failure:(failure)failure {
    NSString *URLString = TC_URL_GET_MY_EMONEY_BALANCE;
    [QSRequestBase get:URLString success:success failure:failure];
}

+ (void)postEmoneyOrderCreationByPaymentType:(TCPaymentType)paymentType productId:(NSString *)productId onSuccess:(success)success failure:(failure)failure {
    NSString *URLString = TC_URL_POST_EMONEY_ORDER_CREATION;
    NSDictionary *param = @{
        @"pay_type" : @(paymentType),
        @"product_id" : productId
    };
    [QSRequestBase post:URLString parameters:param success:success failure:failure];
}

+ (void)getAppRecommendURLOnSuccess:(success)success failure:(failure)failure {
    NSString *URLString = TC_URL_GET_APP_RECOMMEND_URL;
    [QSRequestBase get:URLString success:success failure:failure];
}

+ (void)getTestHistory:(NSString *)dimensionId onSuccess:(nonnull success)success failure:(nonnull failure)failure{
    if ([NSString isEmptyString:dimensionId]) return;
    if ([NSString isEmptyString:UCManager.sharedInstance.currentChild.childId]) return;
    NSString *URLString = [UGTool replacingStrings:@[@"{dimension_id}", @"{child_id}"] withObj:@[dimensionId, UCManager.sharedInstance.currentChild.childId] forURL:TC_URL_GET_TEST_HISTORY];
    [QSRequestBase get:URLString success:success failure:failure];
}
@end
