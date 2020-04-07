//
//  PhoneTableViewCell.h
//  CheersgeniePlus
//
//  Created by xueqooy on 2019/7/16.
//  Copyright © 2019 Cheersmind. All rights reserved.
//

#import "BaseTableViewCell.h"
typedef NS_OPTIONS(NSUInteger, SharedTextFieldComponent) {
    SharedTextFieldComponentAreaCode = 1 << 0,
    SharedTextFieldComponentClearOrVisibleButton = 1 << 1, //Visible只在密文是生效
    SharedTextFieldComponentVerifyButton = 1 << 2,
    SharedTextFieldComponentVerifyImage = 1 << 3,//图片验证码和验证码按钮只能存在一种,图片验证码优先级更高
    SharedTextFieldComponentTrailPromptLabel = 1 << 4
};

//typedef NS_ENUM(NSUInteger, SharedTextFieldLayoutAlignment) {
//    SharedTextFieldAlignmentLayoutBottom,
//    SharedTextFieldAlignmentLayoutTop
//};

@interface SharedTextTableViewCell : BaseTableViewCell
@property (nonatomic, copy) void(^clickedTextBoxHander)(void);
@property (nonatomic, copy) void(^clickedVerifyButtonHandler)(void);
@property (nonatomic, copy) void(^clickedVerifyImageHandler)(void);
//文本发生变化回调，如果是手记号格式，满足11位则回调filled = YES，否则filled = NO；不是手机号格式，有内容filled = YES，无内容filled = NO
@property (nonatomic, copy) void(^stateChangedHandler)(BOOL filled, NSString *changedText);
@property(nonatomic, assign) NSTimeInterval retransmissionTimeInterval;
//@property (nonatomic, assign) SharedTextFieldLayoutAlignment layoutAlignment;

- (void)buildComponent:(SharedTextFieldComponent)comp usePhoneFormat:(BOOL)format;
- (void)setPlaceholder:(NSString *)placeholder;
- (void)secureTextEntry:(BOOL)secure;
- (void)setVerificationImage:(UIImage *)img;
- (void)setFirstResponder:(BOOL)fr;
- (BOOL)setText:(NSString *)text;
- (void)setBottomLineColor:(UIColor *)color;
- (void)setTrailPromptText:(NSString *)text;
- (void)setTopPromptText:(NSString *)text;
- (void)setKeyboardType:(UIKeyboardType)type;
- (void)setReceiveSmsCodeEnabled:(BOOL)enabled;
- (void)setAutoCountDown:(BOOL)acd;
- (void)startCountDown;
- (void)setOnlyNumbersAndLettersEnable:(BOOL)enable;
@end


