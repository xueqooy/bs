//
//  FENavigationViewController.m
//  smartapp
//
//  Created by lafang on 2018/10/5.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FENavigationViewController.h"
#import "UIImage+Category.h"
#import "UIColor+Category.h"
#import "UIButton+Utils.h"
@interface FENavigationViewController ()<UINavigationControllerDelegate>
@property(nonatomic, strong) UIImage *backImg;


@end

@implementation FENavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeNavigationBarAppearance];
}

- (void)initializeNavigationBarAppearance {
    self.fd_interactivePopDisabled = NO;

    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithDefaultBackground];
        appearance.backgroundColor = UIColor.fe_mainColor;
        appearance.shadowColor = UIColor.clearColor;
        appearance.titleTextAttributes = @{NSFontAttributeName:mFontBold(17),NSForegroundColorAttributeName:UIColor.whiteColor};
        self.navigationBar.standardAppearance = appearance;
        self.navigationBar.scrollEdgeAppearance = appearance;
    } else {
        [self.navigationBar setTintColor:UIColor.fe_mainColor];
        [self.navigationBar setShadowImage:[UIImage new]];
        [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:mFontBold(17),NSForegroundColorAttributeName:UIColor.whiteColor}];
        
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
           if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]){
               statusBar.backgroundColor = [UIColor colorWithHexString:@"ffffff" alpha:0];
               statusBar.alpha = 1;
           }
    }
}


- (UIBarButtonItem *)backButtonItem {
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    if (!_backImg) {
        _backImg = UIImage.fe_navigationBarBackButtonImage ;
    }
    UIImageView *backIconImageView = [[UIImageView alloc] initWithImage:_backImg];
    [backIconImageView sizeToFit];
    [btnBack addSubview:backIconImageView];
    [backIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    [btnBack addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    return backItem;
}

#pragma mark - 监听深色模式

- (void)qmui_themeDidChangeByManager:(QMUIThemeManager *)manager identifier:(__kindof NSObject<NSCopying> *)identifier theme:(__kindof NSObject *)theme {
    [super qmui_themeDidChangeByManager:manager identifier:identifier theme:theme];
    self.backImg = nil;
}

#pragma mark UINavigationControllerDelegate

- (void)popAction:(UIButton *)btn {
    if (_barBackButtonAction) {
        _barBackButtonAction();
        return;
    }
    [self popViewControllerAnimated:YES];
}

- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    NSUInteger count = self.viewControllers.count;
    viewController.hidesBottomBarWhenPushed = count > 0;
    [super pushViewController:viewController animated:animated];
    if (viewController.navigationItem.leftBarButtonItem == nil && count >= 1) {
        viewController.navigationItem.leftBarButtonItem = self.backButtonItem;
    }
}



@end
