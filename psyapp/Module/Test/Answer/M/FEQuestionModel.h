//
//  QuestionBaseModel.h
//  smartapp
//
//  Created by lafang on 2018/8/16.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "OptionModel.h"
#import "QuestionChildModel.h"

@interface FEQuestionModel : FEBaseModel

@property(nonatomic,strong) NSString *questionID;
@property(nonatomic,strong) NSString *factorID;
@property(nonatomic,assign) NSNumber *type;
@property(nonatomic,strong) NSString *stem;
@property(nonatomic,assign) NSNumber *showType;
@property(nonatomic,assign) NSNumber *orderby;
@property(nonatomic,strong) NSString *childFactorID;
@property(nonatomic,strong) NSArray <OptionModel *>*options;
@property(nonatomic,strong) QuestionChildModel *childQuestion;

@end

