//
//  FEDimensionDetailManager.h
//  smartapp
//
//  Created by mac on 2019/12/23.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FEAppraisalManager.h"
#import "FEDimensionEvaluateModel.h"
#import "TCPagedDataManager.h"
@class EvaluationDetailDimensionsModel;
NS_ASSUME_NONNULL_BEGIN

@interface FEDimensionDetailManager : NSObject
@property (nonatomic, strong) EvaluationDetailDimensionsModel *dimensionDetail;

@property (nonatomic, strong) TCPagedDataManager *history;

@property (nonatomic, copy) NSString *dimensionId;
@property (nonatomic, copy) NSString *childExamId;

- (instancetype)initWithDimensionId:(NSString *)dimensionId childExamId:(NSString * _Nullable)childExamId;


/**
 量表详情
 */
- (void)loadDimensionDetailDataWithSuccess:(void (^)(void))success failure:(void (^)(NSString *message))failure;

/**
 开启量表（答题）
 */
- (void)startDimensionWithSuccess:(void (^)(void))success failure:(void (^)(void))failure;

/**
 获取测评历史
 */
- (void)getTestHistoryListDataWithSuccess:(void (^)(void))success failure:(void (^)(void))failure;
@end

NS_ASSUME_NONNULL_END
