//
//  FEDimensionEvaluateModel.m
//  smartapp
//
//  Created by mac on 2019/12/23.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEDimensionEvaluateModel.h"
@implementation FEDimensionEvaluateTitleItemModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"ID":@"id",
             @"title":@"title",
             @"type":@"type"
             };
}
@end

@implementation FEDimensionEvaluateTitleModel : FEBaseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"total":@"total",
             @"items":@"items",
             };
}

+ (NSValueTransformer *)itemsJSONTransformer {

    return [MTLJSONAdapter arrayTransformerWithModelClass:FEDimensionEvaluateTitleItemModel.class];
    
}
@end

@implementation FEDimensionEvaluateItemModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"itemCount" : @"item_count",
             @"value" : @"value",
             };
}

@end

@implementation FEDimensionEvaluateModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"evaluateList":@"evaluate_list",
             @"recommendValue":@"recommand_value",
             };
}

//指向一个array的映射
+ (NSValueTransformer *)evaluateListJSONTransformer {

    return [MTLJSONAdapter arrayTransformerWithModelClass:FEDimensionEvaluateItemModel.class];
    
}

@end
