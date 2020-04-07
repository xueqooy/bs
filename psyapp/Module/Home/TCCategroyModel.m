//
//  TCCategroyModel.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/3.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCCategroyModel.h"

@implementation TCStageModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"code" : @"code",
        @"name" : @"name",
        @"remark" : @"remark",
    };
}

@end

@implementation TCCategroyModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"Id" : @"id",
        @"name" : @"name",
        @"type" : @"type",
        @"parentId" : @"parent_id",
        @"subItems" : @"sub_items"
    };
}

+ (NSValueTransformer *)subItemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:TCCategroyModel.class];
}
@end
