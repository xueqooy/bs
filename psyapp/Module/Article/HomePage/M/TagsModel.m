//
//  TagsModel.m
//  smartapp
//
//  Created by lafang on 2018/8/25.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "TagsModel.h"

@implementation TagsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"tagId":@"id",
             @"name":@"name"
             };
}

@end
