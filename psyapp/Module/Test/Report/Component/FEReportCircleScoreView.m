//
//  FEReportCircleScoreDescView.m
//  smartapp
//
//  Created by mac on 2019/12/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEReportCircleScoreView.h"
#import "FEProgressBar.h"
#import "FECourseSurplusView.h"
//#import "FEScoreCircleProgressView.h"
@implementation FEReportCircleScoreView {
    CGFloat _maxScore;
    NSString *_score;
    NSString *_result;
    BOOL _isBadTendency;
}

- (instancetype)initWithMaxScore:(CGFloat)maxScore score:(NSString *)score result:(NSString *)result isBadTendency:(BOOL)isBadTendency{
    self = [super init];
    _maxScore = maxScore;
    _score = score;
    _result = result;
    _isBadTendency = isBadTendency;
    [self build];
    return self;
}

- (void)build {
    if (_maxScore <= 0) return;
    CGFloat progress = _score.floatValue / _maxScore;
    CGFloat resultWith = [_result getWidthForFont:STFontRegular(12)] + STWidth(10);
    FECourseSurplusView *resultView = [[FECourseSurplusView alloc] initWithFrame:CGRectMake(0, 0, resultWith , STWidth(26))];
    resultView.radius = STWidth(4);
    resultView.fillColor = [self.tendencyColor colorWithAlphaComponent:0.05];
    resultView.borderWidth = STWidth(1);
    resultView.borderColor = self.tendencyColor;
    resultView.titleLabel.text = _result;
    resultView.titleLabel.textColor = self.tendencyColor;
    resultView.titleLabel.font = STFontRegular(12);
    resultView.arrowWidth = STWidth(10);
    resultView.labelHeight = STWidth(21);
    [self addSubview:resultView];
    [resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat offsetLeft = progress * STWidth(315) - resultWith / 2 - STWidth(5);
        if (offsetLeft < 0) {
            offsetLeft = 0;
        }
        if (offsetLeft > STWidth(315) - resultWith) {
            offsetLeft = STWidth(315) - resultWith;
        }
        make.left.offset(offsetLeft);
        make.top.offset(0);
        make.size.mas_equalTo(CGSizeMake(resultWith, STWidth(26)));
    }];
    
    FEProgressBar *progressBar = [FEProgressBar new];
    progressBar.roundCorner = YES;
    progressBar.trackTintColor = mHexColor(@"f0f2f5");
    progressBar.progress = progress;
    progressBar.progressTintColor = self.tendencyColor;
    [self addSubview:progressBar];
    [progressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(STSize(315, 18));
        make.top.mas_equalTo(STWidth(33));
        make.left.right.bottom.offset(0);
    }];
    
    UILabel *scoreLabel = [UILabel.alloc qmui_initWithFont:STFontRegular(12) textColor:UIColor.whiteColor];
    scoreLabel.text = _score;
    [progressBar addSubview:scoreLabel];
    [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(progress * STWidth(315) - STWidth(30));
    }];

    
    
//    FEScoreCircleProgressView *scoreCircleProgressView = [[FEScoreCircleProgressView alloc] initWithFrame:CGRectMake(0, 0, STWidth(140), STWidth(140))];
//    scoreCircleProgressView.maxScore = _maxScore;
//    scoreCircleProgressView.scoreString = _score;
//    scoreCircleProgressView.progressTintColor = self.tendencyColor;
//    [self addSubview:scoreCircleProgressView];
//    [scoreCircleProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.top.offset(0);
//        make.size.mas_equalTo([SizeTool sizeWithWidth:140 height:140]);
//    }];
//
//    //结果标签
//    UILabel *resultLabel  = [UILabel createLabelWithDefaultText:_result numberOfLines:1 textColor:self.tendencyColor font:STFont(14)];
//   resultLabel.textAlignment = NSTextAlignmentCenter;
//   resultLabel.layer.cornerRadius = STWidth(16);
//   resultLabel.layer.borderWidth = 0.5;
//   resultLabel.layer.borderColor = self.tendencyColor.CGColor;
//   resultLabel.layer.masksToBounds = YES;
//    resultLabel.backgroundColor = _isBadTendency? [UIColor.fe_warningColor colorWithAlphaComponent:0.05] : [UIColor.fe_safeColor colorWithAlphaComponent:0.05];
//
//    CGFloat resultLabelWidth = [_result getWidthForFont:STFont(14)] + STWidth(35);
//    [self addSubview:resultLabel];
//
//    [resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (![NSString isEmptyString:_result]) {
//            make.size.mas_equalTo(CGSizeMake(resultLabelWidth, STWidth(32)));
//            make.top.equalTo(scoreCircleProgressView.mas_bottom).offset(STWidth(5));
//        } else {
//            make.top.equalTo(scoreCircleProgressView.mas_bottom);
//            make.size.mas_equalTo(CGSizeZero);
//        }
//       make.centerX.bottom.mas_equalTo(0);
//
//    }];
   
}

- (UIColor *)tendencyColor {
    return _isBadTendency?UIColor.fe_warningColor:UIColor.fe_safeColor;
}
@end
