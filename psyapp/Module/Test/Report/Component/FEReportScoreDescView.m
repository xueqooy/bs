//
//  FEReportScoreDescView.m
//  smartapp
//
//  Created by mac on 2019/12/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEReportScoreDescView.h"

@implementation FEReportScoreDescView {
    NSNumber *_score;
    NSString *_desc;
    
    UILabel *_scoreDescLabel;
}

- (instancetype)initWithScore:(NSNumber *)score desc:(NSString *)desc {
    self = [super init];
    _score = score;
    _desc = desc;
    [self build];
    return self;
}

- (void)build {
    //分数说明
      UILabel *scoreDescLabel = [[UILabel alloc] init];
      _scoreDescLabel = scoreDescLabel;
      scoreDescLabel.numberOfLines = 0;
      scoreDescLabel.textAlignment = NSTextAlignmentJustified;
      [self setScoreDescText];
      [self addSubview:scoreDescLabel];
      [scoreDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          make.edges.mas_equalTo(UIEdgeInsetsZero);
          
      }];
}

- (void)setScoreDescText {
    BOOL isDarkMode = [[FEThemeManager currentTheme].themeName isEqualToString:FEThemeConfigureDarkIdentifier];
    NSString *mainTextColorString = isDarkMode ? @"rgba(255,255,255,0.6)" :@"#303133";
    NSString *highlightedColorString = isDarkMode ? @"#99542a" : @"#ff8b45";
    
    NSString *scoreStr = @"";
    if (![NSString isEmptyString:_desc]) {
        scoreStr = [NSString stringWithFormat:@"<span style=\"color:%@\">在本测评中你的得分为<span style=\"color:%@\">%@</span>分，%@</span>", mainTextColorString, highlightedColorString,[NSString formatFloatNumber:_score AfterDecimalPoint:1] , _desc];
    } else {
        scoreStr = [NSString stringWithFormat:@"<span style=\"color:%@\">本测评中你的得分为<span style=\"color:%@\">%@</span>分。</span>", mainTextColorString, highlightedColorString, [NSString formatFloatNumber:_score AfterDecimalPoint:1] ];
    }
    _scoreDescLabel.attributedText = [StringUtils setupAttributedString:scoreStr font:STWidth(14)];
}

- (void)qmui_themeDidChangeByManager:(QMUIThemeManager *)manager identifier:(__kindof NSObject<NSCopying> *)identifier theme:(__kindof NSObject *)theme {
    [super qmui_themeDidChangeByManager:manager identifier:identifier theme:theme];
    [self setScoreDescText];
}

@end
