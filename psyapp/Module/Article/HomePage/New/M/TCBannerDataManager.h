//
//  TCBannerDataManager.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/29.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@class TCBannerModel;
@class TCStageModel;
@interface TCBannerDataManager : NSObject
@property (nonatomic, assign) NSInteger tab; //0 by default
@property(nonatomic, strong) NSArray<TCBannerModel *> *banners;
@property (nonatomic, copy) NSMutableDictionary <NSString * , NSMutableSet <TCBannerModel *> *> *undisplayedBannerAds;

- (void)getBannerOnSuccess:(void (^)(void))success failure:(void (^)(void))failure;


- (void)displayedBannerAdModel:(TCBannerModel *)model forStageCode:(NSString *)code;
- (void)countBannerClick:(NSString *)uniqueId;
- (BOOL)hasDisplayBannerAd:(NSNumber *)uniqueId;
- (void)saveBannerAdDisplay:(NSNumber * _Nullable)uniqueId writeToFile:(BOOL)writeToFile;
@end

NS_ASSUME_NONNULL_END
