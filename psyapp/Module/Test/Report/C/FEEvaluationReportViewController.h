//
//  FEEvaluationReportViewController.h
//  smartapp
//
//  Created by mac on 2019/12/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseViewController.h"
#import "EvaluationDetailDimensionsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FEEvaluationReportViewController : FEBaseViewController

- (instancetype)initWithDimensionId:(NSString *)dimensionId childDimensionId:(NSString *)childDimensionId;
@property (nonatomic, assign) BOOL isCareerReport;
@property(nonatomic, assign) BOOL isCreating; //是否还在生成报告

- (instancetype)initWithAVObject:(AVObject *)object level:(NSInteger)level;
@end

NS_ASSUME_NONNULL_END
