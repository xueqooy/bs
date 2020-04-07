//
//  TCMyOrderRecordModel.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/20.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCMyOrderRecordModel.h"

@implementation TCMyOrderRecordModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return nil;
}

- (CGFloat)priceYuan {
    if (_price) {
        return _price.floatValue / 100;
    } else {
        return 0;
    }
}
@end

@implementation TCEmoneyOrderRecordModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"orderId" : @"order_id",
        @"price" : @"price",
        @"createTime" : @"pay_time"
    };
}
@end

@implementation TCProductOrderRecordModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"orderId" : @"order_id",
        @"name" : @"product_name",
        @"price" : @"price",
        @"createTime" : @"create_time",
        @"image" : @"product_img",
        @"productId" : @"product_id",
        @"productType" : @"product_type",
        @"itemId" : @"item_id"
    };
}
@end
