//
//  FEReportProportionChartView.m
//  smartapp
//
//  Created by mac on 2019/12/9.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEReportProportionChartView.h"
#import "FEProportionProgressBar.h"
@implementation FEReportProportionChartView {
    NSString *_leftName;
    CGFloat _leftPercent;
    NSString *_rightName;
    CGFloat _rightPercent;
}
- (instancetype)initWithLeftName:(NSString *)leftName leftPercent:(CGFloat)leftPercent rightName:(NSString *)rightName rightPercent:(CGFloat)rightPercent {
    self = [super init];
    _leftName = leftName;
    _leftPercent = leftPercent;
    _rightName = rightName;
    _rightPercent = rightPercent;
    [self build];
    return self;
}

- (void)build {
    FEProportionProgressBar *proportionProgressBar = [FEProportionProgressBar new];
    [proportionProgressBar setLeftTitle:_leftName byPercent:_leftPercent andRightTitle:_rightName byPercent:_rightPercent];
    
    [self addSubview:proportionProgressBar];
    [proportionProgressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(STWidth(40));
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}
@end
