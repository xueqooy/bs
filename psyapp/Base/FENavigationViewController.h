//
//  FENavigationViewController.h
//  smartapp
//
//  Created by lafang on 2018/10/5.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FENavigationViewController : UINavigationController

@property (nonatomic, copy) void (^barBackButtonAction)(void);

@end
