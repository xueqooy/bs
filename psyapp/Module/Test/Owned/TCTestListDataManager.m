//
//  TCTestListDataManager.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/18.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCTestListDataManager.h"
#import "TCHTTPService.h"
@implementation TCTestListDataManager
- (instancetype)init {
    self = [super init];
    self.list = TCPagedDataManager.new;
    return self;
}

- (instancetype)initWithCategoryId:(NSString *)categoryId {
    self =  [self init];
    self.categoryId = categoryId;
    return self;
}

- (void)getProductListByPeriodStage:(TCPeriodStage)stage isOwn:(NSNumber * _Nullable)isOwn onSuccess:(nonnull void (^)(void))success failure:(nonnull void (^)(void))failure{
    NSNumber *isBest = nil;
    NSString *categoryId = _categoryId;
    if ([_categoryId isEqualToString:TC_PRODUCT_BEST_CATEGORY_ID]) {
        categoryId = nil;
        isBest = @1;
    }
    
    if (isOwn) {
        categoryId = nil;
        isBest = nil;
    }
    _list.dataGetter = ^(TCPagedDataSetter  _Nonnull setter, NSInteger page, NSInteger count) {

        [TCHTTPService getTestProductListByPeriodStage:stage categoryId:categoryId isBest:isBest isOwn:isOwn childId:UCManager.sharedInstance.currentChild.childId page:page size:count onSuccess:^(id data) {
            TCTestProductListModel *list = [MTLJSONAdapter modelOfClass:TCTestProductListModel.class fromJSONDictionary:data error:nil];
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

@implementation TCTestListDataManager (Filter)
static char kAssociatedObjectKey_subCategoryIds;
- (void)setSubCategoryIds:(id)subCategoryIds {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_subCategoryIds, subCategoryIds, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self.list resetData];
}

- (id)subCategoryIds {
    return objc_getAssociatedObject(self, &kAssociatedObjectKey_subCategoryIds);
}


- (void)getFilteredProductListByPeriodStage:(TCPeriodStage)stage onSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    NSString *requestedCategoryId;
    if (self.subCategoryIds == nil || self.subCategoryIds.count == 0) {
        if ([NSString isEmptyString:self.categoryId]) {
            return;
        } else {
            requestedCategoryId = self.categoryId;
        }
    } else {
        NSMutableString *temp = @"".mutableCopy;
        for (NSString *subCategoryId in self.subCategoryIds) {
            [temp appendString:subCategoryId];
            if (self.subCategoryIds.lastObject != subCategoryId) {
                [temp appendString:@","];
            }
        }
        requestedCategoryId = temp;
    }
    NSLog(@"Filter ** %@", requestedCategoryId);
    
    _list.dataGetter = ^(TCPagedDataSetter  _Nonnull setter, NSInteger page, NSInteger count) {

        [TCHTTPService getTestProductListByPeriodStage:stage categoryId:requestedCategoryId isBest:nil isOwn:nil childId:UCManager.sharedInstance.currentChild.childId page:page size:count onSuccess:^(id data) {
            TCTestProductListModel *list = [MTLJSONAdapter modelOfClass:TCTestProductListModel.class fromJSONDictionary:data error:nil];
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
