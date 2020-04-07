//
//  FEDimensionFiveScoreView.m
//  smartapp
//
//  Created by mac on 2019/12/23.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEDimensionFiveScoreView.h"
@implementation FEDimensionFiveScoreView {
    CGFloat _index;
    
    UILabel *_recommendIndexLabel;
    NSMutableArray *_starImageArray;
}

- (instancetype)init {
    self = [super init];
    self.backgroundColor = UIColor.fe_buttonBackgroundColorActive;
    _index = 0;
    [self setupSubviews];
    return self;
}

- (void)setupSubviews {
    UILabel *recommendTextLabel = [UILabel createLabelWithDefaultText:@"推荐指数" numberOfLines:1 textColor:UIColor.fe_titleTextColor font:STFontBold(16)];
    recommendTextLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:recommendTextLabel];
    [recommendTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(STWidth(15));
        make.centerY.offset(0);
    }];
    
    _recommendIndexLabel = [UILabel createLabelWithDefaultText:[NSString formatFloatNumber:@(_index) AfterDecimalPoint:1] numberOfLines:1 textColor:mHexColor(@"#FFBF40") font:STFont(16)];
    [self addSubview:_recommendIndexLabel];
    [_recommendIndexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.equalTo(recommendTextLabel.mas_right).offset(STWidth(10));
    }];
    
    UIView *fiveScoreContainer = [UIView new];
    [self addSubview:fiveScoreContainer];
    [fiveScoreContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo((_recommendIndexLabel.mas_right)).offset(STWidth(9));
        make.centerY.offset(0);
        make.size.mas_equalTo(STSize(121, 17));
    }];
    
   
    
    _starImageArray = @[].mutableCopy;
    for (int i = 0; i < 5; i ++) {
        UIImageView *imageView = UIImageView.new;
        UIImage *image = [UIImage imageNamed:@"star_inactive"];
        imageView.image = image;
        [fiveScoreContainer addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(STSize(17, 17));
            make.centerY.offset(0);
            make.left.offset(STWidth(17 + 9) * i);
        }];
        [_starImageArray addObject:imageView];
    }
}


- (void)setIndex:(CGFloat)index {
    if (_index == index) return;
    for (int i = 0; i < 5; i ++) {
        UIImageView *imageView = _starImageArray[i];
        imageView.image = [UIImage imageNamed:@"star_inactive"];
    }
    
    _index = index;
    _recommendIndexLabel.text = [NSString formatFloatNumber:@(_index) AfterDecimalPoint:1];
    NSInteger fullStarCount = floor(_index);
    for (int i = 0; i < fullStarCount; i ++) {
        UIImageView *imageView = _starImageArray[i];
        imageView.image = [UIImage imageNamed:@"star_active"];
    }
    
    if (_index > fullStarCount && _index <= 5) {
        UIImageView *imageView = _starImageArray[fullStarCount];
        imageView.image = [UIImage imageNamed:@"star_half"];
    }
}
@end
