//
//  UIViewController+Additions.m
//  FlyClip
//
//  Created by SimonYang on 2017/4/13.
//  Copyright © 2017年 tongboshu. All rights reserved.
//

#import "UIViewController+Additions.h"

@implementation UIViewController (Additions)

+ (UIViewController *)recursiveFindCurrentShowViewControllerFromViewController:(UIViewController *)fromVC

{

    if ([fromVC isKindOfClass:[UINavigationController class]]) {

        return [self recursiveFindCurrentShowViewControllerFromViewController:[((UINavigationController *)fromVC) visibleViewController]];

    } else if ([fromVC isKindOfClass:[UITabBarController class]]) {

        return [self recursiveFindCurrentShowViewControllerFromViewController:[((UITabBarController *)fromVC) selectedViewController]];

    } else {

        if (fromVC.presentedViewController) {

            return [self recursiveFindCurrentShowViewControllerFromViewController:fromVC.presentedViewController];

        } else {

            return fromVC;

        }

    }

}

 

/** 查找当前显示的ViewController*/

+ (UIViewController *)getCurrentShowViewController

{

    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;

    UIViewController *currentShowVC = [self recursiveFindCurrentShowViewControllerFromViewController:rootVC];

    return currentShowVC;

}

@end
