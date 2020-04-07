//
//  LoginForgetView.h
//  smartapp
//
//  Created by mac on 2019/7/19.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//目前重置密码不需要图片验证码，暂时保留代码（注释部分）

@interface LoginForgetView : UIView
@property (nonatomic, copy) NSString *account; //验证的账号
@property (nonatomic, copy) NSString *nPassword;//新密码
@property (nonatomic, copy) NSString *smsVerifyCode;//短信验证码
@property (nonatomic, copy) NSString *imgVerifyCode;//图片验证码

//- (void)showVerificationCodeImage:(UIImage *)verfiImage;
//- (void)dismissVerificationCodeImage;
//- (BOOL)verificationCodeImageIsShown;
- (void)reloadViews;
- (void)startCountDown;
- (void)setPhoneText:(NSString *)phone;

@end

NS_ASSUME_NONNULL_END
