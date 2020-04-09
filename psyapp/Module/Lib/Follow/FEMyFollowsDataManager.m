//
//  FEMyFollowsDataManager.m
//  smartapp
//
//  Created by mac on 2019/9/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEMyFollowsDataManager.h"
#import "HttpErrorManager.h"
#import "QSToast.h"
#import "UniversityModel.h"

@implementation FEMyFollowsDataManager
+ (instancetype)sharedManager {
    static FEMyFollowsDataManager *sharedManager ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)loadFollowingDataForType:(FEMyFollowsType)type WithSuccess:(void (^)(BOOL))success ifFailure:(void (^)(void))failure {
    
    NSMutableArray *tempData;
    switch (type) {
        case FEMyFollowsTypeSchool:
            _schoolsData = @[].mutableCopy;
            tempData = _schoolsData;
            break;
        case FEMyFollowsTypeMajor:
            _majorsData = @[].mutableCopy;

            tempData = _majorsData;
            break;
        case FEMyFollowsTypeOccupation:
            _occupationsData = @[].mutableCopy;

            tempData = _occupationsData;
            break;
    }
    
    BSUser *currentUser = BSUser.currentUser;
    AVQuery *query = [AVQuery queryWithClassName:@"LibFollow"];
    [query whereKey:@"userId" equalTo:currentUser.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            if (failure) failure();
            return ;
        }
        AVObject *follow = objects.firstObject;
        self->_followData = follow;
        if (follow) {
            if(type == FEMyFollowsTypeSchool) {
                NSArray *universitys = [follow objectForKey:@"universities"];
                for (NSDictionary *universityDic in universitys) {
                    UniversityModel *universityModel = UniversityModel.new;
                    universityModel.universityId = [universityDic objectForKey:@"universityId"];
                    universityModel.cnName = [universityDic objectForKey:@"cnName"];
                    universityModel.logoUrl = [universityDic objectForKey:@"logoUrl"];
                    universityModel.state = [universityDic objectForKey:@"state"];
                    UniversityBasicInfoModel *basicInfoModel = UniversityBasicInfoModel.new;
                    basicInfoModel.publicOrPrivate = [universityDic objectForKey:@"publicOrPrivate"];
                    basicInfoModel.instituteType = [universityDic objectForKey:@"instituteType"];
                    basicInfoModel.instituteQuality = [universityDic objectForKey:@"instituteQuality"];
                    basicInfoModel.chinaBelongTo = [universityDic objectForKey:@"chinaBelongTo"];
                    universityModel.basicInfo = basicInfoModel;
                    [self->_schoolsData addObject:universityModel];
                }
                
                if (success) success(self->_schoolsData.count <= 0);
              
            } else if(type == FEMyFollowsTypeMajor) {
                self->_majorsData = [follow objectForKey:@"majors"];
                if (success) success(self->_majorsData.count <= 0);
            } else if(type == FEMyFollowsTypeOccupation) {
                self->_occupationsData = [follow objectForKey:@"occupations"];
                if (success) success(self->_occupationsData.count <= 0);
            }
        }
        
    }];
//    [CareerService getMyFollows:[NSString stringWithFormat:@"%li", type] page:1 size:500 success:^(id data) {
//        [QSLoadingView dismiss];
//
//        if (data && [data[@"total"] integerValue] > 0) {
//            NSArray<FollowModel *> *dataModels = [MTLJSONAdapter modelsOfClass:FollowModel.class fromJSONArray:data[@"items"] error:nil];
//            [tempData addObjectsFromArray:dataModels];
//
//            success(NO);
//        } else {
//            if (tempData.count > 0) {
//                success(NO);
//            } else {
//                success(YES);
//
//            }
//        }
//    } failure:^(NSError *error) {
//        [QSLoadingView dismiss];
//        failure();
//        [HttpErrorManager showErorInfo:error showView:[UIApplication sharedApplication].keyWindow];
//    }];
}

//
//- (void)removeFollowingForType:(FEMyFollowsType)type andModel:(FollowModel *)model WithSuccess:(void (^)(BOOL))success ifFailure:(void (^)(void))failure {
//    NSMutableArray *tempData;
//
//    switch (type) {
//        case FEMyFollowsTypeSchool:
//            tempData = _schoolsData;
//            break;
//        case FEMyFollowsTypeMajor:
//            tempData = _majorsData;
//            break;
//        case FEMyFollowsTypeOccupation:
//            tempData = _occupationsData;
//            break;
//    }
    
//    [CareerService careerFollow:model.entityId type:[NSString stringWithFormat:@"%li", type] isFollow:@0 tag:model.tag success:^(id data) {
//        [QSLoadingView dismiss];
//        [QSToast toast:[UIApplication sharedApplication].keyWindow message:@"已取消关注"];
//
//        [tempData removeObject:model];
//
//        if(tempData.count==0){
//            success(YES);
//        } else {
//            success(NO);
//        }
//
//    } failure:^(NSError *error) {
//        [QSLoadingView dismiss];
//        [HttpErrorManager showErorInfo:error showView:[UIApplication sharedApplication].keyWindow];
//        failure();
//    }];
//}

- (BOOL)needLoadDataFor:(FEMyFollowsType)type {
    NSMutableArray *tempData;

    switch (type) {
        case FEMyFollowsTypeSchool:
            tempData = _schoolsData;
            break;
        case FEMyFollowsTypeMajor:
            tempData = _majorsData;
            break;
        case FEMyFollowsTypeOccupation:
            tempData = _occupationsData;
            break;
    }
    
    if (!tempData || tempData.count == 0) {
        return YES;
    } else {
        return NO;
    }
}
@end
