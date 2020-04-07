//
//  FEEvalutaionReportManager.h
//  smartapp
//
//  Created by mac on 2019/12/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvaluationDetailDimensionsModel.h"
#import "CareerReportDataModel.h"

@interface FEEvalutaionReportManager : NSObject

@property (nonatomic, strong) CareerReportDataModel * _Nullable reportInfo;

- (BOOL)isMergedReport;
- (NSArray <NSString *> *_Nullable)reportNames;

- (instancetype)initWithDimensionId:(NSString *)dimensionId childDimensionId:(NSString *)childDimensionId;

- (void)requestReportDataWithSuccess:(void (^_Nullable)(void))success failure:(void (^_Nullable)(void))failure ifRequstOverUpperLimit:(void (^_Nullable)(void))overLimit;


- (void)requestRecommendProductDataWithSuccess:(void (^)(void))success failure:(void (^_Nullable)(void))failure;
@end

