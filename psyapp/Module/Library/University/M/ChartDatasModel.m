//
//  ChartDatasModel.m
//  smartapp
//
//  Created by lafang on 2018/9/4.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "ChartDatasModel.h"

@implementation ChartDatasModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"isTopic":@"is_topic",
             @"chartItemId":@"chart_item_id",
             @"chartItemName":@"chart_item_name",
             @"chartType":@"chart_type",
             @"scoreType":@"score_type",
             @"minScore":@"min_score",
             @"maxScore":@"max_score",
             @"chartDescription":@"chart_description",
             @"items":@"items",
             };
}

+ (NSValueTransformer *)itemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:ChartItemsModel.class];
}

@end
