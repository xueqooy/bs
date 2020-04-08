//
//  UniversityRootModel.m
//  smartapp
//
//  Created by lafang on 2019/3/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UniversityRootModel.h"

@implementation UniversityRootModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"total":@"total",
             @"items":@"items"
             };
}


+ (NSValueTransformer *)itemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:UniversityModel.class];
}

@end
