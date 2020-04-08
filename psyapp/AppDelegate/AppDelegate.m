//
//  AppDelegate.m
//  psyapp
//
//  Created by mac on 2020/3/10.
//  Copyright © 2020 cheersmind. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Theme.h"
#import "AppDelegate+TCStore.h"
#import "TCAutoLoginManager.h"
#import "TCNetworkReachabilityHelper.h"

#import "FELoginViewController.h"
#import "PAHomeViewController.h"
#import "TCLaunchPlaceholderViewController.h"
#import "FEMainViewController.h"

#import <AVOSCloud/AVOSCloud.h>

@interface AppDelegate ()

@end

@implementation AppDelegate  {
    BOOL _didLaunch;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor whiteColor];
    [self initRootSwithObserver];
    [self initRootViewController];

    [[AppSettingsManager sharedInstance] incremnetAppRunCount];

    //在开始网络监听前开启处理设备账号自动登录
    [UCManager startHandlingDeviceAutoLoginWhenNetworkingRestore];
    [TCNetworkReachabilityHelper startMonitoring];
    
    //AVOSCloud
    [BSUser registerSubclass];
    [AVOSCloud setApplicationId:@"G12ODkXnq7Dt1HO3HIEWaYPy-gzGzoHsz" clientKey:@"MLIGItCQyxmWyx0XlWItDLxE" serverURLString:@"https://g12odkxn.lc-cn-n1-shared.com"];
    return YES;
}

- (void)initRootViewController {
    //占位
    _window.rootViewController = [TCLaunchPlaceholderViewController new];
    [_window makeKeyAndVisible];
        
    [NSNotificationCenter.defaultCenter postNotificationName:nc_window_root_switch object:WINDOW_ROOT_MAIN];
//    [TCAutoLoginManager startAutoLoginOnPermit:^{
//        [NSNotificationCenter.defaultCenter postNotificationName:nc_window_root_switch object:WINDOW_ROOT_MAIN];
//    } prohibition:^{
//        [NSNotificationCenter.defaultCenter postNotificationName:nc_window_root_switch object:WINDOW_ROOT_MAIN];
//    }];
    
}

- (void)startLaunchingAnimation {
    _didLaunch = YES;
    UIWindow *window = self.window;
    UIView *launchScreenView = [[NSBundle mainBundle] loadNibNamed:@"LaunchScreen" owner:self options:nil].firstObject;
    launchScreenView.frame = window.bounds;
    [window addSubview:launchScreenView];
    
    UIImageView *backgroundImageView = launchScreenView.subviews[0];
    UIImageView *textImageView = launchScreenView.subviews[1];
    UIImageView *iconImageView = launchScreenView.subviews[2];
    
    UIView *maskView = [[UIView alloc] initWithFrame:launchScreenView.bounds];
    maskView.backgroundColor = UIColor.whiteColor;
    [launchScreenView insertSubview:maskView belowSubview:backgroundImageView];
    [launchScreenView layoutIfNeeded];
    
    [UIView animateWithDuration:.15 delay:0.9 options:QMUIViewAnimationOptionsCurveOut animations:^{
        [launchScreenView layoutIfNeeded];
        textImageView.alpha = 0.0;
        iconImageView.alpha = 0;
    } completion:nil];
    [UIView animateWithDuration:0.3 delay:0.9 options:UIViewAnimationOptionCurveEaseOut animations:^{
        maskView.alpha = 0;
        backgroundImageView.alpha = 0;
    } completion:^(BOOL finished) {
        [launchScreenView removeFromSuperview];
    }];
}

- (void)initRootSwithObserver {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(switchRootViewController:) name:nc_window_root_switch object:nil];
}

- (void)switchRootViewController:(NSNotification *)notification {
    NSNumber *page = (NSNumber *)notification.object;
   if ([page isEqualToNumber:WINDOW_ROOT_LOGIN]){
        FENavigationViewController *loginNavigaitionController = [[FENavigationViewController alloc] initWithRootViewController:[FELoginViewController new]];
        loginNavigaitionController.modalPresentationStyle = UIModalPresentationFullScreen;
        [QMUIHelper.visibleViewController presentViewController:loginNavigaitionController animated:NO completion:nil];
    } else if ([page isEqualToNumber:WINDOW_ROOT_MAIN]) {
        FEMainViewController *mainViewController = FEMainViewController.new;
        _window.rootViewController = mainViewController;
    }
    if (_didLaunch == NO) {
        [self startLaunchingAnimation];
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
 
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAll;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
   
}

- (void)applicationWillTerminate:(UIApplication *)application {
}


@end
