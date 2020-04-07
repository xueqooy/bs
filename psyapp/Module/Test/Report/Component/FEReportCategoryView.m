//
//  FEReportCategoryView.m
//  smartapp
//
//  Created by mac on 2019/12/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEReportCategoryView.h"

@implementation FEReportCategoryView {
    NSString *_title;
}

- (instancetype)initWithCategoryTitle:(NSString *)title {
    self = [super init];
    _title = title;
    [self build];
    return self;
}

- (void)build {
    UIView *verticalLineView = [UIView new];
    verticalLineView.backgroundColor = UIColor.fe_mainColor;
    [self addSubview:verticalLineView];
    [verticalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(STSize(4, 18));
        make.left.top.offset(0);
        make.bottom.offset(0);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = _title;
    titleLabel.textColor =UIColor.fe_titleTextColorLighten;
    titleLabel.font =STFontBold(18);
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(verticalLineView);
        make.left.equalTo(verticalLineView.mas_right).offset(STWidth(6));
        make.right.offset(0);
    }];
}

@end
