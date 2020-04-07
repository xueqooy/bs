//
//  TCTestHistoryModel.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/8.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCTestHistoryModel.h"

@implementation TCTestHistoryModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"finishTime" : @"finish_time",
        @"childDimensionId" : @"child_dimension_id",
        @"result" : @"result",
        @"isBadTendency" : @"is_bad_tendency"
    };
}
@end
