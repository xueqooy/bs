//
//  FEAppraiseManager.m
//  smartapp
//
//  Created by mac on 2020/1/16.
//  Copyright © 2020 jeyie0. All rights reserved.
//

#import "FEAppraisalManager.h"
#import "EvaluateService.h"


@implementation FEAppraisalManager
- (instancetype)initWithUniqueId:(NSString *)uniqueId type:(FEAppraisalType)type{
    self = [super init];
    self.uniqueId = uniqueId;
    self.type = type;
    return self;
}

- (void)loadAppraisalTitleListDataOnSuccess:(void (^)(void))success onFailure:(void (^)(void))failure {
    [EvaluateService getDimensionEvaluateTitleListWithSuccess:^(id data) {
        self.appraisalTitleListData = [MTLJSONAdapter modelOfClass:FEDimensionEvaluateTitleModel.class fromJSONDictionary:data error:nil];
        if (success) success();
    } failure:^(NSError *error) {
        [HttpErrorManager showErorInfo:error showView:mKeyWindow];
        if (failure) failure();
    }];
}

- (void)loadAppraisalIndexNumberDataOnSuccess:(void (^)(void))success onFailure:(void (^)(void))failure {
     if (self.appraisalTitleListData == nil) {
         @weakObj(self);
         [self loadAppraisalTitleListDataOnSuccess:^{
             [selfweak _loadAppraisalIndexNumberDataOnSuccess:success onFailure:failure];
         } onFailure:failure];
         return;
     }
     [self _loadAppraisalIndexNumberDataOnSuccess:success onFailure:failure];
}

- (void)loadAppraisalItemsDataOnSuccess:(void (^)(void))success onFailure:(void (^)(void))failure {
    if (self.appraisalTitleListData == nil) {
        @weakObj(self);
        [self loadAppraisalTitleListDataOnSuccess:^{
            [selfweak _loadAppraisalItemsDataOnSuccess:success onFailure:failure];
        } onFailure:failure];
        return;
    }
    [self _loadAppraisalItemsDataOnSuccess:success onFailure:failure];
}

- (void)commitAppraisalAtIndex:(NSInteger)idx onComplete:(void (^)(void))complete {
    NSArray<JudgeItemModel *> *itemModels = self.appraisalItemsData.items;
    JudgeItemModel *model = itemModels[4 - idx];
    
    [QSLoadingView  show];
    [EvaluateService commitReportJudge:[model.optionId stringValue] refId:self.uniqueId childId:UCManager.sharedInstance.currentChild.childId success:^(id data) {
        [QSLoadingView dismiss];

        if (complete) {
            complete();
        }
    } failure:^(NSError *error) {
        [HttpErrorManager showErorInfo:error showView:mKeyWindow];
        [QSLoadingView dismiss];
    }];
}

- (void)_loadAppraisalIndexNumberDataOnSuccess:(void (^)(void))success onFailure:(void (^)(void))failure {
    if (self.appraisalTitleListData == nil || self.appraisalTitleListData.items.count == 0) {
        if (failure) failure();
        return;
    }
    NSString *titleId = self._titleId;
    if (!titleId) {
        if (failure) failure();
        return;
    };
    [EvaluateService getDimensionEvaluatesWithTitleId:titleId uniqueId:self.uniqueId success:^(id data) {
        self.appraisalIndexNumberData = [MTLJSONAdapter modelOfClass:FEDimensionEvaluateModel.class fromJSONDictionary:data error:nil];
        if (success) success();
        
    } failure:^(NSError *error) {
        [HttpErrorManager showErorInfo:error showView:mKeyWindow];
        if (failure) failure();
    }];
}

- (void)_loadAppraisalItemsDataOnSuccess:(void (^)(void))success onFailure:(void (^)(void))failure {
    if (self.appraisalTitleListData == nil || self.appraisalTitleListData.items.count == 0) {
        if (failure) failure();
        return;
    }
    NSString *titleId = self._titleId;
    if (!titleId) {
        if (failure) failure();
        return;
    };
  
    [EvaluateService getReportJudge:self.uniqueId type:@(self.type).stringValue childId:UCManager.sharedInstance.currentChild.childId titleId:titleId success:^(id data) {
        if(data){
            self.appraisalItemsData = [MTLJSONAdapter modelOfClass:JudgeModel.class fromJSONDictionary:data error:nil];
            if (success) success();
        }
    } failure:^(NSError *error) {
        [HttpErrorManager showErorInfo:error showView:mKeyWindow];
        if (failure) failure();
    }];
}

- (void)_commitAppraisalAtIndex:(NSInteger)idx onComplete:(void (^)(void))complete {
    NSAssert(self.appraisalItemsData.items != nil && self.appraisalItemsData.items.count == 5, @"评价items数据异常，请确定是否请求items数据");
    NSArray<JudgeItemModel *> *itemModels = self.appraisalItemsData.items;
    JudgeItemModel *model = itemModels[4 - idx];
    
    [QSLoadingView  show];
    [EvaluateService commitReportJudge:[model.optionId stringValue] refId:self.uniqueId childId:UCManager.sharedInstance.currentChild.childId success:^(id data) {
        [QSLoadingView  dismiss];
        if (complete) {
            complete();
        }
    } failure:^(NSError *error) {
        [HttpErrorManager showErorInfo:error showView:mKeyWindow];
        [QSLoadingView dismiss];
    }];
}

- (NSString *)_titleId {
    NSNumber *titleId = nil;
    for (FEDimensionEvaluateTitleItemModel *titleItem in self.appraisalTitleListData.items) {
        if ([titleItem.type isEqualToNumber:@(self.type)]) {
            titleId = titleItem.ID;
            break;
        }
    }
    if (titleId) {
        return titleId.stringValue ;
    }
    return nil;
}

- (NSArray<NSNumber *> *)getFiveScoreData {
    NSMutableArray *fiveScoreData = @[].mutableCopy;
    NSMutableDictionary *dic = @{}.mutableCopy;
    NSInteger total = 0;
    for (FEDimensionEvaluateItemModel *item in self.appraisalIndexNumberData.evaluateList) {
        total += item.itemCount.intValue;
        [dic setObject:item.itemCount forKey:[NSString stringWithFormat:@"%@", item.value]];
    }
    
    
    for (NSInteger i = 1; i <= 5 ; i ++) {
        NSNumber *count = [dic objectForKey:[NSString stringWithFormat:@"%li", i]];
        if (count && total != 0) {
            [fiveScoreData addObject:@(count.floatValue / (float)total)];
        } else {
            [fiveScoreData addObject:@(0)];
        }
    }
    return fiveScoreData;
}

- (BOOL)hasAppraised {
    return [self.appraisalItemsData.isEvaluate integerValue] == 1;
}

- (CGFloat)recommentIndex {
    return self.appraisalIndexNumberData.recommendValue.floatValue;
}

@end
