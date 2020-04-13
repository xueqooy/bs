//
//  AppSettingsManager.m
//  smartapp
//
//  Created by linjie on 17/11/21.
//  Copyright © 2017年 jeyie0. All rights reserved.
//

#import "AppSettingsManager.h"
#import "EvaluateService.h"
#import "HttpErrorManager.h"
#import "FEVersionUpdateAlertView.h"
#import <StoreKit/StoreKit.h>
#import "FETermsAlertView.h"
@interface AppSettingsManager()


@end

@implementation AppSettingsManager
{
    __weak id reminderDelegate;
    
}

//- (IQKeyboardManager *)keyboardManager {
//    if (!_keyboardManager) {
//        IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
//        
//        keyboardManager.enable = YES; // 控制整个功能是否启用
//        
//        keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
//        
//        keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
//        
//        keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
//        
//        keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
//        
//        keyboardManager.shouldShowTextFieldPlaceholder = YES; // 是否显示占位文字
//        
//      // keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:STWidth(17)]; // 设置占位文字的字体
//        
//        keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
//        
//        _keyboardManager = keyboardManager;
//    }
//    return _keyboardManager;
//}


+ (instancetype)sharedInstance {
    static AppSettingsManager *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (void)showTermsAlertIfCurrentVersionHasNotAgreeWithAgreeExtraHandler:(void (^)(void))extraHandler {
    if (self.hasAgreeTermsInCurrentVersion == NO) {
        FETermsAlertView *termsAlerView = [[FETermsAlertView alloc] init];
        termsAlerView.backgroundTapDisable = YES;
        @weakObj(self);
        termsAlerView.agreeHandler = ^{
            @strongObj(self);
            self.hasAgreeTermsInCurrentVersion = YES;
            if (extraHandler) {
                extraHandler();
            }
        };
        [termsAlerView showWithAnimated:YES];
    }
}

- (BOOL)hasAgreeTermsInCurrentVersion {
    NSString *agreedVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"agree_terms"];
    if (agreedVersion  == nil) {
        return NO;
    } else {
        if ([agreedVersion isEqualToString:mAppVersion]) {
            return YES;
        } else {
            return NO;
        }
    }
}

- (void)setHasAgreeTermsInCurrentVersion:(BOOL)hasAgreeTermsInCurrentVersion {

    if (hasAgreeTermsInCurrentVersion) {
        NSString *currentVersion = mAppVersion;
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"agree_terms"];
    }
    
}


-(void)getVersionUpdateWithCompletion:(void (^)(void))completion {
    if (_alreadyShowVersionUpdateAlertThisRun == YES) {
        if (completion) completion();
        return;
    };
    
    AVQuery *query = [AVQuery queryWithClassName:@"Version"];
    [query orderByDescending:@"createdAt"];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        if (error) {
            [HttpErrorManager showErorInfo:error];
            if (completion) completion();
        } else {
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *appBuild = [infoDictionary objectForKey:@"CFBundleVersion"];
            //本地保存appStore链接
            self.appStoreURL = [object objectForKey:@"update_url"];
            //判断是否有新版本
            if ([[object objectForKey:@"version_code"] integerValue] > [appBuild integerValue]) {
                self.hasNewVersion = YES;
            } else {
                self.hasNewVersion = NO;
            }
            
            //判断是否点击了不再提醒忽略了新版本
            if([[object objectForKey:@"version_code"] integerValue] <= self.ignoredNewVersion){
                if (completion) completion();
                return ;
            }
            
            //判断是否有新版本，有则弹窗提示
            if([[object objectForKey:@"version_code"] integerValue] > [appBuild integerValue]){
                self->_alreadyShowVersionUpdateAlertThisRun = YES;
                FEVersionUpdateAlertView *updateAlert = [[FEVersionUpdateAlertView alloc] initWithLeftButtonTitle:@"不再提醒" rightButtonTitle:@"立即更新" versionName:[object objectForKey:@"version_name"] contentOfUpdate:[StringUtils setupAttributedString:[object objectForKey:@"description"] font:STWidth(14)] picture:[UIImage imageNamed:@"alert_newVersion"]];
                updateAlert.didHideBlock = ^{
                    if (completion) completion();
                };
                updateAlert.resultIndex = ^(NSInteger index) {
                    if(index == 2){
                        NSString *url = [object objectForKey:@"update_url"];
                        if(url && ![url isKindOfClass:[NSNull class]]){
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                            
                        }
                        
                    }else if(index == 1){
                        //新版本忽略
                        self.ignoredNewVersion = [[object objectForKey:@"version_code"] integerValue];
                    }
                };
                [updateAlert showWithAnimated:YES];
            } else {
                
                if (([appBuild integerValue] == [[object objectForKey:@"version_code"] integerValue])) {
                    self.currentVersionName = [object objectForKey:@"version_name"];
                }
                if (completion) completion();
            }
            
        } 
    }];
    

}

- (void)checkUpdateForVersion {
    AVQuery *query = [AVQuery queryWithClassName:@"Version"];
    [query orderByDescending:@"createdAt"];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        if (error) {
            [HttpErrorManager showErorInfo:error];
        } else {
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *appBuild = [infoDictionary objectForKey:@"CFBundleVersion"];
           
            //判断是否有新版本，有则弹窗提示
            if([[object objectForKey:@"version_code"] integerValue] > [appBuild integerValue]){
               
                 FEVersionUpdateAlertView *updateAlert = [[FEVersionUpdateAlertView alloc] initWithLeftButtonTitle:nil rightButtonTitle:@"立即更新" versionName:[object objectForKey:@"version_name"] contentOfUpdate:[StringUtils setupAttributedString:[object objectForKey:@"description"] font:STWidth(14)] picture:[UIImage imageNamed:@"alert_newVersion"]];
               
                 updateAlert.resultIndex = ^(NSInteger index) {
                    if(index == 2){
                        NSString *url = [object objectForKey:@"update_url"];
                        if(url && ![url isKindOfClass:[NSNull class]]){
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                        }
                    }
                };
                [updateAlert showWithAnimated:YES];
            } else {
                [QSToast toast:[UIApplication sharedApplication].keyWindow  message:@"当前已经是最新版本了"];
            }
        }
    }];
}

- (void)versionChanged:(void (^)(BOOL))handler {
    NSString *previousVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"CFBundleVersion"];
    NSString *currentVersion = mAppBuild;
    if ([currentVersion isEqualToString:previousVersion]) {
        if (handler) handler(NO);
    } else {
        if (handler) handler(YES);
        // 将当前的版本号存进沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"CFBundleVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (BOOL)hasShowSlideHintForNextOnAnswer {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"has_show_slide_hint_next"] boolValue];
}

- (void)setHasShowSlideHintForNextOnAnswer:(BOOL)hasShowSlideHintForNextOnAnswer {
    [[NSUserDefaults standardUserDefaults] setBool:hasShowSlideHintForNextOnAnswer forKey:@"has_show_slide_hint_next"];
}

- (BOOL)hasShowSlideHintForCollapseOnList {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"has_show_slide_hint_collapse"] boolValue];
}

- (BOOL)hasShowSlideHintForExpandOnList {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"has_show_slide_hint_expand"] boolValue];
}

- (void)setHasShowSlideHintForCollapseOnList:(BOOL)hasShowSlideHintForCollapseOnList {
    [[NSUserDefaults standardUserDefaults] setBool:hasShowSlideHintForCollapseOnList forKey:@"has_show_slide_hint_collapse"];
}

- (void)setHasShowSlideHintForExpandOnList:(BOOL)hasShowSlideHintForExpandOnList {
    [[NSUserDefaults standardUserDefaults] setBool:hasShowSlideHintForExpandOnList forKey:@"has_show_slide_hint_expand"];
}

- (BOOL)hasShowSlideHintForPreviousOnAnswer {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"has_show_slide_hint_previous"] boolValue];
}

- (void)setHasShowSlideHintForPreviousOnAnswer:(BOOL)hasShowSlideHintForPreviousOnAnswer {
    [[NSUserDefaults standardUserDefaults] setBool:hasShowSlideHintForPreviousOnAnswer forKey:@"has_show_slide_hint_previous"];
}

- (NSInteger)hasShowVersion {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"has_show_version"] integerValue];
}
            
- (void)setHasShowVersion:(NSInteger)hasShowVersion {
    [[NSUserDefaults standardUserDefaults] setInteger:hasShowVersion  forKey:@"has_show_version"];
}

- (NSInteger)ignoredNewVersion {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"new_version"] integerValue];
}

- (void)setIgnoredNewVersion:(NSInteger)ignoredNewVersion {
     [[NSUserDefaults standardUserDefaults] setInteger:ignoredNewVersion forKey:@"new_version"];
}

- (BOOL)hasNewVersion {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"has_new_version"];
}

- (void)setHasNewVersion:(BOOL)hasNewVersion {
    [[NSUserDefaults standardUserDefaults] setBool:hasNewVersion forKey:@"has_new_version"];
}

- (NSString *)currentVersionName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"current_version_name"];
}

- (void)setCurrentVersionName:(NSString *)currentVersionName {
    [[NSUserDefaults standardUserDefaults] setObject:currentVersionName  forKey:@"current_version_name"];
}


- (NSString *)appStoreURL {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"app_store_url"];
}

- (void)setAppStoreURL:(NSString *)appStoreURL {
    [[NSUserDefaults standardUserDefaults] setObject:appStoreURL  forKey:@"app_store_url"];
}


- (void)setPlaySoundFlag:(NSInteger)playSoundFlag {
    [[NSUserDefaults standardUserDefaults] setValue:@(playSoundFlag) forKey:@"playSoundFlag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)playSoundFlag {
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"playSoundFlag"]) {
        return 1;
    }
    return [[[NSUserDefaults standardUserDefaults] valueForKey:@"playSoundFlag"] integerValue];
}


- (NSCache *)navigationImageCache {
    if (!_navigationImageCache) {
        _navigationImageCache = [[NSCache alloc] init];
    }
    return _navigationImageCache;
}


///应用内评价相关
static NSString * const runIncrementerSetting = @"runCount";
static NSString * const reviewDisplayedCountIncrementerSetting = @"reviewDisplayedCount";

static NSInteger const runCountFactor = 6;
- (void)incremnetAppRunCount {
    NSInteger runCount = [self getRunCount];
    [[NSUserDefaults standardUserDefaults] setObject:@(runCount + 1) forKey:runIncrementerSetting];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)getRunCount {
    NSNumber *runCountNumber = [[NSUserDefaults standardUserDefaults] objectForKey:runIncrementerSetting];
    NSInteger runCount = 0;
    if (runCountNumber != nil) {
        runCount = [runCountNumber integerValue];
    }
    return runCount;
}

- (void)incremnetReviewDisplayedCount {
    NSInteger displayedCount = [self getReviewDisplayedCount];
    [[NSUserDefaults standardUserDefaults] setObject:@(displayedCount + 1) forKey:reviewDisplayedCountIncrementerSetting];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)getReviewDisplayedCount {
    NSNumber *displayedCountNumber = [[NSUserDefaults standardUserDefaults] objectForKey:reviewDisplayedCountIncrementerSetting];
    NSInteger displayedCount = 0;
    if (displayedCountNumber != nil) {
        displayedCount = [displayedCountNumber integerValue];
    }
    return displayedCount;
}

- (void)showReviewIfMetCondition {
    NSInteger runCount = [self getRunCount];
  //  NSInteger reviewDisplayedCount = [self getReviewDisplayedCount];

    if (0 == runCount % runCountFactor && NO == _hasShownOnThisRun) {
        if (@available(iOS 10.3, *)) {
            [SKStoreReviewController requestReview];
            [self incremnetReviewDisplayedCount];
            self.hasShownOnThisRun = YES;
        }
    }
}

/////已获得的内容提示
//- (void)getAcquiredContentWithComplete:(void(^)(NSString *courseContent, NSString *evaluationContent))complete {
//    __block NSString *courseContent = @"";
//    __block NSString *evaluationContent = @"";
//    [FECourseManager getUserOwnerCoursesWithComplete:^(NSString *content) {
//        courseContent = content;
//        [EvaluationManager getUserOwnerEvaluationsWithComplete:^(NSString *content) {
//            evaluationContent = content;
//            
//            if (complete) {
//                complete(courseContent, evaluationContent);
//            }
//        }];
//    }];
//}

//- (void)showAcquiredContentAlertIfFirstLogin {
//    if (_firstLoginFlag) {
//        @weakObj(self);
//        [self getAcquiredContentWithComplete:^(NSString *courseContent, NSString *evaluationContent) {
//            GCD_ASYNC_MAIN(^{
//                FEAcquiredContentAlertView *alertView = [[FEAcquiredContentAlertView alloc] initWithEvaluationContent:evaluationContent courseContent:courseContent];
//                alertView.resultIndex = ^(NSInteger index) {
//                    if (0 == index) {
//                        [[FEViewControllerManager sharedInstance].mainTabBarController setSelectedIndex:2];
//                    } else {
//                        [[FEViewControllerManager sharedInstance].mainTabBarController setSelectedIndex:1];
//                    }
//                };
//                [alertView showWithAnimated:YES];
//                selfweak.firstLoginFlag = NO;
//            });
//            
//        }];
//    }
//}
@end
