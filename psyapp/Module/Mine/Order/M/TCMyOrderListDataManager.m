//
//  TCMyOrderListDataManager.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/20.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCMyOrderListDataManager.h"
#import "TCHTTPService.h"
@implementation TCMyOrderListDataManager
- (instancetype)initWithOrderType:(TCMyOrderType)orderType {
    self = [super init];
    self.type = orderType;
    self.list = TCPagedDataManager.new;
    return self;
}

- (void)getOrderListOnSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    if (self.type == TCMyOrderTypeEmoney) {
        [self getEmoneyTypeOrderListOnSuccess:success failure:failure];
    } else {
        [self getProductTypeOrderListOnSuccess:success failure:failure];
    }
}

- (void)getProductTypeOrderListOnSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    @weakObj(self);
    TCPagedDataGetter getter = ^(TCPagedDataSetter  _Nonnull setter, NSInteger page, NSInteger count) {
        [TCHTTPService getProductOrderRecordByType:(TCProductType)selfweak.type page:page size:count onSuccess:^(id data) {
            NSArray *items = [MTLJSONAdapter modelsOfClass:TCProductOrderRecordModel.class fromJSONArray:data[@"items"] error:nil];
            NSInteger total = [data[@"total"] integerValue];
            
            setter(total, items, NO);
        } failure:^(NSError *error) {
            setter(0, nil, YES);
        }];
    };
    
    self.list.dataGetter = getter;
    [self.list loadDataOnCompletion:^(TCPagedDataManager * _Nonnull manager, BOOL failed) {
        if (failed) {
            if (failure) failure();
        } else {
            if (success) success();
        }
    }];
   
}

- (void)getEmoneyTypeOrderListOnSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    TCPagedDataGetter getter = ^(TCPagedDataSetter  _Nonnull setter, NSInteger page, NSInteger count) {
        [TCHTTPService getEmoneyOrderRecordByPage:page size:count onSuccess:^(id data) {
            NSArray *items = [MTLJSONAdapter modelsOfClass:TCEmoneyOrderRecordModel.class fromJSONArray:data[@"items"] error:nil];
            NSInteger total = [data[@"total"] integerValue];
            setter(total, items, NO);
        } failure:^(NSError *error) {
            setter(0, nil, YES);
        }];
    };
    
    self.list.dataGetter = getter;
    [self.list loadDataOnCompletion:^(TCPagedDataManager * _Nonnull manager, BOOL failed) {
        if (failed) {
            if (failure) failure();
        } else {
            if (success) success();
        }
    }];
}
@end
