//
//  FEAppraiseManager.h
//  smartapp
//
//  Created by mac on 2020/1/16.
//  Copyright © 2020 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FEDimensionEvaluateModel.h"
#import "JudgeModel.h"

typedef enum FEAppraisalType{
    FEAppraisalTypeTest = 0,
    FEAppraisalTypeCourse = 1,
} FEAppraisalType;


/**
 目前只会有一种评价，如果有多种评价，代码需要调整
*/
@interface FEAppraisalManager : NSObject
@property (nonatomic, assign) NSString *uniqueId;
@property (nonatomic, assign) FEAppraisalType type;
@property (nonatomic, strong) FEDimensionEvaluateTitleModel *appraisalTitleListData;
@property (nonatomic, strong) FEDimensionEvaluateModel *appraisalIndexNumberData;
@property (nonatomic, strong) JudgeModel *appraisalItemsData;
@property (nonatomic, assign, readonly) BOOL hasAppraised;
@property (nonatomic, assign, readonly) CGFloat recommentIndex;
//课程是courseid,测评是dimensionId
- (instancetype)initWithUniqueId:(NSString *)uniqueId type:(FEAppraisalType)type;

//1.获取推荐指数，五星评价表数据,需要先请求2
- (void)loadAppraisalIndexNumberDataOnSuccess:(void (^)(void))success onFailure:(void (^)(void))failure;

//2.获取评价标题列表（不需要手动调用）
- (void)loadAppraisalTitleListDataOnSuccess:(void (^)(void))success onFailure:(void (^)(void))failure;

//3.判断是否已经评价、获取提交评价所需的item，需要先请求2
- (void)loadAppraisalItemsDataOnSuccess:(void (^)(void))success onFailure:(void (^)(void))failure;

//4.提交评价,需要先请求3
- (void)commitAppraisalAtIndex:(NSInteger)idx onComplete:(void (^)(void))complete;

- (NSArray<NSNumber *> *)getFiveScoreData;


@end


