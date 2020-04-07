//
//  FEBottomLineLabel.m
//  smartapp
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBottomLineLabel.h"

@implementation FEBottomLineLabel

- (instancetype)initWithLabelText:(NSString *)text {
    self = [super init];
    if (self) {
        _text = text;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    UIView *titleContainer = [UIView new];
    titleContainer.backgroundColor = UIColor.fe_contentBackgroundColor;
    [self addSubview:titleContainer];
    [titleContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIView *bottomLineView = [UIView new];
    bottomLineView.backgroundColor = UIColor.fe_mainColor;
    bottomLineView.layer.cornerRadius = [SizeTool height:3];
    
    UILabel *titleLabel = [UILabel createLabelWithDefaultText:_text
                                                numberOfLines:1
                                                    textColor:UIColor.fe_titleTextColorLighten
                                                         font:mFontBold(16)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat width = [_text getWidthForFont:mFontBold(16)];
    
    [titleContainer addSubview:bottomLineView];
    [titleContainer addSubview:titleLabel];
    
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, [SizeTool height:6]));
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomLineView).offset(2);
        make.centerX.mas_equalTo(0);
    }];
}
@end
