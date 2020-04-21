//
//  FEEvalutaionReportManager.m
//  smartapp
//
//  Created by mac on 2019/12/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEEvalutaionReportManager.h"
#import "EvaluateService.h"
#import "TCJSONHelper.h"
@interface FEEvalutaionReportManager ()
@property (nonatomic, copy) NSString *dimensionId;
@property (nonatomic, copy) NSString *childDimensionId;
@property (nonatomic, weak) NSTimer *dataLoadTimer;
@property (nonatomic, assign) NSInteger requestCountWhenCreating; //报告生成时请求数据的次数，达到6次pop

///@property (nonatomic, assign) NSInteger recommendedArticlePage;

@property (nonatomic, copy) void (^requestSuccess)(void);
@property (nonatomic, copy) void (^requestFailure)(void);
@property (nonatomic, copy) void (^requestOverLimit)(void);

@property (nonatomic, strong) AVObject *object;
@property (nonatomic, assign) NSInteger level;

@end

@implementation FEEvalutaionReportManager
- (instancetype)initWithDimensionId:(NSString *)dimensionId childDimensionId:(NSString *)childDimensionId  {
    self = [super init];
    self.dimensionId = dimensionId;
    self.childDimensionId = childDimensionId;
  
    return self;
}

- (instancetype)initWithAVObject:(AVObject *)object level:(NSInteger)level {
    self = [super init];
    self.object = object;
    self.level = level;
    return self;
}

- (BOOL)isMergedReport {
    return self.reportInfo.isMergeAnswer.boolValue;
     
}

- (NSArray<NSString *> *)reportNames {
    if (self.isMergedReport) {
        NSMutableArray *nameArray = @[].mutableCopy;
        for (CareerReportDataModel *item in _reportInfo.subReport) {
            [nameArray addObject:[NSString isEmptyString:item.subTitle]? @"":item.subTitle];
        }
        return nameArray;
    } else {
        return @[[NSString isEmptyString:_reportInfo.title]? @"":_reportInfo.title];
    }
}



- (void)requestReportDataWithSuccess:(void (^)(void))success failure:(void (^)(void))failure ifRequstOverUpperLimit:( void (^)(void))overLimit {
    _requestSuccess = success;
     _requestFailure = failure;
     _requestOverLimit = overLimit;
     
    AVQuery *query = [AVQuery queryWithClassName:@"TestReport"];
    [query whereKey:@"question" equalTo:_object];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for (AVObject *obj in objects) {
            if ([[obj objectForKey:@"level"] integerValue] == self.level) {
                NSDictionary *data = [TCJSONHelper dictionaryWithJsonString:[obj objectForKey:@"data"]];
                self.reportInfo = [MTLJSONAdapter modelOfClass:CareerReportDataModel.class fromJSONDictionary:data error:nil];
                if (success) {
                    success();
                }
                return ;
            }
        }
        if (failure) failure();
    }];
//    [EvaluateService getDimensionReportByChildDimensionId:self.childDimensionId success:^(id data) {
//        if(data){
//            self.reportInfo = [MTLJSONAdapter modelOfClass:CareerReportDataModel.class fromJSONDictionary:data error:nil];
//
//            if ([self.reportInfo.reportStatus isEqualToNumber:@1]) { //报告在生成中
//                [self p_startUpDataLoadTimer];
//                return;
//            } else {
//                if (_dataLoadTimer) {
//                    [_dataLoadTimer invalidate];
//                }
//                if (success) {
//                    success();
//                }
//            }
//
//        }
//    } failure:^(NSError *error) {
//        [QSLoadingView dismiss];
//        [HttpErrorManager showErorInfo:error showView:mKeyWindow];
//        if (failure) {
//            failure();
//        }
//    }];
}

- (void)requestRecommendProductDataWithSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    [EvaluateService getTestReportRecommendProductByDimensionId:self.dimensionId onSuccess:^(id data) {
        self.reportInfo.recommendProductData = [MTLJSONAdapter modelOfClass:TCTestReportRecommendProductModel.class fromJSONDictionary:data error:nil];
        //测试数据
//        TCTestReportRecommendProductModel *model = TCTestReportRecommendProductModel.new;
//        NSMutableArray *testArray = @[].mutableCopy;
//        for (int i = 0; i < 1; i ++) {
//            TCRecommendProductModel *productModel = [TCRecommendProductModel new];
//            productModel.image = @"https://dss0.baidu.com/73F1bjeh1BF3odCf/it/u=1468756503,2169179468&fm=85&s=7A93F0AED4860EFB12BA040A0300E0DA";
//            productModel.name = @"这是个测评我操哦啊操手抽筋吗开始了解到拉萨节快乐";
//            productModel.itemUseCount = @(100);
//            productModel.price = @(100);
//            productModel.originPrice = @(188);
//            productModel.itemId = @"d4dd48a3-6366-41a3-8c74-9efaa2731288";
//            productModel.productType_number = @1;
//            [testArray addObject:productModel];
//        }
//        model.recommendDimension = testArray;
//        NSMutableArray *courseArray = @[].mutableCopy;
//        for (int i = 0; i < 2; i ++) {
//            TCRecommendProductModel *productModel = [TCRecommendProductModel new];
//            productModel.image = @"https://dss0.baidu.com/73F1bjeh1BF3odCf/it/u=1468756503,2169179468&fm=85&s=7A93F0AED4860EFB12BA040A0300E0DA";
//            productModel.name = @"这是个课程我操哦啊操手抽筋吗开始了解到拉萨节快乐";
//            productModel.itemUseCount = @(100);
//            productModel.price = @(100);
//            productModel.originPrice = @(188);
//            productModel.itemId = @"7ff36a95-d2f6-4e15-84f9-c8a02dbacaa9";
//            productModel.productType_number = @2;
//            [courseArray addObject:productModel];
//        }
//        model.recommendCourse = courseArray;
//        _reportInfo.recommendProductData = model;
        if (success) success();
    } failure:^(NSError *error) {
        if(failure) failure();
    }];
}

- (void)p_continueRequestDataWhenReportCreating {
    _requestCountWhenCreating++;
    if (_requestCountWhenCreating <= 5) {
        [self requestReportDataWithSuccess:_requestSuccess failure:_requestFailure  ifRequstOverUpperLimit:_requestOverLimit];
    } else {
        if (_requestOverLimit) {
            _requestOverLimit();
        }
    }
}

- (NSTimer *)p_startUpDataLoadTimer {
    if (!_dataLoadTimer) {
        @weakObj(self);
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [selfweak p_continueRequestDataWhenReportCreating];
        }];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        _dataLoadTimer = timer;
    }
    return _dataLoadTimer;
}




@end
