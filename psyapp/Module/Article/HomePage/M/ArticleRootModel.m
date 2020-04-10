//
//  ArticleRootModel.m
//  smartapp
//
//  Created by lafang on 2018/8/25.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "ArticleRootModel.h"


@implementation ArticleRootModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"total":@"total",
             @"items":@"items"
             };
}


+ (NSValueTransformer *)itemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:ArticleModel.class];
}

@end
