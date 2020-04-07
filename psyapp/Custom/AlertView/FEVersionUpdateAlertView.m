//
//  FEVersionUpdateAlertView.m
//  smartapp
//
//  Created by mac on 2019/9/11.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEVersionUpdateAlertView.h"

#import "TCCommonButton.h"

#import "UILabel+FEChain.h"
@interface FEVersionUpdateAlertView ()

@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) UILabel *versionCodeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *contentOfUpdateTextView;
@property (nonatomic, strong) TCCommonButton *noMoreReminderButton;
@property (nonatomic, strong) TCCommonButton *gotoUpdateButton;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIImage *pictureImage;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSAttributedString *content;
@property (nonatomic, copy) NSString *leftButtonlText;
@property (nonatomic, copy) NSString *rightButtonlText;

@property (nonatomic, assign) BOOL isSingleButton;

@end

@implementation FEVersionUpdateAlertView

- (instancetype)initWithLeftButtonTitle:(NSString *)left rightButtonTitle:(NSString *)right versionName:(NSString *)version contentOfUpdate:(NSAttributedString *)content picture:(UIImage *)picture {
    self = [super init];
    if (self) {
        _leftButtonlText = left;
        _rightButtonlText = right;
        _version = version;
        _content = content;
        _pictureImage = picture;
        
        if (!left || !right || [left isEqualToString:@""] || [right isEqualToString:@""]) {
            _isSingleButton = YES;
        }
    }
    return self;
}

- (UIView *)layoutContainer {
    UIView *container = [UIView new];
    container.layer.masksToBounds = NO;
    [container setBackgroundColor:[UIColor whiteColor]];
    container.layer.cornerRadius = STWidth(16);
    
    //计算的高度
    CGFloat alertWidth = [SizeTool width:285];
    CGFloat pictureHeight = _pictureImage.size.height/_pictureImage.size.width * alertWidth;
    CGFloat titleMargin = [SizeTool height:21];
    CGFloat contentHeight = [_content boundingRectWithSize:CGSizeMake(alertWidth - 1.5 * titleMargin, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    CGFloat buttonMargin = [SizeTool width:15];
    CGFloat buttonHeight = [SizeTool height:48];
    
    CGFloat maxHeight = pictureHeight + titleMargin  + buttonMargin + buttonHeight + contentHeight;
    if (maxHeight < STWidth(320)) {
        maxHeight = STWidth(320);
    }
    if (maxHeight > STWidth(480)) {
        maxHeight = STWidth(480);
    }
    container.frame = CGRectMake(0, 0, alertWidth, maxHeight);
    
    _pictureImageView = [UIImageView new];
    [_pictureImageView setImage:_pictureImage];
    [_pictureImageView.layer setMasksToBounds: YES];
    [container addSubview:_pictureImageView];
    [_pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(STWidth(-21));
        make.size.mas_equalTo(CGSizeMake(alertWidth, pictureHeight));
    }];
    
    _versionCodeLabel = [UILabel create:^(UILabel *label) {
        label.textIs(_version)
        .textColorIs([UIColor whiteColor])
        .fontIs(STFont(12))
        .textAlignmentIs(NSTextAlignmentCenter);
        label.layer.borderWidth = 1;
        label.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(STSize(56, 18));
            make.left.top.mas_equalTo(STWidth(52));
        }];
    } addTo:container];
   
    _titleLabel = [UILabel create:^(UILabel *label) {
        label.textIs(@"本次更新:")
        .textColorIs(mHexColor(@"1b1c1d"))
        .fontIs(STFont(14));

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(STWidth(15));
            make.top.equalTo(_pictureImageView.mas_bottom).offset(STWidth(20));
        }];
    } addTo:container];
    
//    _contentOfUpdateLabel = [UILabel create:^(UILabel *label) {
//        label.attributedTextIs(_content)
//        .numberOfLinesIs(0);
//
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(STWidth(15));
//            make.top.equalTo(_titleLabel.mas_bottom).offset(STWidth(6));
//            make.right.mas_equalTo(STWidth(-15));
//        }];
//    } addTo:container];
    
    
    
    if (!_isSingleButton) {
        _noMoreReminderButton = [TCCommonButton new];
        [_noMoreReminderButton setTitle:_leftButtonlText?_leftButtonlText:@"不再提醒" forState:UIControlStateNormal];
        [_noMoreReminderButton setTitleColor:mHexColor(@"1b1c1d") forState:UIControlStateNormal];
        _noMoreReminderButton.titleLabel.font = mFont(16);
        _noMoreReminderButton.layer.borderWidth = 1;
        _noMoreReminderButton.layer.borderColor = UIColor.fe_mainColor.CGColor;
        _noMoreReminderButton.layer.cornerRadius = 3;
        _noMoreReminderButton.backgroundColor = [UIColor whiteColor];
        [_noMoreReminderButton addTarget:self action:@selector(hiddenAnimation:) forControlEvents:UIControlEventTouchUpInside];
        _noMoreReminderButton.tag = 1;
        [container addSubview:_noMoreReminderButton];
        [_noMoreReminderButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(STWidth(15));
            make.bottom.mas_equalTo(STWidth(-15));
            make.size.mas_equalTo(CGSizeMake(STWidth(120), buttonHeight));
        }];
        
    
    }
    
    _gotoUpdateButton = [TCCommonButton new];
    NSString *text;
    if (_isSingleButton) {
        if (_leftButtonlText && ![_leftButtonlText isEqualToString:@""]) {
            text = _leftButtonlText;
        } else if (_rightButtonlText && ![_rightButtonlText isEqualToString:@""]){
            text = _rightButtonlText;
        }
    } else {
        text = _rightButtonlText;
    }
    [_gotoUpdateButton setTitle:_rightButtonlText?_rightButtonlText:@"立即更新" forState:UIControlStateNormal];
    [_gotoUpdateButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _gotoUpdateButton.titleLabel.font = mFont(16);
    _gotoUpdateButton.layer.cornerRadius = 3;
    _gotoUpdateButton.backgroundColor = UIColor.fe_mainColor;
    [_gotoUpdateButton addTarget:self action:@selector(hiddenAnimation:) forControlEvents:UIControlEventTouchUpInside];
    _gotoUpdateButton.tag = 2;
    [container addSubview:_gotoUpdateButton];
    
    [_gotoUpdateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(STWidth(-15));
        CGFloat width;
        if (_isSingleButton) {
            width = alertWidth - STWidth(30);
        } else {
            width = STWidth(120);
        }
        make.size.mas_equalTo(CGSizeMake(width, buttonHeight));
    }];
    
    
    _contentOfUpdateTextView = [UITextView new];
    _contentOfUpdateTextView.attributedText = _content;
    _contentOfUpdateTextView.editable = NO;
    [container addSubview:_contentOfUpdateTextView];
    [_contentOfUpdateTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(STWidth(15));
        make.right.mas_equalTo(STWidth(-15));
        make.top.equalTo(_titleLabel.mas_bottom).offset(STWidth(5));
        make.bottom.equalTo(_gotoUpdateButton.mas_top).offset(STWidth(-15));
    }];
    
    
    _closeButton = [UIButton new];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"alert_close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(hiddenAnimation:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(STSize(32, 32));
        make.centerX.mas_equalTo(0);
        make.top.equalTo(container.mas_bottom).offset(STWidth(30));
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

- (void)qmui_themeDidChangeByManager:(QMUIThemeManager *)manager identifier:(__kindof NSObject<NSCopying> *)identifier theme:(__kindof NSObject *)theme {
    [super qmui_themeDidChangeByManager:manager identifier:identifier theme:theme];
    _noMoreReminderButton.layer.borderColor = UIColor.fe_mainColor.CGColor;
}
@end
