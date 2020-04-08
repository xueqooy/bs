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
    if (type == BSSearchTypeUniversity) {
        [self searchUniversityByName:filter onSuccess:success failure:failure];
        return;
    } else if (type == BSSearchTypeMajor) {
        [self searchMajorByName:filter onSuccess:success failure:failure];
        return;

    }
    
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


- (void)searchUniversityByName:(NSString *)name onSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    AVQuery *query = [AVQuery queryWithClassName:@"UniversityLib"];
    [query whereKey:@"cnName" containsString:name];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSMutableArray *temp = @[].mutableCopy;
        if (error) {
            [HttpErrorManager showErorInfo:error];
            if (failure) failure();
        } else {
            for (AVObject *university in objects) {
                UniversityModel *universityModel = UniversityModel.new;
                universityModel.universityId = [university objectForKey:@"universityId"];
                universityModel.cnName = [university objectForKey:@"cnName"];
                universityModel.logoUrl = [university objectForKey:@"logoUrl"];
                universityModel.state = [university objectForKey:@"state"];
                UniversityBasicInfoModel *basicInfoModel = UniversityBasicInfoModel.new;
                basicInfoModel.publicOrPrivate = [university objectForKey:@"publicOrPrivate"];
                basicInfoModel.instituteType = [university objectForKey:@"instituteType"];
                basicInfoModel.instituteQuality = [university objectForKey:@"instituteQuality"];
                basicInfoModel.chinaBelongTo = [university objectForKey:@"chinaBelongTo"];
                universityModel.basicInfo = basicInfoModel;
                [temp addObject:universityModel];
            }
            self.universityResult = temp.copy;
            if (success) success();
        }
    }];
}

- (void)searchMajorByName:(NSString *)name onSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    AVQuery *query = [AVQuery queryWithClassName:@"MajorLib"];
    [query whereKey:@"majorName" containsString:name];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSMutableArray *temp = @[].mutableCopy;
        if (error) {
            [HttpErrorManager showErorInfo:error];
            if (failure) failure();
        } else {
            for (AVObject *major in objects) {
                ProfessionalCategoryModel *majorModel = ProfessionalCategoryModel.new;
                majorModel.majorCode = [major objectForKey:@"majorCode"];
                majorModel.majorName = [major objectForKey:@"majorName"];
                [temp addObject:majorModel];
            }
            self.majorResult = temp.copy;
            if (success) success();
        }
    }];
}
@end
