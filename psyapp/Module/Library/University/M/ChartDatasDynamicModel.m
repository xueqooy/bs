//
//  ChartDatasDynamicModel.m
//  smartapp
//
//  Created by lafang on 2018/12/11.
//  Copyright © 2018 jeyie0. All rights reserved.
//

#import "ChartDatasDynamicModel.h"

@implementation ChartDatasDynamicModel

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
    return [MTLJSONAdapter arrayTransformerWithModelClass:ChartItemsDynamicModel.class];
}

@end
