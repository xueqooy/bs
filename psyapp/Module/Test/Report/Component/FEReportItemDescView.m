//
//  FEReportItemDescView.m
//  smartapp
//
//  Created by mac on 2019/12/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEReportItemDescView.h"

@implementation FEReportItemDescView {
    NSString *_itemDesc;
    NSString *_score;
    NSString *_scoreDesc;
    NSString *_appraisal;
    NSString *_suggest;
    NSString *_maxScore;
    
    UILabel *_scoreDescLabel;
}

- (instancetype)initWithItemDesc:(NSString *)itemDesc score:(NSString *)score maxScore:(NSString *)maxScore scoreDesc:(NSString *)scoreDesc appraisal:(NSString *)appraisal suggest:(NSString *)suggest {
    self = [super init];
    _itemDesc = itemDesc;
    _score = score;
    _maxScore = maxScore;
    _scoreDesc = scoreDesc;
    _appraisal = appraisal;
    _suggest = suggest;
    [self build];
    return self;
}

- (void)build {
     CGFloat lineSpacing = STWidth(6);
     MASViewAttribute *lastViewAtttribute = self.mas_top;

     if (![NSString isEmptyString:_itemDesc]) {
         UILabel *itemDescLabel = [[UILabel alloc] init];
         itemDescLabel.numberOfLines = 0;
         [self addSubview:itemDescLabel];
         itemDescLabel.attributedText = [StringUtils setupAttributedString:_itemDesc font:STWidth(14)];
         itemDescLabel.textColor = UIColor.fe_mainTextColor;
         [itemDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.left.right.offset(0);
         }];
         lastViewAtttribute = itemDescLabel.mas_bottom;
     }
     
     if (![NSString isEmptyString:_score]) {
         UILabel *scoreDescLabel = [[UILabel alloc] init];
         _scoreDescLabel = scoreDescLabel;
         scoreDescLabel.numberOfLines = 0;
         [self setScoreDescText];
         [self addSubview:scoreDescLabel];
         [scoreDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(lastViewAtttribute).offset(lineSpacing);
             make.left.right.offset(0);
         }];
         lastViewAtttribute = scoreDescLabel.mas_bottom;
     }

     UILabel *appraisalLabel = [[UILabel alloc] init];
     appraisalLabel.numberOfLines = 0;
     [self addSubview:appraisalLabel];
     if(![NSString isEmptyString:_appraisal]) {
         appraisalLabel.attributedText = [StringUtils setupAttributedString:_appraisal font:STWidth(14)];
         appraisalLabel.textColor = UIColor.fe_mainTextColor;
         [appraisalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(lastViewAtttribute).offset(lineSpacing);
             make.left.right.offset(0);
         }];
        lastViewAtttribute = appraisalLabel.mas_bottom;
     }
    
     
     //建议
     UILabel *suggestLabel = [[UILabel alloc] init];
     suggestLabel.numberOfLines = 0;
     [self addSubview:suggestLabel];
     if (![NSString isEmptyString:_suggest]) {
         suggestLabel.attributedText = [StringUtils setupAttributedString:_suggest font:STWidth(14)];
         suggestLabel.textColor = UIColor.fe_mainTextColor;
         [suggestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(lastViewAtttribute).offset(lineSpacing);
             make.left.right.bottom.offset(0);
         }];
     } else {
         [suggestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(lastViewAtttribute).offset(0);
             make.left.right.bottom.offset(0);
         }];
     }
}

- (void)setScoreDescText {
    BOOL isDarkMode = [[FEThemeManager currentTheme].themeName isEqualToString:FEThemeConfigureDarkIdentifier];
    NSString *mainTextColorString = isDarkMode ? @"rgba(255,255,255,0.6)" :@"#606266";
    NSString *highlightedColorString = isDarkMode ? @"#99542a" : @"#ff8b45";
    
    UILabel *scoreDescLabel = _scoreDescLabel;
    scoreDescLabel.numberOfLines = 0;
    NSMutableString *scoreString = [NSMutableString stringWithFormat:@"%@", _score];
    if ([scoreString containsString:@"."]){//取消小数点后2位
         NSRange range = [scoreString rangeOfString:@"."];
         NSString *behindDotString = [scoreString substringFromIndex:range.location];
         if (behindDotString.length > 2) {
             scoreString = [scoreString substringToIndex:range.location + 2].mutableCopy;
         }
    }
    scoreString = [NSString stringWithFormat:@"<span style=\"color:%@\">在本测评中你的得分为<span style=\"color:%@\">%@</span>分", mainTextColorString, highlightedColorString, scoreString].mutableCopy;
    if (![NSString isEmptyString:_maxScore]) {
         [scoreString appendFormat:@"(总分%@分)", _maxScore];
    }
    if (![NSString isEmptyString:_scoreDesc]) {
        [scoreString appendFormat:@"，%@", _scoreDesc];
    }
     
   
    [scoreString appendString:@"</span>"];
     

    scoreDescLabel.attributedText = [StringUtils setupAttributedString:scoreString font:STWidth(14)];
}

- (void)qmui_themeDidChangeByManager:(QMUIThemeManager *)manager identifier:(__kindof NSObject<NSCopying> *)identifier theme:(__kindof NSObject *)theme {
    [super qmui_themeDidChangeByManager:manager identifier:identifier theme:theme];
    //重新设置text
    if (![NSString isEmptyString:_score]) {
        [self setScoreDescText];
    }
}


@end
