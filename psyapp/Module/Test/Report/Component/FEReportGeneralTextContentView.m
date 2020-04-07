//
//  FEReportGeneralTextContentView.m
//  smartapp
//
//  Created by mac on 2019/12/9.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEReportGeneralTextContentView.h"

@implementation FEReportGeneralTextContentView {
    NSString *_text;
}

- (instancetype)initWithText:(NSString *)text {
    self = [super init];
    _text = text;
    [self build];
    return self;
}

- (void)build {
    UILabel *label = [[UILabel alloc] init];
    label.text = _text? _text : @"";
    label.textColor = UIColor.fe_titleTextColorLighten;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

@end
