//
//  ChartItemDataModel.m
//  smartapp
//
//  Created by lafang on 2018/12/11.
//  Copyright © 2018 jeyie0. All rights reserved.
//

#import "ChartItemDataModel.h"

@implementation ChartItemDataModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"itemId":@"item_id",
             @"itemName":@"item_name",
             @"score":@"score"
             };
}

@end
