//
//  TCUserDataRestter.m
//  
//
//  Created by mac on 2020/3/8.
//

#import "TCUserDataRestter.h"

#import "UCManager.h"

@implementation TCUserDataRestter
//退到登录页时的重置
+ (void)reset1 {
    [UCManager.sharedInstance clearFormalAccount];
//    [TCTestHomePageDataManager resetData];
//    [TCMyAccountDataManager resetData];
//    [[AppSettingsManager sharedInstance] closeEyeCareReminder];
//    [AppSettingsManager sharedInstance].loggedOut = YES;
}
//不退到登录页时（刷新tab）的重置
+ (void)reset2 {

    [UCManager.sharedInstance clearFormalAccount];
//    [TCCourseHomePageDataManager resetData];
//    [TCTestHomePageDataManager resetData];
//    [TCMyAccountDataManager resetData];
}
//游客账号过期充值
+ (void)reset3 {
//    [[FEAudioPlayStateProxy shareProxy] requestToStop];
//    [FEFloatAudioPlayerViewController releaseSharedController];
    [UCManager.sharedInstance clearFormalAccount];
    [UCManager.sharedInstance clearDeviceAccount];
//    [TCCourseHomePageDataManager resetData];
//    [TCTestHomePageDataManager resetData];
//    [TCMyAccountDataManager resetData];
}
@end
