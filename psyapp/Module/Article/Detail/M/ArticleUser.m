//
//  ArticleUser.m
//  smartapp
//
//  Created by lafang on 2018/8/25.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "ArticleUser.h"

@implementation ArticleUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userId":@"user_id",
             @"userName":@"user_name",
             @"nickName":@"nick_name",
             @"avatar":@"avatar"
             };
}


@end
