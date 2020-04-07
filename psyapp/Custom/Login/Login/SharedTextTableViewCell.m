//
//  PhoneTableViewCell.m
//  CheersgeniePlus
//
//  Created by xueqooy on 2019/7/16.
//  Copyright © 2019 Cheersmind. All rights reserved.
//

#import "SharedTextTableViewCell.h"

#import "UITextField+ExtentRange.h"

@interface SharedTextTableViewCell () <UITextFieldDelegate, CAAnimationDelegate>
@end

static NSInteger const kDefaultRetransmissionTime = 6;

@implementation SharedTextTableViewCell {
    UITextField *textField;
    UIView *bottomLine;
    UIView *rightView;
    UIButton *clearOrVisibleButton;
    UIButton *verifyButton;
    UIImageView *verifyImageView;
    
    UILabel *trailPromptLabel;//当输入文本时出现
    UILabel *topPromptLabel;//当输入文本时出现

    NSString *promptText;
    
    
    BOOL phoneFormat; //手机号格式
    BOOL hasClear;   //清除按钮
    BOOL hasVerifyButton;  //验证码按钮
    BOOL hasVerifyImage;   //验证码图片
    BOOL hasTrailPromptLabel;//尾部提示文本
    BOOL hasTopPromptLabel;//顶部提示文本
    BOOL retainTextIfReload;//刷新时是否保留文本
    BOOL isVisible;//内容是否可见
    BOOL isClearType; //clearOrVisibleButton是否为清空类型
    BOOL autoCountDown;
    BOOL onlyNumbersAndLettersEnable;
    
    NSInteger preTextLength;//保存先前文本长度
    NSString *preNoBlankText;//保存先前不带空格文本
    NSInteger preTextCursorLocation;//保存先前光标位置
    
    __weak UITapGestureRecognizer *textBoxGestureRecognizer;
    __weak UITapGestureRecognizer *verifyImageGestureRecognizer;

}

#pragma mark - public
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = UIColor.fe_contentBackgroundColor;
    return self;
}

- (void)setAutoCountDown:(BOOL)acd {
    autoCountDown = acd;
}

- (void)startCountDown {
    [self setRetransmissionCountDown:_retransmissionTimeInterval? _retransmissionTimeInterval:kDefaultRetransmissionTime];
}

- (BOOL)setText:(NSString *)text {
    if (phoneFormat) {
        BOOL valid = text.length > 11?NO:[text isNumber];
        if (valid) {
            NSString *phoneText;
            if (text.length <= 3) {
                phoneText = text;
            } else if (text.length > 3 && text.length <= 7) {
                phoneText = [NSString stringWithFormat:@"%@ %@",[text substringToIndex:3], [text substringFromIndex:3]];
            } else {
                phoneText = [NSString stringWithFormat:@"%@ %@ %@",[text substringToIndex:3], [text substringWithRange:NSMakeRange(3, 4)], [text substringFromIndex:7]];
            }
            textField.text = phoneText;
            
            if (text.length == 11 && verifyButton) {
                verifyButton.backgroundColor = UIColor.fe_mainColor;
                verifyButton.userInteractionEnabled = YES;
            }
        } else {
            return NO;
        }
    } else {
        textField.text = text;
    }
    [self updateTrailPromptConstrains];
    [self updateTopPrompt];
    return YES;
}

- (void)setOnlyNumbersAndLettersEnable:(BOOL)enable {
    onlyNumbersAndLettersEnable = enable;
}

- (void)setFirstResponder:(BOOL)fr {
    if (fr) {
        [textField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
}

- (void)buildComponent:(SharedTextFieldComponent)comp usePhoneFormat:(BOOL)format{
    phoneFormat = format;
    if (phoneFormat) {
       [self usePhoneFormat];
    }
    //顺序不能乱
    if (comp & SharedTextFieldComponentVerifyImage) {
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        hasVerifyImage = YES;
    }
    if ((comp & SharedTextFieldComponentVerifyButton) && !hasVerifyImage) {
        hasVerifyButton = YES;
    }
    if (comp & SharedTextFieldComponentClearOrVisibleButton) {
        isClearType = YES;
        hasClear = YES;
    }
    if (comp & SharedTextFieldComponentTrailPromptLabel) {
        hasTrailPromptLabel = YES;
    }
    
    if (comp & SharedTextFieldComponentAreaCode) {
        [self bulidAreaCode];
    }
    if (comp & SharedTextFieldComponentVerifyImage) {
        [self buildVerifyImage];
    }
    if ((comp & SharedTextFieldComponentVerifyButton) && !hasVerifyImage) {
        [self buildVerifyButton];
    }
    if (comp & SharedTextFieldComponentClearOrVisibleButton) {
        [self buildClearOrVisibleButton];
    }
    if (comp & SharedTextFieldComponentTrailPromptLabel) {
        [self buildTrailPromptLabel];
    }
    
}

- (void)setPlaceholder:(NSString *)placeholder {
    NSMutableAttributedString *placeHolderString = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [placeHolderString setAttributes:@{NSFontAttributeName : STFont(18), NSForegroundColorAttributeName : UIColor.fe_placeholderColor} range:NSMakeRange(0, placeholder.length)];

    [textField setAttributedPlaceholder:placeHolderString];
}

- (void)secureTextEntry:(BOOL)secure {
    textField.secureTextEntry = secure;
    if (@available(iOS 11.0, *)) {
        textField.textContentType = UITextContentTypeName;
    }
    
    isClearType = NO;
    isVisible = !secure;
    
    if (!hasClear) return;
    
    if (secure) {
        UIImage *visibleImg = [[UIImage imageNamed:@"visible"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [clearOrVisibleButton setImage:visibleImg forState:UIControlStateNormal];
    } else {
        UIImage *visibleImg = [[UIImage imageNamed:@"Invisible"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [clearOrVisibleButton setImage:visibleImg forState:UIControlStateNormal];
    }
    
}

- (void)setReceiveSmsCodeEnabled:(BOOL)enabled {
    if (enabled) {
        if (@available(iOS 12.0, *)) {
            //textField.textContentType = UITextContentTypeOneTimeCode;
        }
    } else {
        textField.textContentType = nil;
    }
    
}

- (void)setVerificationImage:(UIImage *)img {
    if (verifyImageView) {
        [verifyImageView setImage:img];
    }
}

- (void)setClickedTextBoxHander:(void (^)(void))clickedTextBoxHander {
    if (clickedTextBoxHander != nil) {
        _clickedTextBoxHander = clickedTextBoxHander;
        UIView *gestureResponser = [UIView new];
        gestureResponser.tag = 88888;
        [textField addSubview:gestureResponser];
        
        [gestureResponser mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        UITapGestureRecognizer *tapRecognizer;
        
        tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        [tapRecognizer setEnabled :YES];
        [tapRecognizer delaysTouchesBegan];
        [tapRecognizer cancelsTouchesInView];
        
        [gestureResponser addGestureRecognizer:tapRecognizer];
        
        textBoxGestureRecognizer = tapRecognizer;
    } else {
        UIView *gestureResponser = [textField viewWithTag:88888];
        if (gestureResponser) {
            [gestureResponser removeFromSuperview];
        }
    }
}

- (void)setBottomLineColor:(UIColor *)color {
    bottomLine.backgroundColor = color;
}

- (void)setKeyboardType:(UIKeyboardType)type {
    textField.keyboardType = type;
}

- (void)setTrailPromptText:(NSString *)text {
    if (text.length == 0) {
        hasTrailPromptLabel = NO;
        return;
    }
    hasTopPromptLabel = NO;
    topPromptLabel = nil;
    
    hasTrailPromptLabel = YES;
    promptText = text;
    if (!trailPromptLabel) {
        [self buildTrailPromptLabel];
    }
}

- (void)setTopPromptText:(NSString *)text {
    if (text.length == 0) {
        hasTopPromptLabel = NO;
        return;
    }
    hasTrailPromptLabel = NO;
    trailPromptLabel = nil;
    
    hasTopPromptLabel = YES;
    promptText = text;
    if (!topPromptLabel) {
        [self buildTopPromptLabel];
    }
}
#pragma mark - private



- (void)updateTrailPromptConstrains {
    if (!hasTrailPromptLabel) return;
    if (textField.text.length == 0) {
        trailPromptLabel.hidden = YES;
        return;
    }
    trailPromptLabel.hidden = NO;
    CGFloat textFieldTextWidth = [textField.text getWidthForFont:textField.font];
    [trailPromptLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textFieldTextWidth + [SizeTool width:25]);
    }];
}

- (void)updateTopPrompt {
    if (!hasTopPromptLabel) return;
    if (textField.text.length == 0) {
        [self hideTopPrompt];
        //topPromptLabel.hidden = YES;
        return;
    }
    [self showTopPrompt];
    //topPromptLabel.hidden = NO;
}

- (void)showTopPrompt {
    if (topPromptLabel.hidden == NO) {
        return;
    }

    UIColor *originColor = topPromptLabel.textColor;
    UIFont *originFont = topPromptLabel.font;
    
    topPromptLabel.text = textField.placeholder;
    topPromptLabel.textColor = mHexColor(@"b0b5b9");
    topPromptLabel.font = STFont(18);

 
    topPromptLabel.transform = CGAffineTransformMakeTranslation(0, STWidth(20));

    topPromptLabel.hidden = NO;
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        topPromptLabel.transform = CGAffineTransformIdentity;
        topPromptLabel.textColor = originColor;
        topPromptLabel.font = originFont;
        topPromptLabel.alpha = 0.2;
    } completion:^(BOOL finished) {
       topPromptLabel.text = promptText;
  
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
               topPromptLabel.alpha = 1.0;
           } completion:nil];
    }];
    
}



- (void)hideTopPrompt {
    topPromptLabel.hidden = YES;
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    if (sender == textBoxGestureRecognizer) {
        bottomLine.backgroundColor = UIColor.fe_mainColor;
           if (_clickedTextBoxHander) {
               _clickedTextBoxHander();
           }
    } else if (sender == verifyImageGestureRecognizer){
        if (_clickedVerifyImageHandler) {
            CABasicAnimation *scaleAni = [CABasicAnimation animation];
            [scaleAni setValue:@"scaleAni" forKey:@"ani"];
            scaleAni.keyPath = @"transform.scale";
            scaleAni.fromValue = @1;
            scaleAni.toValue = @0.95;
            scaleAni.autoreverses = YES;
            scaleAni.delegate = self;
            scaleAni.duration = 0.15;
            [verifyImageView.layer addAnimation:scaleAni forKey:nil];
            
            verifyImageView.userInteractionEnabled = NO;
            
            _clickedVerifyImageHandler();
        }
    }
   
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag == YES) {
        if ([[anim valueForKey:@"ani"] isEqualToString:@"scaleAni"]) {
            if (verifyImageView) {
                verifyImageView.userInteractionEnabled = YES;
            }
        }
    }
}

- (void)usePhoneFormat {
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [textField registerObsever:self forEvents:TextFieldEventEditingChanged | TextFieldEventCursorMovement];
}

- (void)buildTrailPromptLabel {
    trailPromptLabel = [UILabel createLabelWithDefaultText:promptText numberOfLines:1 textColor:UIColor.fe_mainColor font:mFont(9)];
    trailPromptLabel.backgroundColor = mHexColor(@"f0f2f5");
    trailPromptLabel.layer.cornerRadius = [SizeTool height:9];
    trailPromptLabel.textAlignment = NSTextAlignmentCenter;
    [trailPromptLabel.layer setMasksToBounds:YES];
    trailPromptLabel.hidden = YES;
    CGFloat textFieldTextWidth = [textField.text getWidthForFont:textField.font];
    CGFloat promptTextWidth = [promptText getWidthForFont:mFont(9)] + [SizeTool width:10];
    [self.contentView addSubview:trailPromptLabel];
    [trailPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(textField);
        make.left.mas_equalTo(textFieldTextWidth + [SizeTool width:25]);
        make.size.mas_equalTo([SizeTool sizeWithWidth:promptTextWidth height:[SizeTool height:18]]);
    }];
}

- (void)buildTopPromptLabel {
    topPromptLabel = [UILabel createLabelWithDefaultText:promptText numberOfLines:1 textColor:mHexColor(@"a4aebc") font:mFont(11)];
    topPromptLabel.hidden = YES;
    [self.contentView addSubview:topPromptLabel];
    [topPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomLine);
        make.bottom.equalTo(textField.mas_top).offset([SizeTool height:5]);
    }];

}

- (void)bulidAreaCode {
    UIView *leftView = [UIView new];
    leftView.frame = CGRectMake(0, 0, STWidth(50), STWidth(32));//cell高度40，偏移4
    
    UILabel *areaCodeLabel =  [UILabel new];
    areaCodeLabel.text = @"+86";
    areaCodeLabel.textColor  = mHexColor(@"1b1c1d");
    areaCodeLabel.font = STFont(18);
    [areaCodeLabel sizeToFit];
    
    UIView *splitLine = [UIView new];
    splitLine.backgroundColor  = mHexColor(@"1b1c1d");
    
    [leftView addSubview:areaCodeLabel];
    [leftView addSubview:splitLine];
    
//    [areaCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.left.equalTo(leftView);
//    }];
//    [splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(0.5);
//        make.height.mas_equalTo(STHeight(18));
//        make.centerY.equalTo(leftView);
//        make.right.equalTo(leftView).mas_offset(-STWidth(10));
//    }];
    CGFloat width = CGRectGetWidth(areaCodeLabel.frame);
    CGFloat height = CGRectGetHeight(areaCodeLabel.frame);
    CGFloat y = CGRectGetMidY(leftView.frame) - height / 2;
    areaCodeLabel.frame = CGRectMake(0, y, width, height);
    
    width = STHeight(18);
    CGFloat x = CGRectGetMaxX(leftView.frame) - STWidth(10);
    y = CGRectGetMidY(leftView.frame) -height / 2;
    splitLine.frame = CGRectMake(x, y, 0.5, width);
    
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
}

- (void)buildVerifyImage {
    if (!rightView) {
        rightView = [UIView new];
        textField.rightView = rightView;
        textField.rightViewMode = UITextFieldViewModeAlways;
    }
    CGFloat rightViewWidth;
    if (hasClear) {
        rightViewWidth = STWidth(140);
    } else {
        rightViewWidth = STWidth(108);
    }
    rightView.frame = CGRectMake(0, 0, rightViewWidth, self.contentView.height);
    
    verifyImageView = [UIImageView new];
    verifyImageView.tag = 5002;
    verifyImageView.layer.cornerRadius = STWidth(2);
    verifyImageView.userInteractionEnabled = YES;
    [rightView addSubview:verifyImageView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [verifyImageView addGestureRecognizer:tapGestureRecognizer];
    verifyImageGestureRecognizer = tapGestureRecognizer;
    
    CGFloat width = STWidth(108);
    CGFloat height = STWidth(40);
    CGFloat x = CGRectGetMaxX(rightView.frame) - width;
    CGFloat y = CGRectGetMidY(rightView.frame) - height / 2 - STWidth(6);
    
//    [verifyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self->rightView).offset(-STWidth(6));
//        make.right.equalTo(self->rightView);
//        make.size.mas_equalTo(STSize(108, 40));
//    }];
    verifyImageView.frame = CGRectMake(x, y, width, height);
   
}

- (void)buildVerifyButton {
    if (!rightView) {
        rightView = [UIView new];
        textField.rightView = rightView;
        textField.rightViewMode = UITextFieldViewModeAlways;
    }
    CGFloat rightViewWidth;
    if (hasClear) {
        rightViewWidth = STWidth(105);
    } else {
        rightViewWidth = STWidth(75);
    }
    rightView.frame = CGRectMake(0, 0, rightViewWidth, self.contentView.height);
    
    verifyButton = [UIButton new];
    verifyButton.fe_adjustTitleColorAutomatically = YES;
    verifyButton.tag = 5001;
    [verifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    verifyButton.backgroundColor = UIColor.fe_buttonBackgroundColorDisabled;
    [verifyButton.titleLabel setFont:STFont(11)];
    verifyButton.layer.cornerRadius = STWidth(2);
    [verifyButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    verifyButton.userInteractionEnabled = NO;
    
    autoCountDown = YES;
    
    [rightView addSubview:verifyButton];
    CGFloat width = STWidth(72);
    CGFloat height = STWidth(32);
    CGFloat x = CGRectGetMaxX(rightView.frame) - width;
    CGFloat y = CGRectGetMidY(rightView.frame) - height / 2;
//    [verifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.centerY.equalTo(self->rightView);
//        make.size.mas_equalTo(STSize(72, 32));
//    }];
    verifyButton.frame = CGRectMake(x, y, width, height);
    

}

- (void)buildClearOrVisibleButton {
    if (!rightView) {
        rightView = [UIView new];
        textField.rightViewMode = UITextFieldViewModeAlways;
        textField.rightView = rightView;
    }
    CGFloat rightViewWidth;
    
    if (hasVerifyImage) {
        rightViewWidth = STWidth(140);
    } else if (hasVerifyButton) {
        rightViewWidth = STWidth(105);
    } else {
        rightViewWidth = STWidth(20);
    }
    
    rightView.frame = CGRectMake(0, 0, rightViewWidth, self.contentView.height);
    
    clearOrVisibleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    clearOrVisibleButton.tag = 5000;
    UIImage *clearImg = [[UIImage imageNamed:@"share_clear"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [clearOrVisibleButton setImage:clearImg forState:UIControlStateNormal];
    clearOrVisibleButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [clearOrVisibleButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightView addSubview:clearOrVisibleButton];
    CGFloat width = STWidth(18);
    CGFloat x = CGRectGetMaxX(rightView.frame) - width;
    CGFloat y = CGRectGetMidY(rightView.frame) - width / 2;
    if (!hasVerifyButton && !hasVerifyImage) {
        //iOS13之后textField的overlayView的子视图使用约束布局，会导致overlayView覆盖整个textField，导致textField无法使用
//        [clearOrVisibleButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.right.equalTo(self->rightView);
//            make.size.mas_equalTo(STSize(18, 18));
//        }];
        
        clearOrVisibleButton.frame = CGRectMake(x, y, width, width);
        
    } else {
        UIView *view;
        if (hasVerifyImage) {
            view = verifyImageView;
        } else {
            view = verifyButton;
        }
//        [clearOrVisibleButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self->rightView);
//            make.right.equalTo(view.mas_left).offset(-STWidth(9));
//            make.size.mas_equalTo(STSize(18, 18));
//        }];
        x = CGRectGetMinX(view.frame) - STWidth(9) - width;
        clearOrVisibleButton.frame = CGRectMake(x, y, width, width);
    }
   
   
    
    clearOrVisibleButton.hidden = YES;//当开始输入文本时，再显示
    
   // [textField registerObsever:self forEvents:TextFieldEventTextAssigned];//当清空内容时，需要隐藏clearOrVisibleButton，EditingChangedb无法监听赋值(弃用)
}

- (void)setRetransmissionCountDown:(NSInteger)time {//重发倒计时
    verifyButton.userInteractionEnabled = NO;
    [verifyButton setBackgroundColor:UIColor.fe_buttonBackgroundColorDisabled];
    __block NSInteger rest = time;
    dispatch_source_t timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(timerSource, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timerSource, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (rest == 0) {
                if (textField.text.length == 13) {
                    verifyButton.userInteractionEnabled = YES;
                    [verifyButton setTitle:@"重新获取" forState:UIControlStateNormal];
                    [verifyButton setBackgroundColor:UIColor.fe_mainColor];

                } else {
                    verifyButton.userInteractionEnabled = NO;
                    [verifyButton setBackgroundColor:UIColor.fe_buttonBackgroundColorDisabled];
                    [verifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                }
                dispatch_cancel(timerSource);
            } else {
               verifyButton.userInteractionEnabled = NO;
                [verifyButton setTitle:[NSString stringWithFormat:@"%lds后重试",(long)rest] forState:UIControlStateNormal];
                rest--;
            }
        });
    });
    dispatch_resume(timerSource);
    
}

- (void)setUpSubviews {
    bottomLine = [UIView new];
    bottomLine.backgroundColor = UIColor.fe_separatorColor;

    [self.contentView addSubview:bottomLine];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(STWidth(15));
        make.right.equalTo(self.contentView).offset(-STWidth(15));
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.contentView);
    }];
    
    textField = [UITextField new];
    textField.textColor = UIColor.fe_titleTextColor;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    [[UITextField appearance] setTintColor:UIColor.fe_mainColor];//设置光标颜色，影响所有textField
    textField.backgroundColor = UIColor.fe_contentBackgroundColor;
    textField.font = STFontBold(18);
    
    [textField registerObsever:self forEvents:TextFieldEventEditingDidEnd | TextFieldEventEditingDidBegin | TextFieldEventEditingChanged];
    [self.contentView addSubview:textField];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self->bottomLine);
        make.height.mas_equalTo(STWidth(42));
        make.bottom.equalTo(@-0.5);
    }];
}

- (void)click:(UIButton *)sender {
    if (sender.tag != 5001) { //clearOrVisibleButtonClicked
        if (!isClearType) {
            [self secureTextEntry:isVisible];
        } else {
            textField.text = @"";
            preTextLength = 0;
            preTextCursorLocation = 0;
            if (verifyButton) {
                [verifyButton setBackgroundColor:UIColor.fe_buttonBackgroundColorDisabled];//点亮验证码按钮
                verifyButton.userInteractionEnabled = NO;
            }
    
            if (_stateChangedHandler) {
                _stateChangedHandler(NO, @"");
            }
            sender.hidden = YES;
        }
        
    } else { //verifyButtonClicked
        if (_clickedVerifyButtonHandler) {
            _clickedVerifyButtonHandler();
        }
        if (autoCountDown) {
             [self setRetransmissionCountDown:_retransmissionTimeInterval? _retransmissionTimeInterval : kDefaultRetransmissionTime];
        }
    }
    
    [self updateTrailPromptConstrains];
    [self updateTopPrompt];
}

#pragma mark - textField obsever delegate
//写到后面自己都看不懂了.....
- (void)observeTextField:(UITextField *)textField ForEvent:(TextFieldEvent)event {
   
    if (event == TextFieldEventEditingDidBegin) {
        bottomLine.backgroundColor = UIColor.fe_mainColor;
        if (textField.text.length == 0) return;
        clearOrVisibleButton.hidden = NO;
    } else if (event ==TextFieldEventEditingDidEnd) {
        bottomLine.backgroundColor = UIColor.fe_separatorColor;
        //clearOrVisibleButton.hidden = YES;
    } else if (event == TextFieldEventEditingChanged) {
        NSString *text = textField.text;//带空格的字符串
        NSString *noBlankText = [text stringByReplacingOccurrencesOfString:@" " withString:@""];//不带空格的字符串
        NSRange selectRange = [textField selectedRange];//当前光标位置
        
        if (phoneFormat) {
            //在输入文本，并且字数达到要求执行
            if (preTextLength < text.length) {
                if (text.length >= 4 && text.length < 9) {
                    textField.text = [NSString stringWithFormat:@"%@ %@",[noBlankText substringToIndex:3], [noBlankText substringWithRange:NSMakeRange(3, noBlankText.length - 3)]];
                    if (text.length == 4 && noBlankText.length != 4) {
                        selectRange = NSMakeRange(selectRange.location + 1, 0);
                    }
                } else if (text.length >= 9 && text.length <= 13){
                    textField.text = [NSString stringWithFormat:@"%@ %@ %@",[noBlankText substringToIndex:3], [noBlankText substringWithRange:NSMakeRange(3, 4)], [noBlankText substringWithRange:NSMakeRange(7, noBlankText.length - 7)]];
                    if (text.length == 9 && noBlankText.length != 8) {
                        selectRange = NSMakeRange(selectRange.location + 1, 0);
                    }
                }
                [textField setSelectedRange:selectRange];
            } else if (preTextLength > text.length) {
                //在删除文本，并且字数达到要求执行
                if (text.length < 9 && text.length > 4) {
                    textField.text = [NSString stringWithFormat:@"%@ %@",[noBlankText substringToIndex:3], [noBlankText substringWithRange:NSMakeRange(3, noBlankText.length - 3)]];
                } else if (text.length <= 4) {
                    textField.text = noBlankText;
                    if (noBlankText.length == 4) {
                        selectRange = NSMakeRange(selectRange.location - 1, 0);
                    } else if (noBlankText.length == 3) {
                        if (selectRange.location != 2) {
                            selectRange = NSMakeRange(selectRange.location - 1, 0);
                        }
                    }
                } else if (text.length == 9 ) {
                    textField.text = [NSString stringWithFormat:@"%@ %@",[noBlankText substringToIndex:3], [noBlankText substringWithRange:NSMakeRange(3, 4)]];
                    if (noBlankText.length != 7) {
                        selectRange = NSMakeRange(selectRange.location - 1, 0);
                    } else {
                        if (selectRange.location == 9) {
                            selectRange = NSMakeRange(selectRange.location - 1, 0);
                        }
                    }
                } else if (text.length >9) {
                    textField.text = [NSString stringWithFormat:@"%@ %@ %@",[noBlankText substringToIndex:3], [noBlankText substringWithRange:NSMakeRange(3, 4)], [noBlankText substringWithRange:NSMakeRange(7, noBlankText.length - 7)]];
                }
                [textField setSelectedRange:selectRange];
            }
            
            if (text.length > 13) {
                if (preNoBlankText == nil) {
                    preNoBlankText = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                }
                textField.text = [NSString stringWithFormat:@"%@ %@ %@",[preNoBlankText substringToIndex:3], [preNoBlankText substringWithRange:NSMakeRange(3, 4)], [preNoBlankText substringWithRange:NSMakeRange(7, 4)]];//preNoBlankText.length - 7
            }
            preNoBlankText = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        
        //处理回调
        BOOL filled = NO;
        if (phoneFormat) {
            if (preNoBlankText.length == 11) {//手机号格式，满足长度回调YES
                filled = YES;
                [verifyButton setBackgroundColor:UIColor.fe_mainColor];//点亮验证码按钮
                verifyButton.userInteractionEnabled = YES;
            } else {
                [verifyButton setBackgroundColor:UIColor.fe_buttonBackgroundColorDisabled];//点亮验证码按钮
                verifyButton.userInteractionEnabled = NO;
            }
        } else {
            if (text.length != 0) {
                filled = YES;
            }
        }
        if (_stateChangedHandler) {
            if (phoneFormat) {
                _stateChangedHandler(filled, preNoBlankText);
            } else {
                _stateChangedHandler(filled, text);

            }
            
        }
        //处理clearOrVisibleButton的显示和promptLabel
        if (text.length != 0) {//当输入字符后，显示clearOrVisibleButton
            clearOrVisibleButton.hidden = NO;
        } else {
            clearOrVisibleButton.hidden = YES;
        }
        
        if (hasTrailPromptLabel) {
            [self updateTrailPromptConstrains];
        }
        if (hasTopPromptLabel) {
            [self updateTopPrompt];
        }
        
    } else if (event == TextFieldEventCursorMovement) {//监听光标移动
        NSRange selectRange = [textField selectedRange];
        if (preTextCursorLocation > selectRange.location) {
            if (selectRange.location == 4 ) {
                [textField setSelectedRange:NSMakeRange(3, 0)];
            } else if (selectRange.location == 9) {
                [textField setSelectedRange:NSMakeRange(8, 0)];
            }
        } else {
            if (selectRange.location == 4 ) {
                [textField setSelectedRange:NSMakeRange(5, 0)];
            } else if (selectRange.location == 9) {
                [textField setSelectedRange:NSMakeRange(10, 0)];
            }
        }
    }

    preTextLength = textField.text.length;
    preTextCursorLocation = [textField selectedRange].location;
}



#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
// 手机号格式限制只能输入数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (phoneFormat) {
        return [string isNumber];
    } else if (onlyNumbersAndLettersEnable){
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    return YES;
}


- (void)dealloc {
    [textField removeObserversforEvents:TextFieldEventAllEvents];
}
@end
