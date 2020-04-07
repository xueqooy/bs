//
//  AppSettingsManager.h
//  smartapp
//
//  Created by linjie on 17/11/21.
//  Copyright © 2017年 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <IQKeyboardManager.h>

@interface AppSettingsManager : NSObject


//@property(nonatomic, weak) IQKeyboardManager *keyboardManager;
@property(nonatomic, assign) NSInteger playSoundFlag;

@property (nonatomic, assign) BOOL hasShowSlideHintForPreviousOnAnswer;//判断答题页是否已经显示过上一提滑动提示
@property (nonatomic, assign) BOOL hasShowSlideHintForNextOnAnswer;//判断答题页是否已经显示过下一提滑动提示

@property (nonatomic, assign) BOOL hasShowSlideHintForCollapseOnList;//测评列表滑动提示
@property (nonatomic, assign) BOOL hasShowSlideHintForExpandOnList;

//版本
//@property (nonatomic, assign) NSInteger hasShowVersion;
@property (nonatomic, assign) NSInteger ignoredNewVersion;
@property (nonatomic, assign) BOOL hasNewVersion;
@property (nonatomic, copy) NSString *currentVersionName;
@property (nonatomic, copy) NSString *appStoreURL;



@property (nonatomic, strong) NSCache *navigationImageCache;
+ (instancetype)sharedInstance;


/**
服务条款和隐私协议
 */
//当前服务协议科隐私协议条款是否已经同意
@property (nonatomic, assign) BOOL hasAgreeTermsInCurrentVersion;
- (void)showTermsAlertIfCurrentVersionHasNotAgreeWithAgreeExtraHandler:(void (^)(void))extraHandler;

/**
 已获取的内容提示（测评、课程）
 */
@property (nonatomic, assign) BOOL firstLoginFlag;
//- (void)showAcquiredContentAlertIfFirstLogin;

/**
 版本更新
 */
- (void)getVersionUpdate;
@property (nonatomic, assign) BOOL alreadyShowVersionUpdateAlertThisRun ;
- (void)checkUpdateForVersion;
- (void)versionChanged:(void (^)(BOOL changed))handler;
/**
 统计启动次数,作评价判断
 */
@property (nonatomic, assign) BOOL hasShownOnThisRun;
- (void)incremnetAppRunCount;
- (void)showReviewIfMetCondition;



@end
