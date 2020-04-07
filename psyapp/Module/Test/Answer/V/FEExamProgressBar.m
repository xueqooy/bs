//
//  FEExamProgressBar.m
//  smartapp
//
//  Created by mac on 2019/7/31.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEExamProgressBar.h"
#import "FEProgressBar.h"
#import "UIImage+Utils.h"
#import "UIButton+Utils.h"
@implementation FEExamProgressBar
{
    UIView *containerView;
    UILabel *currentProgressLabel;
    UILabel *totalLabel;
    FEProgressBar *progressView;
    UIImageView *timeImageView;
    UILabel *timeLabel;
    UIButton *definitionButton;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setTimeWithString:(NSString *)timeString {
    [timeLabel setText:timeString];
}

- (void)setCurrentProgress:(NSInteger)current total:(NSInteger)total {
    CGFloat current_f = (CGFloat)current * 1.0;
    CGFloat total_f = (CGFloat)total * 1.0;
    if (current < 10) {
        currentProgressLabel.text = [NSString stringWithFormat:@"0%ld", (long)current];
    } else {
        currentProgressLabel.text = [NSString stringWithFormat:@"%ld", (long)current];
    }

    totalLabel.text  =[NSString stringWithFormat:@"/%ld", (long)total];
  
    if (total_f <= 0) return;
    progressView.progress = current_f/total_f;
}

- (void)setDefinitionButtonHidden:(BOOL)hidden {
    definitionButton.hidden = hidden;
}

- (void)setupSubViews {

    containerView = [UIView new];
    containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:containerView];
    
    currentProgressLabel = [UILabel createLabelWithDefaultText:@"00" numberOfLines:1 textColor:mHexColor(@"3c3f42") font:[UIFont monospacedDigitSystemFontOfSize:[SizeTool height:24] weight:UIFontWeightBold]];
    
    totalLabel = [UILabel createLabelWithDefaultText:@"00" numberOfLines:1 textColor:mHexColor(@"3c3f42") font:[UIFont monospacedDigitSystemFontOfSize:[SizeTool height:14] weight:UIFontWeightMedium]];
    
    progressView = [[FEProgressBar alloc] init];
    progressView.trackTintColor = mHexColor(@"f0f2f5");
    progressView.progressTintColor = mMainColor;
    progressView.progress = 0;
    [progressView setAnimated:YES withDuration:0.25 damping:1.0];
    [progressView setCornerRadius:4];

    
    timeImageView = [UIImageView new];
    [timeImageView setImage:[UIImage imageNamed:@"fire_exam_clock"]];
    
    timeLabel = [UILabel createLabelWithDefaultText:@"00:00" numberOfLines:1 textColor:UIColor.fe_auxiliaryTextColor font:[UIFont monospacedDigitSystemFontOfSize:[SizeTool height:14.f] weight:UIFontWeightRegular]];
    
    definitionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    definitionButton.frame = CGRectMake(0, 0, STWidth(18), STWidth(18));
    UIImage *definitionButtonImage = [[UIImage scaleImageWithName:@"question_mark_white" toSize:CGSizeMake([SizeTool width:10], [SizeTool height:10])] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [definitionButton setImage:
    definitionButtonImage  forState:UIControlStateNormal];
    [definitionButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    definitionButton.backgroundColor = UIColor.fe_placeholderColor;
    definitionButton.layer.cornerRadius = [SizeTool width:9.f];
    definitionButton.imageView.clipsToBounds = YES;
    definitionButton.hitScale = 2.0;
    
    [self addSubview:containerView];
    [containerView addSubview:currentProgressLabel];
    [containerView addSubview:totalLabel];
    [containerView addSubview:progressView];
    [containerView addSubview:timeImageView];
    [containerView addSubview:timeLabel];
    [containerView addSubview:definitionButton];
    
    CGFloat padding = [SizeTool width:15.f];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(mScreenWidth, [SizeTool height:60.f]));
        make.center.mas_equalTo(0);
    }];
    
    [currentProgressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.height.mas_equalTo([SizeTool height:20]);
        make.centerY.mas_equalTo(0);
    }];
    
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(currentProgressLabel.mas_right);
        make.centerY.equalTo(currentProgressLabel);
    }];
    
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.height.mas_equalTo([SizeTool height:8]);
        make.centerY.equalTo(totalLabel);
        make.left.equalTo(totalLabel.mas_right).offset([SizeTool width:10]);
        make.right.equalTo(timeImageView.mas_left).offset(STWidth(-9));
    }];
    
    [timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([SizeTool width:12], [SizeTool width:12]));
        make.right.equalTo(timeLabel.mas_left).offset(STWidth(-5));
        make.centerY.equalTo(progressView);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(definitionButton.mas_left).offset(STWidth(-7));
        make.centerY.equalTo(timeImageView);
    }];
    
    [definitionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeLabel);
        make.size.mas_equalTo([SizeTool sizeWithWidth:18 height:18]);
        make.right.equalTo(self).offset(- padding);
    }];
}

- (void)buttonClicked:(UIButton *)sender {
    if (_definitionButtonClickHandler) {
        _definitionButtonClickHandler();
    }
}

@end
