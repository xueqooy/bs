//
//  FEReportAppraiseView.m
//  smartapp
//
//  Created by mac on 2019/12/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEReportAppraiseView.h"
#import "TCTestTitleLabelView.h"
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
    TCTestTitleLabelView * view = TCTestTitleLabelView.new;
    view.titleText = @"评价";
    view.mainText = _content;
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

@end
