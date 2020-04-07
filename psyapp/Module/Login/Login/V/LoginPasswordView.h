//
//  LoginPasswordView.h
//  smartapp
//
//  Created by mac on 2019/7/19.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface LoginPasswordView : UIView
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *verifyCode;


- (BOOL)isRegisterType;
- (void)setRegisterType:(BOOL)type;
- (void)setPhoneText:(NSString *)phone;
- (void)showVerificationCodeImage:(UIImage *)verfiImage;
- (void)dismissVerificationCodeImage;
- (BOOL)verificationCodeImageIsShown;
- (void)reloadViews;
- (void)reload;
@end

NS_ASSUME_NONNULL_END
