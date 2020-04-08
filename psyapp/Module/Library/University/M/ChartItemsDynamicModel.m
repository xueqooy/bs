//
//  ChartItemsDynamicModel.m
//  smartapp
//
//  Created by lafang on 2018/12/11.
//  Copyright © 2018 jeyie0. All rights reserved.
//

#import "ChartItemsDynamicModel.h"

@implementation ChartItemsDynamicModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"compareName":@"compare_name",
             @"compareId":@"compare_id",
             @"chartDatas":@"chart_datas",
             };
}

+ (NSValueTransformer *)chartDatasJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:ChartItemDataModel.class];
}

@end
