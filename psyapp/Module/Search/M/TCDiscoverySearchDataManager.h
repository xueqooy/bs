//
//  TCDiscoverySearchDataManager.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/22.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCDiscoverySearchResultModel.h"
#import "TCPagedDataManager.h"
NS_ASSUME_NONNULL_BEGIN
typedef enum TCSearchType {
    TCSearchTypeArticle = 1,
    TCSearchTypeTest = 4,
    TCSearchTypeCourse = 2
}TCSearchType;

@interface TCDiscoverySearchDataManager : NSObject
@property (nonatomic, strong) TCPagedDataManager *dimensionResult;
@property (nonatomic, strong) TCPagedDataManager *courseResult;
@property (nonatomic, strong) TCPagedDataManager *articleResult;
- (void)getSearchResultByFilter:(NSString *)filter type:(TCSearchType)type onSuccess:(void(^)(void))success failure:(void(^)(void))failure;

@property (nonatomic, copy) void (^onSearchCompletion)(void);
@end

NS_ASSUME_NONNULL_END
