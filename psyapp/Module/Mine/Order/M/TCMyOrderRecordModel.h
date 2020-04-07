//
//  TCMyOrderRecordModel.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/20.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "FEBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TCMyOrderRecordModel : FEBaseModel
@property (nonatomic, strong) NSNumber *orderId;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign)  CGFloat priceYuan;
@end



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
@interface TCEmoneyOrderRecordModel : TCMyOrderRecordModel
@end

@interface TCProductOrderRecordModel : TCMyOrderRecordModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, strong) NSNumber *productType; //1test 2course
@property (nonatomic, copy) NSString *itemId; //dimensionId或corseId
@end
NS_ASSUME_NONNULL_END
