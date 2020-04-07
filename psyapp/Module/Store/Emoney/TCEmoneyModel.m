//
//  TCEmoneyModel.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/20.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCEmoneyModel.h"

@implementation TCEmoneyModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"productId" : @"product_id",
        @"productName" : @"product_name",
        @"price" : @"product_price",
        @"emoneyValue" : @"emoney_value",
        @"appStoreProductId" : @"apple_store_product_id"
    };
}

- (CGFloat)priceYuan {
    if (_price) {
        return _price.floatValue / 100;
    } else {
        return 0;
    }
}

- (CGFloat)emoneyCount {
    if (_emoneyValue) {
        return _emoneyValue.floatValue / 100;
    } else {
        return 0;
    }
}
@end

@implementation TCEmoneyListModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"total" : @"total",
        @"items" : @"items"
    };
}

+ (NSValueTransformer *)itemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:TCEmoneyModel.class];
}
@end

@implementation TCMyEmoneyBalanceModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"userId" : @"user_id",
        @"buyTotal" : @"emoney_buy_total",
        @"exchangeTotal" : @"emoney_exchange_total",
        @"balance" : @"emoney_remain"
    };
}

- (CGFloat)balanceCount {
    if (_balance) {
        return _balance.floatValue / 100;
    } else {
        return 0;
    }
}
@end
