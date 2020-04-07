//
//  FETextInputAlertView.m
//  smartapp
//
//  Created by mac on 2019/8/27.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FETextInputAlertView.h"
#import "FastClickUtils.h"
@interface FETextInputAlertView ()
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *cancelButton;
@property(nonatomic, strong) UIButton *confirmButton;
@property(nonatomic, strong) UITextField *inputTextField;
@property(nonatomic, strong) UIView *splitView;
@property(nonatomic, strong) UIImageView *captchaImageView;

@property(nonatomic, copy) NSString *titleText;
@property(nonatomic, copy) NSString *cancelText;
@property(nonatomic, copy) NSString *confirmText;
@property(nonatomic, copy) NSString *placeholder;
@property(nonatomic, strong) UIImage *captcha;


@property(nonatomic, assign) BOOL isSingleButton;
@property(nonatomic, assign) BOOL hasCaptcha;
@end

@implementation FETextInputAlertView

- (void)show
{
    [self showWithAnimated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)updateCaptcha:(UIImage *)image {
    [_captchaImageView setImage:image];
}

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder cancleText:(NSString *)cancle confirmText:(NSString *)confirm{
    return [self initWithTitle:title placeholder:placeholder cancleText:cancle confirmText:confirm captcha:nil];
}

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder cancleText:(NSString *)cancle confirmText:(NSString *)confirm captcha:(UIImage *)captcha {
    if (self == [super init]) {
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
       _titleText = title;
       _cancelText = cancle;
       _confirmText = confirm;
       _placeholder = placeholder;
        if (captcha != nil) {
            _captcha = captcha;
            _hasCaptcha = YES;
        }
       if (!_cancelText || !_confirmText || [_cancelText isEqualToString:@""] || [_confirmText isEqualToString:@""]) {
           _isSingleButton = YES;
       }
       
       [self layoutIfNeeded];
    }
       
    return self;
}

- (UIView *)layoutContainer {
    UIView *container = [UIView new];
    container.layer.masksToBounds = YES;
    [container setBackgroundColor:UIColor.fe_contentBackgroundColor];
    container.layer.cornerRadius = 4;
    //计算高度
    CGFloat alertWidth = _hasCaptcha ? [SizeTool width:320] : [SizeTool width:270];
    CGFloat titleMargin = [SizeTool height:24];
    CGFloat titleHeght ;
    
    titleHeght = [_titleText getHeightForFont:mFontBold(18) width:alertWidth - 2 * titleMargin];
        
    
    CGFloat buttonHeight = [SizeTool height:60];
    
    container.frame = CGRectMake(0, 0, alertWidth, titleMargin * 2 + buttonHeight + titleHeght + [SizeTool height:50] + 1);
    
    _titleLabel = [UILabel new];
    _titleLabel.text = _titleText?_titleText:@"";
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = STFontBold(18);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = UIColor.fe_titleTextColor;
    [container addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([SizeTool height:17]);
        make.left.mas_equalTo(titleMargin);
        make.right.mas_equalTo(-titleMargin);
        make.centerX.mas_equalTo(0);
    }];
    
    
    
    if (!_isSingleButton) {
        _cancelButton = [UIButton new];
        [_cancelButton setTitle:_cancelText?_cancelText:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:UIColor.fe_titleTextColorLighten forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = mFont(18);
        [_cancelButton addTarget:self action:@selector(hiddenAnimation:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.tag = 1;
        [container addSubview:_cancelButton];
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(alertWidth/2, buttonHeight));
        }];
        
        _splitView = [UIView new];
        [container addSubview:_splitView];
        _splitView.backgroundColor = UIColor.fe_separatorColor;
        [_splitView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.width.equalTo(container);
            make.centerX.mas_equalTo(0);
            make.bottom.equalTo(_cancelButton.mas_top);
        }];
    }
    
    _confirmButton = [UIButton new];
    NSString *text;
    if (_isSingleButton) {
        if (_cancelText && ![_cancelText isEqualToString:@""]) {
            text = _cancelText;
        } else if (_confirmText && ![_confirmText isEqualToString:@""]){
            text = _confirmText;
        }
    } else {
        text = _confirmText;
    }
    [_confirmButton setTitle:text?text:@"确定" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = mFont(18);
    _confirmButton.backgroundColor = UIColor.fe_mainColor;
    [_confirmButton addTarget:self action:@selector(hiddenAnimation:) forControlEvents:UIControlEventTouchUpInside];
    _confirmButton.tag = 2;
    [container addSubview:_confirmButton];
    
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        CGFloat width;
        if (_isSingleButton) {
            width = alertWidth;
        } else {
            width = alertWidth/2;
        }
        make.size.mas_equalTo(CGSizeMake(width, buttonHeight));
    }];
    
    
    _inputTextField = [UITextField new];
    _inputTextField.textColor = UIColor.fe_mainTextColor;
    _inputTextField.font = mFont(18);
    _inputTextField.placeholder = _placeholder;
    
    
    [container addSubview:_inputTextField];
    [_inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat width = _hasCaptcha ?  STWidth(170) : alertWidth - [SizeTool width:30];
        make.width.mas_equalTo(width);
        make.height.mas_equalTo([SizeTool height:40]);
        make.left.mas_equalTo(STWidth(15));
        make.bottom.equalTo(_confirmButton.mas_top).offset(- [SizeTool height:15]);
    }];
    
    UIView *textFieldBottomLineView = [UIView new];
    textFieldBottomLineView.backgroundColor = UIColor.fe_separatorColor;
    [_inputTextField addSubview:textFieldBottomLineView];
    
    [textFieldBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.bottom.right.mas_equalTo(0);
    }];
    
    if (_hasCaptcha) {
        _captchaImageView = [[UIImageView alloc] init];
        [_captchaImageView setImage:_captcha];
        [container addSubview:_captchaImageView];
        [_captchaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(STSize(112, 40));
            make.bottom.equalTo(_inputTextField);
            make.right.mas_equalTo(-STWidth(15));
        }];
        _captchaImageView.userInteractionEnabled = YES;
        [_captchaImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchCaptcha)]];
    }
    
    return container;
}

- (void)touchCaptcha {
    if ([FastClickUtils isFastClick]) {
        return;
    }
    if (_touch) {
        _touch();
    }
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    // 获取键盘的高度
    NSDictionary *userInfo = aNotification.userInfo;
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = aValue.CGRectValue;
    CGFloat height =  CGRectGetHeight(keyboardRect);
    
    UIView *container = [self viewWithTag:FEBaseAlertViewContainerTag];
    container.layer.position = CGPointMake(self.center.x, self.center.y - height / 3);
    
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    UIView *container = [self viewWithTag:FEBaseAlertViewContainerTag];
    container.layer.position = self.center;
}

-(void)hiddenAnimation:(UIButton *)sender{
    __weak typeof(self)weakSelf = self;
    [self hideWithAnimated:YES completion:^{
        if (weakSelf.result) {
            BOOL isConfirm = sender.tag == 2? YES: NO;
            weakSelf.result(isConfirm,  weakSelf.inputTextField.text);
        }
    }];
}


@end
