//
//  TCDiscoverySearchDataManager.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/22.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCDiscoverySearchDataManager.h"
#import "EvaluateService.h"
@interface TCDiscoverySearchDataManager ()
@end

@implementation TCDiscoverySearchDataManager
- (instancetype)init {
    self = [super init];
    self.articleResult = TCPagedDataManager.new;
    self.courseResult = TCPagedDataManager.new;
    self.dimensionResult = TCPagedDataManager.new;
    
    return self;
}
- (void)getSearchResultByFilter:(NSString *)filter type:(TCSearchType)type onSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    @weakObj(self);
    TCPagedDataGetter getter = ^(TCPagedDataSetter _Nonnull setter, NSInteger page, NSInteger count) {
        [EvaluateService getSearchResultByFilter:filter type:type page:page size:count onSuccess:^(id data) {
            TCDiscoverySearchResultModel *result = [MTLJSONAdapter modelOfClass:TCDiscoverySearchResultModel.class fromJSONDictionary:data error:nil];
            if (type == TCSearchTypeArticle) {
                TCArticleSearchResultModel *article = result.article;
                setter(article.total.integerValue, article.items, NO);
            } else if (type == TCSearchTypeCourse) {
                TCCourseSearchResultModel *course = result.course;
                setter(course.total.integerValue, course.items, NO);
            } else {
                TCDimensionSearchResultModel *dimension = result.dimension;
                setter(dimension.total.integerValue, dimension.items, NO);
            }
            if (selfweak.onSearchCompletion) {
                selfweak.onSearchCompletion();
            }
        } failure:^(NSError *error) {
            if (selfweak.onSearchCompletion) {
                selfweak.onSearchCompletion();
            }
            [HttpErrorManager showErorInfo:error];
            setter(0, nil, YES);
        }];

    };
    TCPagedDataManager *manager;
    if (type == TCSearchTypeArticle) {
        manager = self.articleResult;
    } else if (type == TCSearchTypeCourse) {
        manager = self.courseResult;
    } else {
        manager = self.dimensionResult;
    }
    
    manager.dataGetter = getter;
    
    [manager loadDataOnCompletion:^(TCPagedDataManager * _Nonnull manager, BOOL failed) {
        if (failed) {
            if (failure) failure();
        } else {
            if (success) success();
        }
    }];
}


@end
