//
//  CareerChartDataChildModel.m
//  smartapp
//
//  Created by lafang on 2019/3/19.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "CareerChartDataChildModel.h"

@implementation CareerChartDataChildModel

//"item_id":"uuid",       //量表或因子ID
//"item_name":"string",   //量表或因子名称
//"score":50.5            //得分

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"itemId":@"item_id",
             @"itemName":@"item_name",
             @"score":@"score",
             };
}

@end
