//
//  TCDiscoveryRecommendDataManager.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/29.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCProductModel.h"
#import "TCCategroyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TCDiscoveryRecommendDataManager : NSObject
@property (nonatomic, copy, nullable) NSArray <TCTestProductItemModel *>*models;
- (void)getRecommendDataByStage:(TCStageModel *)stage onSuccess:(void(^)(void))success failure:(void(^)(void))failure;

- (void)resetData;
@end

NS_ASSUME_NONNULL_END
