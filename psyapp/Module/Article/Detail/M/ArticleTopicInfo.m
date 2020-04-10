//
//  ArticleTopicInfo.m
//  smartapp
//
//  Created by lafang on 2018/8/25.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "ArticleTopicInfo.h"

@implementation ArticleTopicInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"examId":@"exam_id",
             @"examName":@"exam_name",
             @"topicId":@"topic_id",
             @"topicName":@"topic_name",
             @"dimensionId":@"dimension_id",
             @"dimensionName":@"dimension_name",
             @"status":@"status",
             };
}


@end
