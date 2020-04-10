//
//  CategoriesRootModel.m
//  smartapp
//
//  Created by lafang on 2018/8/23.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "CategoriesRootModel.h"
#import "CategoriesModel.h"

@implementation CategoriesRootModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"total":@"total",
             @"items":@"items"
             };
}


+ (NSValueTransformer *)itemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:CategoriesModel.class];
}

@end
