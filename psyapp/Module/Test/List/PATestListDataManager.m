//
//  PATestListDataManager.m
//  psyapp
//
//  Created by mac on 2020/3/14.
//  Copyright © 2020 cheersmind. All rights reserved.
//

#import "PATestListDataManager.h"
#import "PATestCategoryManager.h"
#import "TCHTTPService.h"
#import "TCProductModel.h"
@implementation PATestListDataManager {
    NSString *_categoryId;
}
- (instancetype)init {
    self = [super init];
    self.list = TCPagedDataManager.new;
    self.list.increment = 15;
    return self;
}

- (void)setStageCode:(NSString *)stageCode {
    _stageCode = stageCode;
    if (_categoryName != nil) {
        _categoryId = [PATestCategoryManager.sharedInstance getCategoryIdForStageCode:_stageCode categoryName:_categoryName];
    };
}

- (void)setCategoryName:(NSString *)categoryName {
    _categoryName = categoryName;
    if (_stageCode != nil) {
        _categoryId = [PATestCategoryManager.sharedInstance getCategoryIdForStageCode:_stageCode categoryName:_categoryName];
    };
}


- (void)getProductListOnSuccess:(nonnull void (^)(void))success failure:(nonnull void (^)(void))failure{
    NSString *categoryId = _categoryId;
    NSInteger stage = _stageCode.integerValue;
    @weakObj(self);
    _list.dataGetter = ^(TCPagedDataSetter  _Nonnull setter, NSInteger page, NSInteger count) {

        [TCHTTPService getTestProductListByPeriodStage:stage categoryId:categoryId isBest:nil isOwn:nil childId:UCManager.sharedInstance.currentChild.childId page:page size:count onSuccess:^(id data) {
            TCTestProductListModel *list = [MTLJSONAdapter modelOfClass:TCTestProductListModel.class fromJSONDictionary:data error:nil];
            selfweak.loaded = YES;
            setter(list.total.integerValue, list.items, NO);
        } failure:^(NSError *error) {
            [HttpErrorManager showErorInfo:error];
            setter(0, nil, YES);
        }];
    };
    
    [_list loadDataOnCompletion:^(TCPagedDataManager * _Nonnull manager, BOOL failed) {
        if (failed) {
            if (failure) failure();
        } else {
            if (success) success();
        }
    }];
}
@end
