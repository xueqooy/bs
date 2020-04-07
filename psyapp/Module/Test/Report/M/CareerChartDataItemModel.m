//
//  CareerChartDataItemModel.m
//  smartapp
//
//  Created by lafang on 2019/3/19.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "CareerChartDataItemModel.h"

@implementation CareerChartDataItemModel

//"compare_id":"uuid",        //对比项ID
//"compare_name":"string",    //对比项名称，如：全国，年级，我
//"chart_datas":[

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return @{
             @"compareId":@"compare_id",
             @"compareName":@"compare_name",
             @"chartDatas":@"chart_datas",
             };
}

+ (NSValueTransformer *)chartDatasJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:CareerChartDataChildModel.class];
}

@end
