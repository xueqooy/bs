//
//  TCDiscoveryHomepageDataManager.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/29.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCDiscoveryHomepageDataManager.h"

static TCDiscoveryHomepageDataManager *instance = nil;
@implementation TCDiscoveryHomepageDataManager
+ (instancetype)currentInstance {
    return instance;
}

- (instancetype)init {
    self  = [super init];
    instance = self;
    return self;
}

+ (instancetype)new {
    TCDiscoveryHomepageDataManager *obj = [super new];
    instance = obj;
    return  instance;
}

- (void)getPeriodStagesOnSuccess:(void (^)(void))success failure:(void (^)(void))failure {
   
}
@end
