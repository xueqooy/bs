//
//  CommonAlertView.m
//  smartapp
//
//  Created by lafang on 2018/9/14.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FECommonAlertView.h"

#import "StringUtils.h"


@interface FECommonAlertView()
//@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *cancelButton;
@property(nonatomic, strong) UIButton *sureButton;
@property(nonatomic, strong) UIView *splitView;

@property(nonatomic, copy) NSString *titleText;
@property(nonatomic, copy) NSAttributedString *attributedTitleText;
@property(nonatomic, copy) NSString *cancelText;
@property(nonatomic, copy) NSString *surelText;

@property(nonatomic, assign) BOOL isSingleButton;
@end

@implementation FECommonAlertView

- (void)showCustomAlertView
{
    [self showWithAnimated:YES];
}

- (void)setAttributeTextWithNormalText:(NSString *)text {
   _attributedTitleText = [StringUtils setupAttributedString:text font:STWidth(18)];
}

- (instancetype)initWithTitle:(NSString *)title leftText:(NSString *)leftText rightText:(NSString *)rightText icon:(UIImage *)icon{
    if (self == [super init]) {
    
        _titleText = title;
        _cancelText = leftText;
        _surelText = rightText;
        if (!_cancelText || !_surelText || [_cancelText isEqualToString:@""] || [_surelText isEqualToString:@""]) {
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
    CGFloat alertWidth = [SizeTool width:270];
    CGFloat titleMargin = [SizeTool height:24];
    CGFloat titleHeght ;
    if (_attributedTitleText) {
        titleHeght = [_attributedTitleText boundingRectWithSize:CGSizeMake(alertWidth - 2 * titleMargin, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    } else {
        titleHeght = [_titleText getHeightForFont:STFontBold(18) width:alertWidth - 2 * titleMargin];

    }
    CGFloat buttonHeight = [SizeTool height:60];
    
    container.frame = CGRectMake(0, 0, alertWidth, titleMargin * 2 + buttonHeight + titleHeght + 1);
    
    _titleLabel = [UILabel new];
    if (_attributedTitleText) {
        _titleLabel.attributedText = _attributedTitleText;
    } else {
         _titleLabel.text = _titleText?_titleText:@"";
    }
   
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = STFontBold(18);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _titleLabel.textColor = UIColor.fe_titleTextColor;
    [container addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleMargin);
        make.left.mas_equalTo(titleMargin);
        make.right.mas_equalTo(-titleMargin);
        make.centerX.mas_equalTo(0);
    }];
    
    if (!_isSingleButton) {
        _cancelButton = [UIButton new];
        _cancelButton.fe_adjustTitleColorAutomatically = YES;
        _cancelButton.backgroundColor = UIColor.fe_contentBackgroundColor;
        [_cancelButton setTitle:_cancelText?_cancelText:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = STFont(18);
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
    
    _sureButton = [UIButton new];
    NSString *text;
    if (_isSingleButton) {
        if (_cancelText && ![_cancelText isEqualToString:@""]) {
            text = _cancelText;
        } else if (_surelText && ![_surelText isEqualToString:@""]){
            text = _surelText;
        }
    } else {
        text = _surelText;
    }
    _sureButton.fe_adjustTitleColorAutomatically = YES;
    [_sureButton setTitle:text?text:@"确定" forState:UIControlStateNormal];
    _sureButton.titleLabel.font = STFont(18);
    _sureButton.backgroundColor = UIColor.fe_mainColor;
    [_sureButton addTarget:self action:@selector(hiddenAnimation:) forControlEvents:UIControlEventTouchUpInside];
    _sureButton.tag = 2;
    [container addSubview:_sureButton];
    
    [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.offset(0.5);
        CGFloat width;
        if (_isSingleButton) {
            width = alertWidth;
        } else {
            width = alertWidth/2;
        }
        make.size.mas_equalTo(CGSizeMake(width, buttonHeight + 0.5));
    }];
    
    return container;
}



-(void)hiddenAnimation:(UIButton *)sender{
    __weak typeof(self)weakSelf = self;
    [self hideWithAnimated:YES completion:^{
        if (weakSelf.resultIndex) {
            weakSelf.resultIndex(sender.tag);
        }
    }];
}





@end
