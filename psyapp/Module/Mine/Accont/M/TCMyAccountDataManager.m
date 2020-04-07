//
//  TCMyAccountDataManager.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/20.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCMyAccountDataManager.h"

@implementation TCMyAccountDataManager
+ (instancetype)sharedInstance {
    static TCMyAccountDataManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}
 
+ (void)resetData {
    [TCMyAccountDataManager sharedInstance].emoneyProductList = nil;
    [TCMyAccountDataManager sharedInstance].myEmoneyBalance = nil;
}

- (void)getEmoneyProductListOnSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    [TCHTTPService getEmoneyProductListOnSuccess:^(id data) {
        self.emoneyProductList = [MTLJSONAdapter modelOfClass:TCEmoneyListModel.class fromJSONDictionary:data error:nil];
        if (success) success();
    } failure:^(NSError *error) {
        [HttpErrorManager showErorInfo:error];
        if (failure) failure();
    }];
}


- (void)getMyEmoneyBalanceOnSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    [TCHTTPService getMyEmoneyBalanceOnSuccess:^(id data) {
        self.myEmoneyBalance = [MTLJSONAdapter modelOfClass:TCMyEmoneyBalanceModel.class fromJSONDictionary:data error:nil];
        if (success) success();
    } failure:^(NSError *error) {
        [HttpErrorManager showErorInfo:error];
        if (failure) failure();
    }];
}
@end
