//
//  FESlidingHintView.m
//  smartapp
//
//  Created by mac on 2019/10/10.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FESlidingHintView.h"
#import "UIImage+Category.h"
@interface FESlidingHintView ()
@property (nonatomic, weak) NSTimer *arrowAniTimer;
@end

@implementation FESlidingHintView {
    NSArray *_arrowImages;
    UIImageView *_leftImageView;
    UIImageView *_rightImageView;
    UIImageView *_leftArrowImageView;
    UIImageView *_rightArrowImageView;
    UILabel *_leftLabel;
    UILabel *_rightLabel;
    
    NSInteger _leftAniIndex;
    NSInteger _rightAniIndex;

}
static FESlidingHintView *singleView;
static const CGFloat kHintHeight = 40;
static const CGFloat kHintWidth = 110;

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect _frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight);
    self = [super initWithFrame:_frame];
    //self.userInteractionEnabled = NO;
    _arrowImages = @[@"exam_arrow_left_3", @"exam_arrow_left_2", @"exam_arrow_left_1", @"exam_arrow_right_3", @"exam_arrow_right_2", @"exam_arrow_right_1"];
    [self setupSubviews];
    _leftAniIndex = 0;
    _rightAniIndex = 3;
    _arrowAniTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changeArrowImage) userInfo:nil repeats:YES];
   
    return self;
}

+ (void)show {
    [self showToView:mKeyWindow];
}

+ (void)showToView:(UIView *)view {
    if (!singleView) {
        singleView = [self new];
    }
    singleView->_leftImageView.hidden = NO;
    singleView->_rightImageView.hidden = NO;
    [view addSubview:singleView];
}

+ (void)hide {
    if (singleView) {
        [singleView removeFromSuperview];
        singleView = nil;
    }
    [singleView.arrowAniTimer invalidate];
}

+ (void)showPrevious {
    if (!singleView) {
        singleView = [self new];
    }
    singleView->_leftImageView.hidden = NO;
    singleView->_rightImageView.hidden = YES;
    [mKeyWindow addSubview:singleView];
}

+ (void)showPreviousWithHint:(NSString *)hint {
    if (!singleView) {
        singleView = [self new];
    }
    singleView->_leftLabel.text = hint;
    [self showPrevious];
}

+ (void)showNext {
    if (!singleView) {
        singleView = [self new];
    }
    singleView->_leftImageView.hidden = YES;
    singleView->_rightImageView.hidden = NO;
    [mKeyWindow addSubview:singleView];
}

+ (void)showNextWithHint:(NSString *)hint {
    if (!singleView) {
        singleView = [self new];
    }
    singleView->_rightLabel.text = hint;
    [self showNext];
}

- (void)setupSubviews {
 
    CGSize hintSize = STSize(kHintWidth, kHintHeight);
    
    UIImage *leftGradientImage = [UIImage getGradientImageWithColors:@[mHexColor(@"232548"), [UIColor clearColor]] locations:@[@0, @1] startPoint:CGPointMake(0, STWidth(kHintHeight / 2)) endPoint:CGPointMake(STWidth(kHintWidth), STWidth(kHintHeight / 2)) imageSize:hintSize];
    UIImage *rightGradientImage = [UIImage getGradientImageWithColors:@[[UIColor clearColor], mHexColor(@"232548")] locations:@[@0, @1] startPoint:CGPointMake(0, STWidth(kHintHeight / 2)) endPoint:CGPointMake(STWidth(kHintWidth), STWidth(kHintHeight / 2)) imageSize:hintSize];
    _leftImageView = [[UIImageView alloc] initWithImage:leftGradientImage];
    _rightImageView = [[UIImageView alloc] initWithImage:rightGradientImage];
    _leftLabel = [UILabel createLabelWithDefaultText:@"右滑上一题" numberOfLines:1 textColor:[UIColor whiteColor] font:STFontBold(12)];
    _rightLabel = [UILabel createLabelWithDefaultText:@"左滑下一题" numberOfLines:1 textColor:[UIColor whiteColor] font:STFontBold(12)];
    _leftArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_arrowImages[_leftAniIndex]]];
    _rightArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_arrowImages[_rightAniIndex]]];
    
    [self addSubview:_leftImageView];
    [self addSubview:_rightImageView];
    [_leftImageView addSubview:_leftArrowImageView];
    [_rightImageView addSubview:_rightArrowImageView];
    [_leftImageView addSubview:_leftLabel];
    [_rightImageView addSubview:_rightLabel];
   
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(hintSize);
        make.centerY.left.mas_equalTo(0);
    }];
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(hintSize);
        make.centerY.right.mas_equalTo(0);
    }];
    [_leftArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(STSize(14, 10));
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(STWidth(15));
    }];
    [_rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.size.mas_equalTo(STSize(14, 10));
           make.centerY.mas_equalTo(0);
           make.right.mas_equalTo(STWidth(-15));
    }];
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftArrowImageView.mas_right).offset(STWidth(6));
        make.centerY.mas_equalTo(0);
    }];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.equalTo(_rightArrowImageView.mas_left).offset(STWidth(-6));
           make.centerY.mas_equalTo(0);
    }];
}

- (void)changeArrowImage {
    _leftAniIndex ++;
    _rightAniIndex ++;
    if (_leftAniIndex == 3) {
        _leftAniIndex = 0;
        _rightAniIndex = 3;
    }
    [_leftArrowImageView setImage:[UIImage imageNamed:_arrowImages[_leftAniIndex]]];
    [_rightArrowImageView setImage:[UIImage imageNamed:_arrowImages[_rightAniIndex]]];

}

//点击事件穿透
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    [FESlidingHintView hide];
    return nil;
}

@end
