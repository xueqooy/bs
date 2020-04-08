//
//  ChartItemsModel.m
//  smartapp
//
//  Created by lafang on 2018/9/4.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "ChartItemsModel.h"

@implementation ChartItemsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"itemId":@"item_id",
             @"itemName":@"item_name",
             @"compareScore":@"compare_score",
             @"childScore":@"child_score"
             };
}

@end
