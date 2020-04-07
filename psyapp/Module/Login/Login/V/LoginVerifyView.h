//
//  LoginVerifyView.h
//  smartapp
//
//  Created by mac on 2019/7/19.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginVerifyView : UIView
@property (nonatomic, copy) NSString *account; //验证的账号
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *smsVerifyCode;//短信验证码
@property (nonatomic, assign) BOOL isLoginVerify;//判断是登录的验证码页面还是注册的验证码页面(注册的验证码界面需要输入密码)
- (void)startCountDown;
- (void)reloadViews;

- (void)beginEditing;
@end

NS_ASSUME_NONNULL_END
