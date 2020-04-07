//
//  FEBaseViewController.h
//  smartapp
//
//  Created by lafang on 2018/8/17.
//  Copyright © 2018年 jeyie0. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FENavigationViewController.h"


@interface FEBaseViewController : UIViewController

@property(nonatomic,strong) UIColor *navigationBarColor;

@property (nonatomic, strong) UIImage *navigationBarImage;

@property (nonatomic, assign) BOOL navigationBarShadowHidden;

@property (nonatomic, assign) BOOL fullScreenPopGestureEnable;

@property (nonatomic, weak) FENavigationViewController *fe_navigaitionViewController;


- (void)showLeftTitle:(NSString *)title;


- (void)addDoubleClickGestureForNavigationBarWithHandler:(void(^)(void))handler andTitle:(NSString *)title;

@end
