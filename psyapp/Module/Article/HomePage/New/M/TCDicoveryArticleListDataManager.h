//
//  TCDicoveryArticleListDataManager.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/29.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TCStageModel;
@class TCCategroyModel;
NS_ASSUME_NONNULL_BEGIN

@interface TCDicoveryArticleListDataManager : NSObject
@property (nonatomic, copy) NSArray <TCCategroyModel *>*categories;

- (void)getArticleCategoryOnSuccess:(void(^)(void))success failure:(void(^)(void))failure;
@end

NS_ASSUME_NONNULL_END
