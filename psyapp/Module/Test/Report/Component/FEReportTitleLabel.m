//
//  FEReportTitleLabel.m
//  smartapp
//
//  Created by mac on 2019/12/10.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEReportTitleLabel.h"

@implementation FEReportTitleLabel {
    NSString *_title;
}

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    _title = title;
    [self build];
    return self;
}

- (void)build {
    UILabel *label = [UILabel new];
    label.text = _title;
    label.textColor = UIColor.whiteColor;
    label.font = STFontBold(24);
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

@end
