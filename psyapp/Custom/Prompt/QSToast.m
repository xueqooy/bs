//
//  QSToast.m
//  app
//
//  Created by linjie on 17/3/11.
//  Copyright © 2017年 jeyie0. All rights reserved.
//

#import "QSToast.h"
#import "MBProgressHUD.h"
#import "UIColor+Category.h"
#define DURATION_DEFAULT  1

@implementation QSToast
+(void)toastWithMessage:(NSString *)msg duration:(CGFloat)time {
    [self toast:[UIApplication sharedApplication].keyWindow message:msg offset:CGPointMake(0, 100)  duration:time];
}

+ (void)toastWithMessage:(NSString *)msg {
    [self toast:[UIApplication sharedApplication].keyWindow  message:msg];
}

+ (void) toast:(UIView *)fromView message:(NSString *)msg {
    [self toast:fromView message:msg offset:CGPointMake(0, 100)  duration:DURATION_DEFAULT];
}

+ (void)toast:(UIView *)fromView offset:(CGPoint)offset message:(NSString *)msg {
    [self toast:fromView message:msg offset:offset duration:DURATION_DEFAULT];
}

+ (void) toast:(UIView *)fromView message:(NSString *)msg offset:(CGPoint)offset duration:(CGFloat)time  {
    if (fromView == nil) {
        mLog(@"Toast: superView为nil，msg = %@", msg);
        return;
    };
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:fromView];
    
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.bezelView.color = [UIColor colorWithHexString:@"#000000" alpha:0.7];
    HUD.offset = offset;
    
    [fromView addSubview:HUD];
    HUD.label.numberOfLines = 0;
    
    HUD.label.text = msg;
    HUD.mode = MBProgressHUDModeText;
    HUD.label.textColor = [UIColor whiteColor];
    

   
    
    [HUD showAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD removeFromSuperview];
    });
}


@end
