//
//  CareerChartDataModel.m
//  smartapp
//
//  Created by lafang on 2019/3/19.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "CareerChartDataModel.h"

@implementation CareerChartDataModel

//"chart_item_id":"string",       //当前chart的主题或量表ID
//"chart_item_name":"String",     //当前chart的主题或量表名称
//"chart_type":1,             //图表类型，1-雷达图，2-曲线图，3-柱状图，4-条状图
//"score_type":1,             //分数类型，1-T分数，2-百分位分数，3-原始分
//"min_score":1,              //最小分数
//"max_score":1,              //最大分数
//"chart_description":"string",   //图表说明
//"items":[   //图表中的数据项

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
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
    return [MTLJSONAdapter arrayTransformerWithModelClass:CareerChartDataItemModel.class];
}

@end
