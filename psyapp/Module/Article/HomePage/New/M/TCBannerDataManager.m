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
    [self getBannerAdDisplayRecord];
    self.tab = 0;
    return self;
}

-(void)getBannerForStage:(TCStageModel *)stage onSuccess:(void (^)(void))success failure:(void (^)(void))failure{
//    [TCHTTPService getBannersByStage:stage.code.integerValue showTab:self.tab onSuccess:^(id data) {
//        self.banners = [MTLJSONAdapter modelsOfClass:TCBannerModel.class fromJSONArray:data[@"items"] error:nil];
//        [self getUndisplayedBannerAdsForStageCode:stage.code];
//        if (success) success();
//    } failure:^(NSError *error) {
//        [HttpErrorManager showErorInfo:error];
//        if (failure) failure();
//    }];
}

- (void)getUndisplayedBannerAdsForStageCode:(NSString *)code {
    NSSet *set = [_undisplayedBannerAds objectForKey:code];
    if (set) { 
        return;
    }
    NSMutableSet *mutableSet = [NSMutableSet set];
    for (TCBannerModel *banner in self.banners) {
        if (banner.includeAd.boolValue) {
            if (NO == [self hasDisplayBannerAd:banner.uniqueId]) {
                [mutableSet addObject:banner];
            }
        }
    }
    if (mutableSet) {
        [_undisplayedBannerAds setObject:mutableSet forKey:code];
    }
}

- (void)displayedBannerAdModel:(TCBannerModel *)model forStageCode:(nonnull NSString *)code{
    NSMutableSet *set = [_undisplayedBannerAds objectForKey:code];
    if (set) {
        NSMutableSet *temp = set.mutableCopy;
        for (TCBannerModel *m in temp.allObjects) {
            if ([model.uniqueId isEqualToNumber:m.uniqueId]) {
                [set removeObject:m];
                break;
            }
        }
    }
    [self saveBannerAdDisplay:model.uniqueId writeToFile:YES];
}

- (void)countBannerClick:(NSNumber *)uniqueId{
    if (uniqueId == nil || uniqueId.stringValue == nil) return;
//    [TCHTTPService putDiscoveryBannerClickById:uniqueId.stringValue onSuccess:^(id data) {
//        mLog(@"banner-click: 统计成功");
//    } failure:^(NSError *error) {
//        mLog(@"banner-click: 统计失败");
//    }];
}

- (BOOL)hasDisplayBannerAd:(NSNumber *)uniqueId {
    if (uniqueId == nil || uniqueId.stringValue == nil) return NO;
    if (_bannerAdDisplayRecored == nil) {
        return NO;
    } else {
        for (NSString *savedUniqueId in _bannerAdDisplayRecored.allObjects) {
            if ([savedUniqueId isEqualToString:uniqueId.stringValue]) {
                return YES;
            }
        }
        return NO;
    }
}

- (void)getBannerAdDisplayRecord {
//    NSFileManager *fileManager =NSFileManager.defaultManager;
//    NSError *error = nil;
//    NSArray *fileNameArray = [fileManager contentsOfDirectoryAtPath:TCSandBoxHelper.bannerAdDisplayRecordFilePath error:&error];
//    if (error == nil) {
//        for (NSString *name in fileNameArray) {
//            if ([name isEqualToString:self.bannerAdDisplayRecordFileName]) {
//                NSString *filePath = [NSString stringWithFormat:@"%@/%@", TCSandBoxHelper.bannerAdDisplayRecordFilePath, name];
//                mLog(@"banner-ad:找到文件路径");
//                NSArray *temp = [NSArray arrayWithContentsOfFile:filePath];
//                if (temp) {
//                    _bannerAdDisplayRecored = [NSSet setWithArray:temp.copy] ;
//                    mLog(@"banner-ad:读取数据成功-%lu", (unsigned long)_bannerAdDisplayRecored.count);
//                }
//                return;
//            }
//        }
//    }
}



- (void)saveBannerAdDisplay:(NSNumber *)uniqueId writeToFile:(BOOL)writeToFile {
    
    void (^writeToFileBlock)(void);
    if (writeToFile) {
        @weakObj(self);
        writeToFileBlock = ^{
            @strongObj(self);
            NSString *savePath = self.bannerAdDisplayRecordSavePath;
            NSSet *temp = self.bannerAdDisplayRecored.copy;
            if(temp != nil) {
                BOOL result =  [temp.allObjects writeToFile:savePath atomically:YES];
                mLog(@"banner-temp    __NSSingleObjectSetI *    0x282a20440    0x0000000282a20440ad:%@记录%@",uniqueId, result? @"成功" : @"失败");
            }
        };
    }
    
    if (uniqueId == nil || uniqueId.stringValue == nil) {
        if (writeToFileBlock) writeToFileBlock();
        return;
    };
    if (_bannerAdDisplayRecored == nil) {
        _bannerAdDisplayRecored = [NSSet setWithObject:uniqueId.stringValue];
    } else{
        _bannerAdDisplayRecored = [_bannerAdDisplayRecored setByAddingObject:uniqueId.stringValue];
    }
    if (writeToFileBlock) writeToFileBlock();
}

- (NSString *)bannerAdDisplayRecordSavePath {

//    NSString *savePath = [NSString stringWithFormat:@"%@/%@", TCSandBoxHelper.bannerAdDisplayRecordFilePath, self.bannerAdDisplayRecordFileName];
//    return savePath;
    return nil;
}

- (NSString *)bannerAdDisplayRecordFileName {
    NSString *userId = UCManager.sharedInstance.userInfo.userId.stringValue;
    if (userId == nil) {
        userId = @"vistor";
    }
    return [NSString stringWithFormat:@"%@.xml", userId];
}

@end
