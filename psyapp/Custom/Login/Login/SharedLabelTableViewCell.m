//
//  SharedLabelTableViewCell.m
//  smartapp
//
//  Created by mac on 2019/7/20.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "SharedLabelTableViewCell.h"

@implementation SharedLabelTableViewCell
{
    UILabel *headingLabel;
    UILabel *mainBodyLabel;
    
    NSString *headingText;
    NSString *mainText;
}

- (void)setHeadingText:(NSString *)heading mainBodyText:(NSString *)main {
    headingText = heading;
    mainText = main;
    headingLabel.text = heading;
    [mainBodyLabel setText:main lineSpacing:STWidth(3)];
    mainBodyLabel.textColor = UIColor.fe_mainTextColor;
    mainBodyLabel.font = STFontRegular(14);
    mainBodyLabel.numberOfLines = 0;
//    CGFloat hheight = [heading getHeightForFont:mFontBold(16) width:[SizeTool width:345]];
//    CGFloat mheight = [main getHeightForFont:mFont(14) width:[SizeTool width:345]];
//    [headingLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(hheight);
//    }];
//    [mainBodyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(mheight);
//    }];
    
}

- (void)setUpSubviews {
   
    headingLabel = [UILabel new];
    headingLabel.text = headingText;
    headingLabel.textColor = UIColor.fe_titleTextColorLighten;
    headingLabel.font = STFontBold(16);
    headingLabel.numberOfLines = 0;
    
    mainBodyLabel = [UILabel new];
    
    [self.contentView addSubview:headingLabel];
    [self.contentView addSubview:mainBodyLabel];

    
    [headingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset([SizeTool width:15]);
        make.right.equalTo(self.contentView).offset(-[SizeTool width:15]);
        make.top.equalTo(self.contentView).offset([SizeTool height:15]);
    }];
    
    [mainBodyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset([SizeTool width:15]);
        make.right.equalTo(@(-[SizeTool width:15]));
        make.top.equalTo(headingLabel.mas_bottom).offset([SizeTool height:10]);
    }];
    

}

@end
