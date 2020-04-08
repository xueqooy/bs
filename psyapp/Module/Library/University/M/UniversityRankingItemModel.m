//
//  UniversityRankingItemModel.m
//  smartapp
//
//  Created by lafang on 2019/3/18.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UniversityRankingItemModel.h"

@implementation UniversityRankingItemModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"code":@"code",
             @"name":@"name",
             @"value":@"value",
             @"type":@"type",
             };
}

@end
