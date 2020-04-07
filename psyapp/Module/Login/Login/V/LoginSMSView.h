//
//  LoginSMSView.h
//  smartapp
//
//  Created by mac on 2019/7/20.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginSMSView : UIView
@property (nonatomic, copy)NSString *account;
@property (nonatomic, copy) NSString *verifyCode;
@property (nonatomic, assign) BOOL isBindingType;


- (void)setBindingType:(BOOL)isBinding;
- (void)setHeading:(NSString *)heading mainBody:(NSString *)mainBody;
- (void)setPhoneText:(NSString *)phone;
- (void)showVerificationCodeImage:(UIImage *)verfiImage;
- (void)dismissVerificationCodeImage;
- (BOOL)verificationCodeImageIsShown;
- (void)reloadViews;
@end

NS_ASSUME_NONNULL_END
