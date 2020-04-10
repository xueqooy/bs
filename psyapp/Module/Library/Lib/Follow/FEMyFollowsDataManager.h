//
//  FEMyFollowsDataManager.h
//  smartapp
//
//  Created by mac on 2019/9/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CareerService.h"
//#import "FollowModel.h"
#import "UniversityModel.h"
typedef NS_ENUM(NSUInteger, FEMyFollowsType) {
    FEMyFollowsTypeSchool = 0,
    FEMyFollowsTypeMajor = 1,
    FEMyFollowsTypeOccupation = 2,
};

@interface FEMyFollowsDataManager : NSObject

@property (nonatomic, strong) NSMutableArray <UniversityModel *>*schoolsData;

@property (nonatomic, strong) NSMutableArray <NSDictionary *>*majorsData;

@property (nonatomic, strong) NSMutableArray <NSDictionary *>*occupationsData;

@property (nonatomic, strong) AVObject *followData;
+ (instancetype)sharedManager;

- (void)loadFollowingDataForType:(FEMyFollowsType)type WithSuccess:(void(^)(BOOL empty))success ifFailure:(void(^)(void))failure;
//- (void)removeFollowingForType:(FEMyFollowsType)type andModel:(FollowModel *)model WithSuccess:(void(^)(BOOL empty))success  ifFailure:(void(^)(void))failure;
- (BOOL)needLoadDataFor:(FEMyFollowsType)type;
@end

