//
//  CommentRootMdoel.m
//  smartapp
//
//  Created by lafang on 2018/8/28.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "CommentRootMdoel.h"
#import "CommentModel.h"

@implementation CommentRootMdoel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"total":@"total",
             @"items":@"items"
             };
}


+ (NSValueTransformer *)itemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:CommentModel.class];
}

@end
