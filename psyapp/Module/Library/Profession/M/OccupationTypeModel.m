//
//  OccupationTypeModel.m
//  smartapp
//
//  Created by lafang on 2019/3/22.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "OccupationTypeModel.h"

@implementation OccupationTypeModel

//"realm":"string",                   //行业 - 领域
//"personality_type":"string",        //ACT - 六大人格分类
//"sub_items":[

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"realm":@"realm",
             @"personalityType":@"personality_type",
             @"subItems":@"sub_items",
             };
}

+ (NSValueTransformer *)subItemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:OccupationTypeItemModel.class];
}

@end
