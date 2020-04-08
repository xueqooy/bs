//
//  UniversityMajorRootModel.m
//  smartapp
//
//  Created by lafang on 2019/3/22.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UniversityMajorRootModel.h"

@implementation UniversityMajorRootModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"total":@"total",
             @"items":@"items"
             };
}


+ (NSValueTransformer *)itemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:UniversityMajorModel.class];
}

@end
