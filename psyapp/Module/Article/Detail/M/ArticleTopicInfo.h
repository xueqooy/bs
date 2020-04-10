//
//  ArticleTopicInfo.h
//  smartapp
//
//  Created by lafang on 2018/8/25.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

@interface ArticleTopicInfo : FEBaseModel


@property(nonatomic,strong) NSString *examId;
@property(nonatomic,strong) NSString *examName;

@property(nonatomic,strong) NSString *topicId;
@property(nonatomic,strong) NSString *topicName;

@property(nonatomic,strong) NSString *dimensionId;
@property(nonatomic,strong) NSString *dimensionName;

@property(nonatomic,strong) NSNumber *status;

@end
