//
//  TCDiscoveryRecommendDataManager.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/29.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCDiscoveryRecommendDataManager.h"
#import "TCTestListDataManager.h"
@implementation TCDiscoveryRecommendDataManager {
    TCTestListDataManager *_listManager;
}

- (instancetype)init {
    self = [super init];
    _listManager = [[TCTestListDataManager alloc] initWithCategoryId:TC_PRODUCT_BEST_CATEGORY_ID];
    _listManager.list.increment = 4;
    return self;
}

- (void)resetData {
    self.models = nil;
    [_listManager.list resetData];
}

- (void)getRecommendDataByStage:(TCStageModel *)stage onSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    @weakObj(_listManager);
    @weakObj(self);
    [_listManager getProductListByPeriodStage:stage.code.integerValue isOwn:@0 onSuccess:^{
        if (_listManagerweak.list.currentCount > 4) {
            selfweak.models = [_listManagerweak.list.data objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 4)]];
        } else {
            selfweak.models = _listManagerweak.list.data;
        }
        if (success) success();
    } failure:^{
        if (failure) failure();
    }];
}
@end
