//
//  DegreesModel.m
//  smartapp
//
//  Created by lafang on 2019/3/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "DegreesModel.h"

@implementation DegreesModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"code":@"code",
             @"name":@"name",
             @"rankingItems":@"ranking_items",
             };
}


+ (NSValueTransformer *)rankingItemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:DegreesRankingModel.class];
}

@end
