//
//  TCMyAccountDataManager.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/20.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "FEBaseModel.h"
#import "TCHTTPService.h"
#import "TCEmoneyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TCMyAccountDataManager : FEBaseModel
@property (nonatomic, strong, nullable) TCEmoneyListModel *emoneyProductList;

@property (nonatomic, strong, nullable) TCMyEmoneyBalanceModel *myEmoneyBalance;
+ (instancetype)sharedInstance;
+ (void)resetData;

- (void)getEmoneyProductListOnSuccess:(void(^)(void))success failure:(void(^)(void))failure;

- (void)getMyEmoneyBalanceOnSuccess:(void(^)(void))success failure:(void(^)(void))failure;
@end

NS_ASSUME_NONNULL_END
