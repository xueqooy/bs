//
//  FEProportionProgressBar.m
//  smartapp
//
//  Created by mac on 2019/8/17.
//  Copyright © 2019 xueqooy. All rights reserved.
//

#import "FEProportionProgressBar.h"
#import "FEProgressBar.h"
@interface FEProportionProgressBar()
@property(nonatomic, copy, readwrite) NSString *leftTitle;
@property(nonatomic, copy, readwrite) NSString *rightTitle;
@property(nonatomic, assign, readwrite) CGFloat leftPercent;
@property(nonatomic, assign, readwrite) CGFloat rightPercent;
@end
@implementation FEProportionProgressBar
{
    FEProgressBar *progressBar;
    UILabel *leftTitleLabel;
    UILabel *rightTitleLabel;
    UILabel *leftPercentLabel;
    UILabel *rightPercentlabel;
    
    BOOL reverse;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    reverse = NO;
    [self setupSubviews];
    return self;
}

- (void)setupSubviews {
    leftTitleLabel = [UILabel createLabelWithDefaultText:@"" numberOfLines:1 textColor:UIColor.fe_titleTextColorLighten font:mFontBold(12)];
    leftTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:leftTitleLabel];
    [leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
    }];
    
    leftPercentLabel = [UILabel createLabelWithDefaultText:@"" numberOfLines:1 textColor:UIColor.fe_textColorHighlighted font:mFontBold(12)];
    leftPercentLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:leftPercentLabel];
    [leftPercentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftTitleLabel.mas_right).offset([SizeTool width:6]);
        make.centerY.equalTo(leftTitleLabel);
    }];

    rightTitleLabel = [UILabel createLabelWithDefaultText:@"" numberOfLines:1 textColor:UIColor.fe_titleTextColorLighten font:mFontBold(12)];
    rightTitleLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:rightTitleLabel];
    [rightTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
    }];
    
    rightPercentlabel = [UILabel createLabelWithDefaultText:@"" numberOfLines:1 textColor:UIColor.fe_textColorHighlighted font:mFontBold(12)];
    rightPercentlabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:rightPercentlabel];
    [rightPercentlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightTitleLabel.mas_left).offset(-[SizeTool width:6]);
        make.centerY.equalTo(rightTitleLabel);
    }];
    
    progressBar = [FEProgressBar new];
    [progressBar setCornerRadius:[SizeTool height:3]];
    [progressBar setAnimated:YES withDuration:0.35 damping:0.5];
    [progressBar setTrackTintColor:UIColor.fe_buttonBackgroundColorActive];
    progressBar.progressTintColor = mHexColor(@"ffb245");//过渡颜色
    progressBar.clickToReverse = NO;
    [self setProgressGradient];
    
    [self addSubview:progressBar];
    [progressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftTitleLabel.mas_bottom).offset([SizeTool height:5]);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo([SizeTool height:6]);
    }];
    
    [self addTapGesture];
}

- (void)addTapGesture {//点击反转
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tgr];
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    [progressBar setReverse:!progressBar.reverse];
    reverse = !reverse;
    if (reverse == YES) {
        leftTitleLabel.text = _rightTitle;
        rightTitleLabel.text = _leftTitle;
        
        leftPercentLabel.text = [NSString stringWithFormat:@"%.0f%%", _rightPercent * 100.0];
        rightPercentlabel.text = [NSString stringWithFormat:@"%.0f%%", _leftPercent * 100.0];
    } else {
        [self setContent];
    }
    
  

}

#define E 0.5  //误差
- (void)setLeftTitle:(NSString *)leftTitle byPercent:(CGFloat)leftPercent andRightTitle:(NSString *)rightTitle byPercent:(CGFloat)rightPercent {
    CGFloat progress = 0.0;
    if (fabs(1.0 - (leftPercent + rightPercent)) > E) {//不能够判断2浮点数相加是否准确等于一个特定值，比如leftPercent + rightPercent == 1.0
        if (leftPercent >= rightPercent) {
            _rightPercent = 1.0 - leftPercent;
            _leftPercent = leftPercent;
        } else {
            _leftPercent = 1.0 - rightPercent;
            _rightPercent = rightPercent;
        }
    } else {
        _leftPercent = leftPercent;
        _rightPercent = rightPercent;
    }
    
    progress = _leftPercent > _rightPercent ? _leftPercent: _rightPercent;
    
    [progressBar setProgress:progress];
    if (_leftPercent < _rightPercent) {
        [progressBar setReverse:YES];
    }
    
    
    _leftTitle = leftTitle;
    _rightTitle = rightTitle;
    
    [self setContent];
    
}

- (void)setContent {
    leftTitleLabel.text = _leftTitle;
    rightTitleLabel.text = _rightTitle;
    
    leftPercentLabel.text = [NSString stringWithFormat:@"%.0f%%", _leftPercent * 100.0];
    rightPercentlabel.text = [NSString stringWithFormat:@"%.0f%%", _rightPercent * 100.0];
}

- (void)setProgressGradient {
    NSArray *colors = @[@1.0, @0.69, @0.27, @1.0,
    @0.97, @0.48, @0.11, @1.0];
    if ([[FEThemeManager currentTheme].themeName isEqualToString:FEThemeConfigureDarkIdentifier]) {
        colors = @[@1.0, @0.69, @0.27, @0.6,
                   @0.97, @0.48, @0.11, @0.6];
    }
    
    NSArray *locations = @[@0.0, @1.0];
    
    [progressBar setGradientProgressWithColors:colors locations:locations];
}

- (void)qmui_themeDidChangeByManager:(QMUIThemeManager *)manager identifier:(__kindof NSObject<NSCopying> *)identifier theme:(__kindof NSObject *)theme {
    [super qmui_themeDidChangeByManager:manager identifier:identifier theme:theme];
    [self setProgressGradient];
}
@end
