//
//  UniverSitynameItemModel.m
//  smartapp
//
//  Created by lafang on 2019/3/9.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UniverSitynameItemModel.h"

@implementation UniverSitynameItemModel

//@property(nonatomic,strong) NSNumber *total;
//@property(nonatomic,strong) NSString *name;
//@property(nonatomic,strong) NSString *details;
//@property(nonatomic,strong) NSArray *items;
//@property(nonatomic,strong) NSString *type;

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"total":@"total",
             @"name":@"name",
             @"details":@"details",
             @"items":@"items",
             @"type":@"type",
             @"summary":@"summary",
             };
}

+ (NSValueTransformer *)itemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:UniverSitynameItemModel.class];
}

@end
