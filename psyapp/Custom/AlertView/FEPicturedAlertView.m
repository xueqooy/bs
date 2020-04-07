//
//  FEPicturedAlertView.m
//  smartapp
//
//  Created by mac on 2019/8/2.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEPicturedAlertView.h"

@interface FEPicturedAlertView()
@property(nonatomic, strong) UIImageView *pictureImageView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *cancelButton;
@property(nonatomic, strong) UIButton *sureButton;

@property(nonatomic, strong) UIImage *pictureImage;
@property(nonatomic, copy) NSString *titleText;
@property(nonatomic, copy) NSString *cancelText;
@property(nonatomic, copy) NSString *surelText;

@end

@implementation FEPicturedAlertView

- (instancetype)initWithTitle:(NSString *)title leftText:(NSString *)leftText rightText:(NSString *)rightText picture:(UIImage *)picture {
    self = [super init];
    if (self) {
        _titleText = title;
        _cancelText = leftText;
        _surelText = rightText;
        _pictureImage = picture;
    }
    return self;
}

- (UIView *)layoutContainer {
    UIView *container = [UIView new];
    container.layer.masksToBounds = YES;
    [container setBackgroundColor:[UIColor whiteColor]];
    container.layer.cornerRadius = 16;
    //计算的高度
    CGFloat alertWidth = [SizeTool width:285];
    CGFloat pictureHeight = _pictureImage.size.height/_pictureImage.size.width * alertWidth;
    CGFloat titleMargin = [SizeTool height:24];
    CGFloat titleHeight = [_titleText getHeightForFont:mFontBold(14) width:alertWidth - 2 * titleMargin];
    CGFloat buttonMargin = [SizeTool width:15];
    CGFloat buttonHeight = [SizeTool height:40];
    
    container.frame = CGRectMake(0, 0, alertWidth, pictureHeight + titleMargin * 2 + buttonMargin * 2 + buttonHeight + titleHeight);
    
    _pictureImageView = [UIImageView new];
    [_pictureImageView setImage:_pictureImage];
    [_pictureImageView.layer setMasksToBounds: YES];
    [container addSubview:_pictureImageView];
    [_pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(alertWidth, pictureHeight));
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = _titleText?_titleText:@"";
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = mFontBold(14);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = mHexColor(@"1b1c1d");
    [container addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pictureImageView.mas_bottom).mas_equalTo(titleMargin);
        make.left.mas_equalTo(titleMargin);
        make.right.mas_equalTo(-titleMargin);
        make.centerX.mas_equalTo(0);
    }];
    
    _cancelButton = [UIButton new];
    [_cancelButton setTitle:_cancelText?_cancelText:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:mHexColor(@"1b1c1d") forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = mFontBold(12);
    _cancelButton.layer.borderWidth = 1;
    _cancelButton.layer.borderColor = mMainColor.CGColor;
    _cancelButton.layer.cornerRadius = 3;
    [_cancelButton addTarget:self action:@selector(hiddenAnimation:) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton.tag = 1;
    [container addSubview:_cancelButton];
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(buttonMargin);
        make.bottom.mas_equalTo(-buttonMargin);
        make.size.mas_equalTo(CGSizeMake([SizeTool width:120], buttonHeight));
    }];
    
 
    
    _sureButton = [UIButton new];
    [_sureButton setTitle:_surelText?_surelText:@"确定" forState:UIControlStateNormal];
    [_sureButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _sureButton.titleLabel.font = mFontBold(12);
    _sureButton.backgroundColor = mMainColor;
    _sureButton.layer.cornerRadius = 3;
    [_sureButton addTarget:self action:@selector(hiddenAnimation:) forControlEvents:UIControlEventTouchUpInside];
    _sureButton.tag = 2;
    [container addSubview:_sureButton];
    [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-buttonMargin);
        make.bottom.mas_equalTo(-buttonMargin);
        make.size.mas_equalTo(CGSizeMake([SizeTool width:120], buttonHeight));
    }];
    
    return container;
}

- (void)hiddenAnimation:(UIButton *)sender {
    __weak typeof(self)weakSelf = self;
    [self hideWithAnimated:YES completion:^{
        if (weakSelf.resultIndex) {
            weakSelf.resultIndex(sender.tag);
        }
    }];
}
@end
