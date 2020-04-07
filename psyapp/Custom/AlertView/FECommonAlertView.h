//
//  CommonAlertView.h
//  smartapp
//
//  Created by lafang on 2018/9/14.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEBaseAlertView.h"
//typedef NS_ENUM(NSUInteger, FECommonAlertViewComponent) {
//    FECommonAlertViewComponentTitle = 1 << 0,
//    FECommonAlertViewComponentButtonCancel = 1 << 1,
//    FECommonAlertViewComponentButtonSure = 1 << 2,
//    FECommonAlertViewComponentImage = 1 << 3
//};
typedef void(^FECommonAlertViewResult)(NSInteger index);

@interface FECommonAlertView : FEBaseAlertView

@property (nonatomic,copy) FECommonAlertViewResult resultIndex;

- (void)showCustomAlertView;
- (void)setAttributeTextWithNormalText:(NSString *)text;
- (instancetype)initWithTitle:(NSString *)title leftText:(NSString *)leftText rightText:(NSString *)rightText icon:(UIImage *)icon;//icon没有用


@end
