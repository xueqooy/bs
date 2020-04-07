//
//  FEAnswerManager.m
//  smartapp
//
//  Created by mac on 2019/11/11.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEAnswerManager.h"
#import "EvaluateService.h"
#import "FEQuestionModel.h"
#import "FEMergeQuestionModel.h"
#import <YTKKeyValueStore.h>
@interface FEAnswerManager ()
@property (nonatomic, copy) NSString *childDimensionID;
@property (nonatomic, assign) BOOL isMerge;

@end
@implementation FEAnswerManager


- (instancetype)initWithChildDimensionID:(NSString *)childDimensionID isMerge:(BOOL)merge {
    self = [super init];
    self.childDimensionID = childDimensionID;
    self.isMerge = merge;
    self.answers = @[].mutableCopy;
    return self;
}

- (BOOL)isAnsweredForPage:(NSInteger)page {
    if (_isMerge == NO) {
        FEQuestionModel *question = self.questions[page];
        if (question.childQuestion == nil) {
            return NO;
        }
    } else {
        FEMergeQuestionModel *question = self.questions[page];
        for (FEMergeSubquestionModel *subquestion in question.subQuestions) {
            if (subquestion.answers == nil || (subquestion.answers && subquestion.answers.optionID == nil)) {
                return NO;
            }
        }
    }
    return YES;

}

- (void)loadQuestionsWithSuccess:(void(^)(NSInteger answerIndex))success failure:(void (^)(void))failure {
    if (_isMerge) {
        [self p_loadMergeQuestionsWithSuccess:success failure:failure];
    } else {
        [self p_loadNoMergeQuestionsWithSuccess:success failure:failure];
    }
}

- (void)saveSingleAnswerWithOptionIndex:(NSNumber *)index optionText:(NSString *)text forPage:(NSInteger)page ifMergeSubquestionIndex:(NSInteger)subquestionIdx{
    if (_isMerge == NO) {
        FEQuestionModel *question = self.questions[page];
        OptionModel *option = question.options[index.integerValue];
        NSString *questionID = question.questionID;
        NSString *optionID = option.optionId;
        NSString *optionText = text;
        
        FEAnswerModel *newAnswer = [FEAnswerModel new];
        newAnswer.questionID = questionID;
        newAnswer.optionID = optionID;
        newAnswer.childFactorID  = question.childFactorID;
        newAnswer.optionText = optionText;
    
        if (question.childQuestion) {
            question.childQuestion.optionId = optionID;
            question.childQuestion.optionText = optionText;
        } else {
            QuestionChildModel *childQuestion = [QuestionChildModel new];
            childQuestion.optionId = optionID;
            childQuestion.optionText = optionText;
            question.childQuestion = childQuestion;
        }
        [self p_addNewAnswer:newAnswer];
    } else {
        FEMergeQuestionModel *question = self.questions[page];
        
        FEMergeSubquestionModel *subquestion = question.subQuestions[subquestionIdx];
        FEMergeSubquestionOptionModel *option = question.options[index.integerValue];
       // NSParameterAssert(option.optionID);
        NSString *questionID = question.questionID;
        NSString *optionID = option.optionID;
        NSString *optionText = text;
        
        FEAnswerModel *newAnswer = [FEAnswerModel new];
        newAnswer.questionID = questionID;
        newAnswer.optionID = optionID;
        newAnswer.childFactorID = subquestion.childFactorID;
        newAnswer.optionText = optionText;
        
        if (subquestion.answers && subquestion.answers.optionID != nil) {
            subquestion.answers.optionID = optionID;
            subquestion.answers.optionText = optionText;
        } else {
            FEMergeSubquestionAnswerModel *answer = [FEMergeSubquestionAnswerModel new];
            answer.optionID = optionID;
            answer.optionText = optionText;
            subquestion.answers = answer;
        }
        [self p_addNewAnswer:newAnswer];
        
      
    }
    
    
}
//保存答案到服务器
- (void)saveAnswers:(void (^)(void))success failure:(void (^)(void))failure {
    if(self.answers.count == 0){
        if (success) {
            success();
        }
        return;
    }
    
    NSMutableArray *dictionaryAnswers = @[].mutableCopy;
    for (FEAnswerModel *answer in self.answers) {
        NSDictionary *dictionaryAnswer = @{
            @"question_id" : answer.questionID,
            @"option_id" : answer.optionID,
            @"child_factor_id" : answer.childFactorID? answer.childFactorID : @"",
            @"option_text" : answer.optionText? answer.optionText: @""
        };
        
        [dictionaryAnswers addObject:dictionaryAnswer];
    }
    
   if (dictionaryAnswers.count == 0) {
       [self fillAAnswerWhenUploadedDataEmpty:dictionaryAnswers];
   }

    NSDictionary *answersData = @{
        @"cost_time":[NSString stringWithFormat:@"%li",(long)(self.costedTime < 1? 2: self.costedTime)],
        @"answers" :dictionaryAnswers
    };
       
    [QSLoadingView show];
    [EvaluateService saveDimensionQuestion:self.childDimensionID answer:answersData success:^(id data) {
        [QSLoadingView dismiss];
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error showView:[UIApplication sharedApplication].keyWindow];
        if (failure) {
            failure();
        }
    }];
}

- (void)submitAnwsersWithSuccess:(void (^)(id))success failure:(void (^)(void))failure {
    NSMutableArray *dictionaryAnswers = @[].mutableCopy;
    for (FEAnswerModel *answer in self.answers) {
        NSDictionary *dictionaryAnswer = @{
                @"question_id" : answer.questionID,
                @"option_id" : answer.optionID,
                @"child_factor_id" : answer.childFactorID? answer.childFactorID : @"",
                @"option_text" : answer.optionText? answer.optionText: @""
            };
        [dictionaryAnswers addObject:dictionaryAnswer];
    }
    if (dictionaryAnswers.count == 0) {
        [self fillAAnswerWhenUploadedDataEmpty:dictionaryAnswers];
    }
    
    NSDictionary *answersData = @{
        @"cost_time":[NSString stringWithFormat:@"%li",(long)(self.costedTime < 1? 2: self.costedTime)],
        @"answers":dictionaryAnswers,
                                 };
    
//    NSLog(@"%@", answersData[@"answers"]);
    [QSLoadingView show];
    [EvaluateService submitDimensionQuestion:self.childDimensionID answer:answersData success:^(id data) {
        [QSLoadingView dismiss];
        if (success) {
            success(data);
        }
        
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error showView:[UIApplication sharedApplication].keyWindow];
        if (failure) {
            failure();
        }
    }];
}

- (void)fillAAnswerWhenUploadedDataEmpty:(NSMutableArray *)dictionaryAnswers {
    //当没有答案提交时，服务器会报错，需要填充一个答案(从返回的数据中找一个)
       if (dictionaryAnswers.count == 0) {
           if (_isMerge == NO) {
               for (FEQuestionModel *question in self.questions) {
                   if (question.childQuestion) {
                       NSDictionary *dictionaryAnswer = @{
                           @"question_id" : question.questionID,
                           @"option_id" : question.childQuestion.optionId?question.childQuestion.optionId:@"",
                           @"child_factor_id" : question.childQuestion.childFactorId? question.childQuestion.childFactorId : @"",
                           @"option_text" : question.childQuestion.optionText?question.childQuestion.optionText:@""
                       };
                    [dictionaryAnswers addObject:dictionaryAnswer];
                       break;
                   }
               }
           } else {
               for (FEMergeQuestionModel *question in self.questions) {
                   for (FEMergeSubquestionModel *sub in question.subQuestions) {
                       if (sub.answers) {
                           NSDictionary *dictionaryAnswer = @{
                               @"question_id" : question.questionID,
                               @"option_id" : sub.answers.optionID?sub.answers.optionID:@"",
                               @"child_factor_id" : sub.childFactorID? sub.childFactorID : @"",
                               @"option_text" : sub.answers.optionText?sub.answers.optionText:@""
                           };
                           [dictionaryAnswers addObject:dictionaryAnswer];
                           break;
                       }
                   }
               }
           }
       }
}

//添加或替换答题
- (void)p_addNewAnswer:(FEAnswerModel *)newAnswer {
    BOOL isReplace = NO;
    for (int i = 0; i < self.answers.count; i++) {
        FEAnswerModel *answer = self.answers[i];
        if ([answer.questionID isEqualToString:newAnswer.questionID] && [answer.childFactorID isEqualToString:newAnswer.childFactorID]) {
            self.answers[i] = newAnswer;
            isReplace = YES;
            break;
        }
    }
     
    if (isReplace == NO) {
        [self.answers addObject:newAnswer];
    }

}

- (void)p_loadNoMergeQuestionsWithSuccess:(void (^)(NSInteger answerIndex))success failure:(void (^)(void))failure {
    [QSLoadingView show];
    [EvaluateService getDimensionQuestions:self.childDimensionID success:^(id data) {
        [QSLoadingView dismiss];
        
        NSArray *items = data[@"items"];
        NSMutableArray *tmp = @[].mutableCopy;
        if(items){
            for (int i = 0; i < items.count; i++) {
                NSDictionary *item = items[i];
                FEQuestionModel *question = [MTLJSONAdapter modelOfClass:FEQuestionModel.class fromJSONDictionary:item error:nil];
                [tmp addObject:question];
            }
            
            [self p_didRequstData:tmp];
            
            if (success) {
                success(self.userAnswserIndex);
            }
           
        }
 
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error showView:[UIApplication sharedApplication].keyWindow];
        
        if (failure) {
            failure();
        }
    }];
}

- (void)p_loadMergeQuestionsWithSuccess:(void (^)(NSInteger answerIndex))success failure:(void (^)(void))failure {
    [QSLoadingView show];
    [EvaluateService getDimensionMergeQuestions:self.childDimensionID success:^(id data) {
        [QSLoadingView dismiss];
        NSArray *items = data[@"items"];
        NSMutableArray *tmp = @[].mutableCopy;
        if(items){
            for (int i = 0; i < items.count; i++) {
                NSDictionary *item = items[i];
                FEMergeQuestionModel *question = [MTLJSONAdapter modelOfClass:FEMergeQuestionModel.class fromJSONDictionary:item error:nil];
                [tmp addObject:question];
            }
            
            [self p_didRequstData:tmp];
                   
            if (success) {
                success(self.userAnswserIndex);
            }
        }
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error showView:[UIApplication sharedApplication].keyWindow];
        if (failure) {
            failure();
        }
    }];
}

//这里做本地数据的判断，如果存在本地数据，将本地数据附加到questions中
- (void)p_didRequstData:(NSArray *)data {
    self.questions = data;
    self.costedTime = 0;
    
    NSArray<FEAnswerModel *> *localAnswers = [self p_getLocalAnswerData];
    if (localAnswers!= nil && localAnswers.count > 0) { //将本地答案填入questions
        [self p_fillAnswers:localAnswers intoQuestions:self.questions];
    }
    
    self.userAnswserIndex = [self p_getUserAnswerIndex];
}

- (void)p_fillAnswers:(NSArray<FEAnswerModel *> *)answers intoQuestions:(NSArray *)questions {
    //获取网络保存答题的位置
    NSInteger answerIndex = [self p_getUserAnswerIndex];
    //做一层保护
    if (answerIndex >= questions.count - 1) {
        return;
    }
    
    NSMutableArray *validAnswers = @[].mutableCopy;
    if (!_isMerge) {
        int increment = 0;
        for (FEAnswerModel *answer in answers) {
            FEQuestionModel *question = questions[answerIndex + increment];
            //问题和答案匹配，如果不匹配，只添加匹配的答案
            if ([answer.questionID isEqualToString:question.questionID] && [answer.childFactorID isEqualToString:question.childFactorID]) {
                QuestionChildModel *model = [QuestionChildModel new];
                model.childFactorId = answer.childFactorID;
                model.questionId = answer.questionID;
                model.optionId = answer.optionID;
                model.optionText = answer.optionText;
                //设置问题的本地答案
                question.childQuestion = model;
                [validAnswers addObject:answer];
            } else {
                break;
            }
            increment ++;
        }
    } else {
        NSDictionary *answerDic = [self p_hashingAnswers:answers];
        for (NSInteger i = answerIndex; i < questions.count; i ++) {
            FEMergeQuestionModel *question = self.questions[i];
            BOOL endFlag = NO;
            for (FEMergeSubquestionModel *subquestion in question.subQuestions) {
                if (subquestion.answers == nil || (subquestion.answers && subquestion.answers.optionID == nil)) {
                    NSString *key = [NSString stringWithFormat:@"%@%@", question.questionID, subquestion.childFactorID];
                    FEAnswerModel *answer = answerDic[key];
                    if (answer) {
                        FEMergeSubquestionAnswerModel *model = [FEMergeSubquestionAnswerModel new];
                        model.optionID = answer.optionID;
                        model.optionText = answer.optionText;
                        subquestion.answers = model;
                        [validAnswers addObject:answer];
                    } else { //该题没有作答,并且没有从本地中找到数据，结束
                        endFlag = YES;
                        break;
                    }
                }
            }
            if (endFlag) {
                break;
            }
        }
    }
    
    self.answers = validAnswers;
}
//算法优化
- (NSDictionary *)p_hashingAnswers:(NSArray <FEAnswerModel *>*)answers {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:answers.count];
    for (FEAnswerModel *answer in answers) {
        [dic setValue:answer forKey:[NSString stringWithFormat:@"%@%@", answer.questionID, answer.childFactorID]];
    }
    return dic;
}

- (NSInteger)p_getUserAnswerIndex {
    _didUserBeginAnswer = NO;
    NSInteger index = 0;
    for (NSInteger i =0; i < self.questions.count; i++) {
        if (!_isMerge) {
            FEQuestionModel *question = self.questions[i];
            if (question.childQuestion) {
                _didUserBeginAnswer = YES;
                index ++;
            } else {
                break;
            }
        } else {
            BOOL flag = NO;
            FEMergeQuestionModel *question = self.questions[i];
            for (FEMergeSubquestionModel *subQuestion in question.subQuestions) {
                if (subQuestion.answers == nil || (subQuestion.answers && subQuestion.answers.optionID == nil)) {
                    flag = YES;
                }
                if (subQuestion.answers.optionID != nil) {
                    _didUserBeginAnswer = YES;
                }
            }
            if (flag == YES) {
                break;
            } else {
                index ++;
            }
        }
    }
    return index;

}

static NSString *const DBName = @"evaluation_data.db";
#define TableName  [NSString stringWithFormat:@"[%@]", UCManager.sharedInstance.currentChild.childId]

//保存在本地
- (void)saveDataWhenNetworkNotReachable {
    YTKKeyValueStore *store = self.DBStore;
    [store putObject:[self p_getJSONObjectsFromAnswerData:self.answers] withId:self.childDimensionID intoTable:TableName];
  
    [store close];
}

- (void)clearLocalDataWhenNetworkReachable {
    YTKKeyValueStore *store = self.DBStore;
    [store deleteObjectById:self.childDimensionID fromTable:TableName];
    [store close];
}

- (NSArray <NSDictionary *>*)p_getJSONObjectsFromAnswerData:(NSArray <FEAnswerModel *>*)answers {
    NSMutableArray <NSDictionary *>*tmp = @[].mutableCopy;
    for (FEAnswerModel *answer in answers) {
        [tmp addObject: answer.dictionaryValue];
    }
    return tmp;
}

- ( NSArray <FEAnswerModel *>*)p_getAnswerDataFromJSONObjects:(NSArray <NSDictionary *>*)jsObjs {
    NSMutableArray <FEAnswerModel *>*tmp = @[].mutableCopy;
    for (NSDictionary *jsObj in jsObjs) {
        FEAnswerModel *answer = [MTLJSONAdapter modelOfClass:[FEAnswerModel class] fromJSONDictionary:jsObj error:nil];
        [tmp addObject:answer];
    }
    return tmp;
}

- (NSArray *)p_getLocalAnswerData {
    YTKKeyValueStore *store = self.DBStore;
    NSArray *jsObjs = [store getObjectById:self.childDimensionID fromTable:TableName];
    [store close];
    return [self p_getAnswerDataFromJSONObjects:jsObjs] ;
}

- (YTKKeyValueStore *)DBStore {
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:DBName];
    [store createTableWithName:TableName];
    return store;
}

- (void)test_answerAllQuestions {
    self.answers = @[].mutableCopy;
    for(int i = 0; i < self.questions.count; i++){
        if (_isMerge == NO) {
            FEQuestionModel *question = self.questions[i];
            NSString *questionID = question.questionID;
            int randomIndex = arc4random() % question.options.count;//随机选答案
            OptionModel *option = question.options[randomIndex];
            NSString *optionID = option.optionId;
            
            FEAnswerModel *answer = [FEAnswerModel new];
            answer.questionID = questionID;
            answer.optionID = optionID;
            answer.childFactorID = question.childFactorID;
            answer.optionText  = @"";
            
            [self.answers addObject:answer];
            
            if (question.childQuestion) {
                question.childQuestion.optionId = optionID;
                question.childQuestion.optionText = @"";
            } else {
                QuestionChildModel *childQuestion = [QuestionChildModel new];
                childQuestion.optionId = optionID;
                childQuestion.optionText = @"";
                question.childQuestion = childQuestion;
            }
        } else {
            FEMergeQuestionModel *question = self.questions[i];
            for (int j = 0; j < question.subQuestions.count; j++) {
                FEMergeSubquestionModel *subquestion = question.subQuestions[j];
                int randomIndex = arc4random() % question.options.count;
                FEMergeSubquestionOptionModel *option =question.options[randomIndex];
                NSString *questionID = question.questionID;
                NSString *optionID = option.optionID;
                
                FEAnswerModel *answer = [FEAnswerModel new];
                answer.questionID = questionID;
                answer.optionID = optionID;
                answer.childFactorID = subquestion.childFactorID;
                answer.optionText = @"";
                
                [self.answers addObject:answer];

                if (subquestion.answers) {
                    subquestion.answers.optionID = optionID;
                    subquestion.answers.optionText = @"";
                } else {
                    FEMergeSubquestionAnswerModel *answer = [FEMergeSubquestionAnswerModel new];
                    answer.optionID = optionID;
                    answer.optionText = @"";
                    subquestion.answers = answer;
                }
            }
        }
    }
}

@end
    
