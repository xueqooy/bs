//
//  FEMainViewController.m
//  smartapp
//
//  Created by lafang on 2018/8/17.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

//#import "TCDiscoveryHomepageViewController.h"

#import "FEMainViewController.h"
#import "FENavigationViewController.h"
#import "PAHomeViewController.h"

#import "PAMineViewController.h"
#import "PALibViewController.h"
//#import "FETabBar.h"
#import "FECommonAlertView.h"

//#import "UserService.h"
//#import "TCHTTPService.h"
@interface FEMainViewController ()  //<FEEyeCareReminderDelegate>
//@property (nonatomic, weak) TCDiscoveryHomepageViewController *discoveryViewController;

@end

@implementation FEMainViewController

- (void)dealloc {
    NSLog(@"%@ Released", NSStringFromClass(self.class) );
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITextField appearance] setTintColor:UIColor.fe_mainColor];
    [[UITabBar appearance] setBarTintColor:UIColor.fe_contentBackgroundColor];
    [UITabBar appearance].translucent = YES;
    
    [self initTabBar];
    [self initViewControllers];
    [self initObserver];

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    @weakObj(self);

//    if (!_hasShownTerms) {
//        if ([AppSettingsManager sharedInstance].hasAgreeTermsInCurrentVersion == NO) {
//            //判断是否需要条款弹窗
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [[AppSettingsManager sharedInstance] showTermsAlertIfCurrentVersionHasNotAgreeWithAgreeExtraHandler:^{
//                    [[AppSettingsManager sharedInstance] getVersionUpdateWithCompletion:^{
//                        @strongObj(self);
//                        if (self) {
//                            [self.discoveryViewController startDisplayBannerAd];
//                            self->_hasDisplayBannerAd = YES;
//                        }
//                    }];
//                }];
//            });
//            
//            return;
//        }
//        _hasShownTerms = YES;
//    }
//    if (!_hasCheckVersion) {
//        _hasCheckVersion = YES;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [[AppSettingsManager sharedInstance] getVersionUpdateWithCompletion:^{
//                @strongObj(self);
//                if (self) {
//                    [self.discoveryViewController startDisplayBannerAd];
//                    self->_hasDisplayBannerAd = YES;
//                }
//            }]; 
//        });
//        return;
//    }
//    
//    if (_hasDisplayBannerAd == NO) {
//        [self.discoveryViewController startDisplayBannerAd];
//    }
}

- (void)initTabBar {
//    FETabBar *tabBar = [[FETabBar alloc] init];
//    UIView *topLine = [UIView new];
//    topLine.backgroundColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSString * _Nullable identifier, __kindof NSObject * _Nullable theme) {
//        if ([identifier isEqualToString:FEThemeConfigureDarkIdentifier]) {
//            return UIColor.fe_backgroundColor;
//        } else {
//            return UIColor.fe_separatorColor;
//        }
//    }];
//    [tabBar addSubview:topLine];
//    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.equalTo(tabBar);
//        make.height.mas_equalTo(0.5);
//    }];
//    [self setValue:tabBar forKey:@"tabBar"];
    //设置选中颜色再iOS13之后，页面切换之后会使选中颜色变成系统默认颜色 ，故直接设置tintColor
    if (@available(iOS 10.0,*)) {
        [[UITabBar appearance] setUnselectedItemTintColor:UIColor.fe_auxiliaryTextColor];
//              tabBar.tintColor = UIColor.fe_textColorHighlighted;
        [[UITabBar appearance] setTintColor:UIColor.fe_textColorHighlighted];
    } else {
        [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:UIColor.fe_auxiliaryTextColor} forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:UIColor.fe_textColorHighlighted} forState:UIControlStateSelected];
    }
}

- (void)initViewControllers {
//    TESTViewController *testVC = TESTViewController.new;
//    TCDiscoveryHomepageViewController *discoveryViewController = TCDiscoveryHomepageViewController.new;
//    self.discoveryViewController = discoveryViewController;
    PALibViewController *libViewController = PALibViewController.new;
    PAHomeViewController *testHomePageViewController = PAHomeViewController.new;

    PAMineViewController *mineHomePageViewController = PAMineViewController.new;
    
    NSMutableArray *viewControllers =@[].mutableCopy;
//    [viewControllers addObject:[self createNavigationControllerWithRootViewController:discoveryViewController title:@"阅读" index:0]];
    [viewControllers addObject:[self createNavigationControllerWithRootViewController:libViewController title:@"资料" index:0]];
    [viewControllers addObject:[self createNavigationControllerWithRootViewController:testHomePageViewController title:@"测评" index:1]];
    [viewControllers addObject:[self createNavigationControllerWithRootViewController:mineHomePageViewController title:@"我的" index:2]];
//    [viewControllers addObject:[self createNavigationControllerWithRootViewController:test title:@"测试" index:4]];
    self.viewControllers = viewControllers;
    self.selectedIndex = 0;
}

- (void)initObserver {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(switchTab:) name:nc_main_tab_switch object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(initViewControllers) name:nc_main_tab_reload object:nil];
}

- (void)switchTab:(NSNotification *)notification {
    NSDictionary *info = notification.object;
    NSInteger tabIndex = [info[@"tab_index"] integerValue];
    if (self.viewControllers.count > tabIndex) {
        [self setSelectedIndex:tabIndex];
    }
}

- (UINavigationController *)createNavigationControllerWithRootViewController:(UIViewController *)root title:(NSString *)title index:(NSInteger) index{
    FENavigationViewController *navigationController = [[FENavigationViewController alloc] initWithRootViewController:root];
    NSString *itemImageName;
    NSString *itemImageActiveName;
    switch (index) {
        case 0:
            itemImageName = @"tab_discovery";
            itemImageActiveName = @"tab_discovery_active";

            break;
        case 1:
            itemImageName = @"tab_course";
            itemImageActiveName = @"tab_course_active";
            break;
        case 2:
            itemImageName = @"tab_test";
            itemImageActiveName = @"tab_test_active";

            break;
        case 3:
            itemImageName = @"tab_mine";
            itemImageActiveName = @"tab_mine_active";

            break;
        default:
            break;
    }
    
    UIImage *img = [[UIImage imageNamed:itemImageName]
                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *imgActive = [[UIImage imageNamed:itemImageActiveName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *barItem = UITabBarItem.new;
    barItem.title = title;
    barItem.image = img;
    barItem.selectedImage = imgActive;
    navigationController.tabBarItem = barItem;
    return navigationController;
}

//- (void)fe_eyeCareReminderWillPresentNotificationWithSetter:(FEEyeCareSetter *)setter {
//    FECommonAlertView *alert = [[FECommonAlertView alloc] initWithTitle:setter.body leftText:@"不了,谢谢" rightText:@"开启" icon:nil];
//    alert.resultIndex = ^(NSInteger index) {
//        if (index == 2) {
//            [AppSettingsManager sharedInstance].eyeCareFlag = YES;
//            [IMXEventPoster postEventName:nc_setting_eyecare_on object:nil forceMain:YES];
//        }
//    };
//    [alert showCustomAlertView];
//}
@end

