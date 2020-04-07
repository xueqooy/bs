//
//  SharedLabelHeaderView.m
//  CheersgeniePlus
//
//  Created by xueqooy on 2019/7/16.
//  Copyright © 2019 Cheersmind. All rights reserved.
//

#import "SharedLabelHeaderView.h"

@implementation SharedLabelHeaderView
{
    UILabel *headingLabel;
    UILabel *mainBodyLabel;
    
    NSString *headingText;
    NSString *mainText;
}
- (instancetype)initWithHeadingText:(NSString *)heading mainBodyText:(NSString *)main{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = UIColor.fe_contentBackgroundColor;
        headingText = heading;
        mainText = main;
        [self setUpSubviews];
    }
    return self;
}

- (void)setHeadingText:(NSString *)heading {
    headingText = heading;
    headingLabel.text = heading;
}

- (void)setMainBodyText:(NSString *)main {
    mainText = main;
    mainBodyLabel.text = main;
}

- (void)setUpSubviews {
    headingLabel = [UILabel new];
    headingLabel.text = headingText;
    headingLabel.textColor = UIColor.fe_titleTextColor;
    headingLabel.font = STFontBold(30);
    
    mainBodyLabel = [UILabel new];
    mainBodyLabel.text = mainText;
    mainBodyLabel.textColor = mHexColor(@"949494");
    mainBodyLabel.font = STFont(11);
    
    [self addSubview:headingLabel];
    [self addSubview:mainBodyLabel];
    
    [headingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(STWidth(16));
        make.top.equalTo(self).offset([SizeTool originHeight:20]);
    }];
    
    [mainBodyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headingLabel).offset(STWidth(2));
        make.top.equalTo(headingLabel.mas_bottom).offset([SizeTool originHeight:13]);
    }];
}
@end
