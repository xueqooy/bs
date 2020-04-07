//
//  QuestionChildModel.h
//  smartapp
//
//  Created by lafang on 2018/8/16.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

@interface QuestionChildModel : FEBaseModel

@property(nonatomic,strong) NSString *qid;
@property(nonatomic,strong) NSString *examId;
@property(nonatomic,assign) NSNumber *userId;
@property(nonatomic,strong) NSString *childId;
@property(nonatomic,strong) NSString *childFactorId;
@property(nonatomic,strong) NSString *questionId;
@property(nonatomic,strong) NSString *optionId;
@property(nonatomic,strong) NSString *optionText;

@end

