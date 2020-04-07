//
//  QSToast.h
//  app
//
//  Created by linjie on 17/3/11.
//  Copyright © 2017年 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface QSToast : NSObject
+ (void)toastWithMessage:(NSString *)msg duration:(CGFloat)time;
+ (void)toastWithMessage:(NSString *)msg;
+ (void)toast:(UIView *)fromView  message:(NSString *)msg;
+ (void)toast:(UIView *)fromView  offset:(CGPoint)offset message:(NSString *)msg;
+ (void)toast:(UIView *)fromView  message:(NSString *)msg offset:(CGPoint)offset duration:(CGFloat)time;
@end
