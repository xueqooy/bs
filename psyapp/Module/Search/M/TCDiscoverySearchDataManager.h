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

#import "UniversityModel.h"
#import "ProfessionalCategoryModel.h"
#import "ArticleDetailsModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef enum TCSearchType {
    TCSearchTypeArticle = 1,
    TCSearchTypeTest = 4,
    TCSearchTypeCourse = 2,
    
    BSSearchTypeUniversity = 10,
    BSSearchTypeMajor = 11
}TCSearchType;

@interface TCDiscoverySearchDataManager : NSObject
//@property (nonatomic, strong) TCPagedDataManager *dimensionResult;
//@property (nonatomic, strong) TCPagedDataManager *courseResult;
//@property (nonatomic, strong) TCPagedDataManager *articleResult;

@property (nonatomic, copy) NSArray <ArticleDetailsModel *>*articleResult;
@property (nonatomic, copy) NSArray <UniversityModel *>*universityResult;
@property (nonatomic, copy) NSArray <ProfessionalCategoryModel *>*majorResult;

- (void)getSearchResultByFilter:(NSString *)filter type:(TCSearchType)type onSuccess:(void(^)(void))success failure:(void(^)(void))failure;

@property (nonatomic, copy) void (^onSearchCompletion)(void);
@end

NS_ASSUME_NONNULL_END
