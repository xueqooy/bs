//
//  TCBannerDataManager.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/29.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCBannerDataManager.h"
#import "TCBannerModel.h"
#import "TCHTTPService.h"
#import "TCCategroyModel.h"
//#import "TCSandBoxHelper.h"

@interface TCBannerDataManager ()
@property (nonatomic, copy) NSSet *bannerAdDisplayRecored;
@end

@implementation TCBannerDataManager
- (instancetype) init {
    self = [super init];
    _undisplayedBannerAds = @{}.mutableCopy;
    self.tab = 0;
    return self;
}

-(void)getBannerOnSuccess:(void (^)(void))success failure:(void (^)(void))failure{
    AVQuery *query = [AVQuery queryWithClassName:@"Banner"];
    _undisplayedBannerAds = [NSMutableSet set];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            [HttpErrorManager showErorInfo:error];
            if (failure) failure();
        } else {
            NSMutableArray *temp = @[].mutableCopy;
            for (AVObject *object in objects) {
                TCBannerModel *banner = [[TCBannerModel alloc] initWithAVObject:object];
                [temp addObject:banner];
                if (banner.includeAd.boolValue) {
                    [self->_undisplayedBannerAds addObject:banner];
                }
            }
            self.banners = temp.copy;
            if (success) success();
        }
    }];

}

- (void)countBannerClick:(NSString *)uniqueId{
    AVQuery *query = [AVQuery queryWithClassName:@"Banner"];
    [query whereKey:@"objectId" equalTo:uniqueId];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        if (object) {
            [object incrementKey:@"click"];
            [object saveInBackground];
            return ;
        }
    }];
    
}


@end
