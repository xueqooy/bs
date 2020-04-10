//
//  TCDiscoveryHomepageDataManager.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/29.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCCategroyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TCDiscoveryHomepageDataManager : NSObject
@property (nonatomic, copy) NSArray <TCStageModel *>*stages;
@property (nonatomic, weak) TCStageModel *currentStage;

+ (instancetype)currentInstance;

- (void)getPeriodStagesOnSuccess:(void(^)(void))success failure:(void (^)(void))failure;
@end

NS_ASSUME_NONNULL_END
