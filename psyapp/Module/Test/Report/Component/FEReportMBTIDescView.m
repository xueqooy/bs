//
//  FEReportMBTIDescView.m
//  smartapp
//
//  Created by mac on 2019/12/9.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEReportMBTIDescView.h"

@implementation FEReportMBTIDescView {
    NSString *_type;
    NSString *_image;
    
    UILabel *_typeLabel;
    UILabel *_imageLabel;
}

- (instancetype)initWithType:(NSString *)type image:(NSString *)image {
    self = [super init];
    _type = type;
    _image = image;
    [self build];
    return self;
}

- (void)build {
    UILabel *typeLabel = [[UILabel alloc] init];
    _typeLabel = typeLabel;
    [self setTypeText];
    typeLabel.numberOfLines = 0;
    [self addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
    }];
   
    UILabel *imageLabel = [[UILabel alloc] init];
    _imageLabel = imageLabel;
    [self setImageText];
    imageLabel.numberOfLines = 0;
    [self addSubview:imageLabel];
    [imageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(typeLabel.mas_bottom).offset(STWidth(5));
        make.left.right.bottom.offset(0);
    }];
}

- (void)setTypeText {
    BOOL isDarkMode = [[FEThemeManager currentTheme].themeName isEqualToString:FEThemeConfigureDarkIdentifier];
    NSString *mainTextColorString = isDarkMode ? @"rgba(255,255,255,0.6)" :@"#303133";
    NSString *highlightedColorString = isDarkMode ? @"#99542a" : @"#FC674F";
    NSString *typeText = [NSString stringWithFormat:@"<span style=\"color:%@\">你的性格类型为<span style=\"color:%@\">%@</span></span>", mainTextColorString, highlightedColorString, _type];
    _typeLabel.attributedText = [StringUtils setupAttributedString:typeText font:STWidth(14)];
}

- (void)setImageText {
    BOOL isDarkMode = [[FEThemeManager currentTheme].themeName isEqualToString:FEThemeConfigureDarkIdentifier];
    NSString *mainTextColorString = isDarkMode ? @"rgba(255,255,255,0.6)" :@"#303133";
    NSString *highlightedColorString = isDarkMode ? @"#99542a" : @"#FC674F";
    
    NSString *imageText = [NSString stringWithFormat:@"<span style=\"color:%@\">典型形象为<span  style=\"color:%@\">%@</span></span>", mainTextColorString, highlightedColorString, _image];
    _imageLabel.attributedText = [StringUtils setupAttributedString:imageText font:STWidth(14)];
}

- (void)qmui_themeDidChangeByManager:(QMUIThemeManager *)manager identifier:(__kindof NSObject<NSCopying> *)identifier theme:(__kindof NSObject *)theme {
    [super qmui_themeDidChangeByManager:manager identifier:identifier theme:theme];
    [self setTypeText];
    [self setImageText];
}
@end
