//
//  FEAnswerManager.h
//  smartapp
//
//  Created by mac on 2019/11/11.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FEAnswerModel.h"

@interface FEAnswerManager : NSObject
@property (nonatomic, assign) NSInteger userAnswserIndex; //需要作答的题目下标
@property (nonatomic, copy) NSArray *questions;
@property (nonatomic,strong) NSMutableArray<FEAnswerModel *> *answers;
@property (nonatomic, assign) NSInteger costedTime;

@property (nonatomic, assign) BOOL didUserBeginAnswer; //判断用户是否开始答题了


- (instancetype)initWithChildDimensionID:(NSString *)childDimensionID isMerge:(BOOL)merge;

- (void)loadQuestionsWithSuccess:(void(^)(NSInteger answerIndex))success failure:(void(^)(void))failure;

- (void)saveSingleAnswerWithOptionIndex:(NSNumber *)index optionText:(NSString *)text forPage:(NSInteger)page ifMergeSubquestionIndex:(NSInteger)subquestionIdx;

- (void)saveAnswers:(void(^)(void))success failure:(void(^)(void))failure;

- (void)submitAnwsersWithSuccess:(void(^)(id data))success failure:(void(^)(void))failure;

- (BOOL)isAnsweredForPage:(NSInteger)page;

- (void)saveDataWhenNetworkNotReachable;

- (void)clearLocalDataWhenNetworkReachable;

- (void)test_answerAllQuestions;


@property (nonatomic, strong) AVObject *avObject;
- (instancetype)initWithAVObject:(AVObject *)avObject;

@end

