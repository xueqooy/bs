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

- (void)getSearchResultByFilter:(NSString *)filter type:(TCSearchType)type onSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    if (type == BSSearchTypeUniversity) {
        [self searchUniversityByName:filter onSuccess:success failure:failure];
        return;
    } else if (type == BSSearchTypeMajor) {
        [self searchMajorByName:filter onSuccess:success failure:failure];
        return;
    } else if (type == TCSearchTypeArticle) {
        [self searchArticleByName:filter onSuccess:success failure:failure];
    }
    
    
}

- (void)searchArticleByName:(NSString *)name onSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    AVQuery *query = [AVQuery queryWithClassName:@"Article"];
    [query whereKey:@"articleTitle" containsString:name];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSMutableArray *temp = @[].mutableCopy;
        if (error) {
            [HttpErrorManager showErorInfo:error];
            if (failure) failure();
        } else {
            for (AVObject *article in objects) {
                ArticleDetailsModel *articleModel = [[ArticleDetailsModel alloc] initWithAVObject:article];
                [temp addObject:articleModel];
            }
            self.articleResult = temp.copy;
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
