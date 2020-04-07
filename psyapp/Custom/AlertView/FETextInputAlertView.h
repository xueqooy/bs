//
//  FETextInputAlertView.h
//  smartapp
//
//  Created by mac on 2019/8/27.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseAlertView.h"



@interface FETextInputAlertView : FEBaseAlertView
typedef void(^FETextInputAlertViewResultHandler)(BOOL isConfirm, NSString *content);
typedef void(^FETextInputAlertViewCaptchaTouchedHandler)();
@property (nonatomic, copy) FETextInputAlertViewResultHandler result;
@property (nonatomic, copy) FETextInputAlertViewCaptchaTouchedHandler touch;
- (void)show;
- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder cancleText:(NSString *)cancle confirmText:(NSString *)confirm ;

//图片验证码
- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder cancleText:(NSString *)cancle confirmText:(NSString *)confirm captcha:(UIImage *)captcha;

- (void)updateCaptcha:(UIImage *)image;
@end


