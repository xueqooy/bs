//
//  DimensionBaseModel.h
//  smartapp
//
//  Created by lafang on 2018/8/16.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "DimensionChildModel.h"

@interface DimensionBaseModel : FEBaseModel


@property(nonatomic,strong) NSNumber *algorithm;
@property(nonatomic,strong) NSNumber *orderby;
@property(nonatomic,strong) NSNumber *factorCount;
@property(nonatomic,strong) NSString *definition;
@property(nonatomic,strong) NSString *icon;
@property(nonatomic,strong) NSNumber *unlockFlowers;
@property(nonatomic,strong) NSNumber *flowers;
@property(nonatomic,strong) NSNumber *suitableUser;//V2.0使用对象：1学生2家长
@property(nonatomic,strong) NSNumber *appraisalType;
@property(nonatomic,strong) NSString *preDimensions;
@property(nonatomic,strong) DimensionChildModel *childDimension;
@property(nonatomic,strong) NSString *backgroundColor;
@property(nonatomic,strong) NSString *examId;

//有用的
@property(nonatomic, copy) NSNumber *reportForbid;
@property(nonatomic, copy) NSString *reportForbidHint;
@property(nonatomic,strong) NSString *dimensionId;
@property(nonatomic,strong) NSString *topicId;
@property(nonatomic,strong) NSString *dimensionName;
@property(nonatomic,strong) NSString *descriptionD;
@property(nonatomic,strong) NSString *instruction;
@property(nonatomic,strong) NSString *backgroundImage;
@property(nonatomic,strong) NSNumber *useCount;
@property(nonatomic,strong) NSNumber *questionCount;
@property(nonatomic,strong) NSNumber *estimatedTime;
@property(nonatomic,strong) NSNumber *isDuplicate;//是不是重复的量表
@property(nonatomic,strong) NSNumber *isLocked;
@property(nonatomic,assign) NSNumber *status; //nil：量表未开始。0:进行中。1:已完成
@property(nonatomic,strong) NSString *childDimensionId;

@property (nonatomic, strong) NSNumber *reportStatus;
//附加 （非后台返回）
@property(nonatomic, copy) NSString *childExamID;
@property(nonatomic,strong) NSString *topicDimensionId;

@end

