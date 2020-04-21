//
//  FEReportAppraiseView.m
//  smartapp
//
//  Created by mac on 2019/12/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEReportAppraiseView.h"
#import "FEBottomLineLabel.h"
@implementation FEReportAppraiseView {
    NSString *_content;
}

- (instancetype)initWithAppraiseContent:(NSString *)content {
    self = [super init];
    _content = content;
    [self build];
    return self;
}

- (void)build {
    FEBottomLineLabel *headerLabel = [[FEBottomLineLabel alloc] initWithLabelText:@"评价"];
       [self addSubview:headerLabel];
       [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.right.top.offset(0);
           make.height.mas_equalTo([SizeTool height:20]);
       }];
       
       UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = STFontRegular(14);
       contentLabel.textAlignment = NSTextAlignmentJustified;
        contentLabel.textColor = UIColor.fe_titleTextColorLighten;

       [contentLabel setHtmlText:_content lineSpacing:STWidth(7)];
       contentLabel.numberOfLines = 0;
       [contentLabel sizeToFit];
       [self addSubview:contentLabel];
       [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.right.bottom.offset(0);
           make.top.equalTo(headerLabel.mas_bottom).offset([SizeTool width:12]);
       }];
}

@end
