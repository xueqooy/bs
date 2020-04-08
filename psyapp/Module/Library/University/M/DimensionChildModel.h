//
//  DimensionChildModel.h
//  smartapp
//
//  Created by lafang on 2018/8/16.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

@interface DimensionChildModel : FEBaseModel

@property(nonatomic,strong)NSString *childDimensionId;
@property(nonatomic,strong)NSString *examId;
@property(nonatomic,strong)NSString *childExamId;
@property(nonatomic,strong)NSString *childId;
@property(nonatomic,strong)NSString *childTopicId;
@property(nonatomic,strong)NSString *dimensionId;
@property(nonatomic,assign)NSNumber *userId;
@property(nonatomic,assign)NSNumber *costTime;
@property(nonatomic,assign)NSNumber *status;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,strong)NSString *updateTime;
@property(nonatomic,assign)NSNumber *completeFactorCount;
@property(nonatomic,assign)NSNumber *flowers;
@property (nonatomic, strong) NSNumber *reportStatus;

@end

