//
//  TCOrderModel.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/14.
//  Copyright © 2020 Cheersmind. All rights reserved.
// https://www.tapd.cn/22217601/markdown_wikis/#1122217601001001803@toc33

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TCOrderSignInfoModel : FEBaseModel
@property (nonatomic, copy) NSString *orderString; //支付宝签名串
@property (nonatomic, copy) NSString *appId;       //微信开放平台审核通过的应用APPID
@property (nonatomic, copy) NSString *prepayId;    //微信返回的支付交易会话ID
@property (nonatomic, copy) NSString *partnerId;   //微信支付分配的商户号
@property (nonatomic, copy) NSString *noncestr;    //微信随机字符串
@property (nonatomic, copy) NSString *timestamp;   //微信时间戳
@property (nonatomic, copy) NSString *sign;        //微信签名
@end

@interface TCOrderModel : FEBaseModel
@property (nonatomic, strong) NSNumber *needPay;
@property (nonatomic, strong) NSNumber *orderId;
@property (nonatomic, strong) NSNumber *orderPrice;
@property (nonatomic, strong) NSNumber *payType;
@property (nonatomic, copy)   NSString *appStoreProductId;  //IAP请求商品需要的productId
@property (nonatomic, strong) TCOrderSignInfoModel *signInfo;
@end


//https://www.tapd.cn/22217601/markdown_wikis/#1122217601001001832@toc42
@interface TCIAPOrderValidationResultModel :FEBaseModel
@property (nonatomic, strong) NSNumber *orderResult;
@property (nonatomic, strong) NSNumber *orderResultCode;
@property (nonatomic, copy) NSString *orderResultDesc;

@property (nonatomic, copy) NSString *appleTradeStatus;
@property (nonatomic, copy) NSString *appleTradeNo;
@property (nonatomic, copy) NSString *appleStoreProductId;
@property (nonatomic, copy) NSString *payTime;
@property (nonatomic, copy) NSNumber *emoneyRemain;
@end
NS_ASSUME_NONNULL_END
