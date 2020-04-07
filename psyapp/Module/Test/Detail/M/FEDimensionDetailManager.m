//
//  FEDimensionDetailManager.m
//  smartapp
//
//  Created by mac on 2019/12/23.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEDimensionDetailManager.h"
#import "EvaluateService.h"
#import "EvaluationDetailDimensionsModel.h"
#import "TCTestHistoryModel.h"
#import "TCHTTPService.h"
@interface FEDimensionDetailManager ()
@end

@implementation FEDimensionDetailManager
- (instancetype)initWithDimensionId:(nonnull NSString *)dimensionId  childExamId:(NSString * _Nullable)childExamId {
    self = [super init];
    self.dimensionId = dimensionId;
    self.childExamId = childExamId;
    self.history = TCPagedDataManager.new;
    self.history.increment = 100;
    return self;
}

- (void)loadDimensionDetailDataWithSuccess:(void (^)(void))success failure:(void (^)(NSString *message))failure {
    [EvaluateService requestDimensionDetailDataWithDimensionId:self.dimensionId childExamId:self.childExamId childId:UCManager.sharedInstance.currentChild.childId success:^(id data) {
        if (data) {
            self.dimensionDetail = [MTLJSONAdapter modelOfClass:[EvaluationDetailDimensionsModel class] fromJSONDictionary:data error:nil];
            self.dimensionDetail.childExamID = self.childExamId;
            if (success) success();
        }
    } failure:^(NSError *error) {
        NSDictionary *errorDic = [HttpErrorManager showErorInfo:error];

        if (failure) failure(errorDic[@"message"]);
    }];
    
  
}

- (void)startDimensionWithSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    if (self.dimensionDetail == nil || [NSString isEmptyString:self.dimensionDetail.dimensionID]) return;
      //可重复答题，这段逻辑删除
//    if (![NSString isEmptyString:self.dimensionDetail.childDimensionID]) {
//        //测评已经开启
//        if (success) success();
//        return;
//    }
    TCProductType type = [NSString isEmptyString:_childExamId]? TCProductTypeTest: TCProductTypeCourse;
    @weakObj(self);
    [EvaluateService startDimensionByDimensionId:self.dimensionDetail.dimensionID childId:UCManager.sharedInstance.currentChild.childId source:type childExamId:self.childExamId
    success:^(id data) {
        [QSLoadingView dismiss];
        //childDimensionId
        selfweak.dimensionDetail.childDimensionID = data[@"child_dimension_id"];
        if (success) success();
        
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error];
        if (failure)failure();
    }];
}

- (void)getTestHistoryListDataWithSuccess:(void (^)(void))success failure:(void (^)(void))failure {
//    if (self.history.data.count > 0) {
//        if (success) success();
//        return;
//    }
    @weakObj(self);
    [self.history resetData];
    self.history.dataGetter = ^(TCPagedDataSetter  _Nonnull setter, NSInteger page, NSInteger count) {
        [TCHTTPService getTestHistory:selfweak.dimensionId onSuccess:^(id data) {
            NSInteger total = [data[@"total"] integerValue];
            NSArray *items = [MTLJSONAdapter modelsOfClass:TCTestHistoryModel.class fromJSONArray:data[@"items"] error:nil];
            setter(total, items, NO);
        } failure:^(NSError *error) {
            setter(0, nil, YES);
        }];
    };
    
    [self.history loadDataOnCompletion:^(TCPagedDataManager * _Nonnull manager, BOOL failed) {
        if (failed){
            if (failure) failure();
        } else {
            if (success) success();
        }
    }];
    
    
}
@end
