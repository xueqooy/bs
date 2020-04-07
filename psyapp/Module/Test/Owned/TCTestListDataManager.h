//
//  TCTestListDataManager.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/18.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCPagedDataManager.h"
#import "TCProductModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TCTestListDataManager : NSObject
@property (nonatomic, strong)  TCPagedDataManager <TCTestProductItemModel *>*list;
@property (nonatomic, copy) NSString *categoryId;
- (instancetype)initWithCategoryId:(NSString *)categoryId;

- (void)getProductListByPeriodStage:(TCPeriodStage)stage isOwn:( NSNumber *_Nullable)isOwn onSuccess:(void (^)(void))success failure:(void (^)(void))failure;
@end

@interface TCTestListDataManager (Filter)
@property (nonatomic, copy, nullable) NSArray <NSString *>* subCategoryIds;
- (void)getFilteredProductListByPeriodStage:(TCPeriodStage)stage onSuccess:(void (^)(void))success failure:(void (^)(void))failure;
@end
NS_ASSUME_NONNULL_END
