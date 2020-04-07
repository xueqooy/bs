//
//  FEScoreCircleProgressView.m
//  smartapp
//
//  Created by mac on 2019/9/18.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEScoreCircleProgressView.h"

@implementation FEScoreCircleProgressView {
    CAShapeLayer *_trackShapeLayer;
    CAShapeLayer *_dialsShapeLayer;
    CAShapeLayer *_progressShapeLayer;
    
    UILabel *_scoreLabel;
    UILabel *_scoreMinLabel;
    UILabel *_scoreMaxLabel;
    
    CGPoint _origin;
    CGFloat _startAngle;
    CGFloat _maxEndAngle;
    CGFloat _radius;

}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self) {
        self = [super initWithFrame:frame];
        self.backgroundColor = [UIColor clearColor];
        _maxScore = 100;
        _score = 0;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    _origin = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    _radius = CGRectGetWidth(self.bounds) / 2;
    _startAngle = 0.75 * M_PI;
    _maxEndAngle = 0.25 * M_PI;
    
    _trackShapeLayer = [CAShapeLayer layer];
    _trackShapeLayer.fillColor = [UIColor clearColor].CGColor;
    _trackShapeLayer.strokeColor = UIColor.fe_buttonBackgroundColorActive.CGColor;
    _trackShapeLayer.lineWidth = CGRectGetWidth(self.bounds) * 0.09;
    _trackShapeLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:_trackShapeLayer];
    
    _dialsShapeLayer = [CAShapeLayer layer];
    _dialsShapeLayer.fillColor = [UIColor clearColor].CGColor;
    _dialsShapeLayer.strokeColor = UIColor.fe_placeholderColor.CGColor;
    _dialsShapeLayer.lineWidth = STWidth(5);
    _dialsShapeLayer.lineDashPattern = @[@1, @6];
    [self.layer addSublayer:_dialsShapeLayer];
    
    _progressShapeLayer = [CAShapeLayer layer];
    _progressShapeLayer.lineCap = kCALineCapRound;
    _progressShapeLayer.fillColor = [UIColor clearColor].CGColor;
    _progressShapeLayer.strokeColor = UIColor.fe_safeColor.CGColor;
    _progressShapeLayer.lineWidth = CGRectGetWidth(self.bounds) * 0.09;
    [self.layer addSublayer:_progressShapeLayer];

    _scoreLabel = [UILabel createLabelWithDefaultText:@"" numberOfLines:1 textColor:UIColor.fe_titleTextColorLighten font:[UIFont fontWithName:@"PingFangSC-Semibold" size: STWidth(36)]];
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    _scoreLabel.frame = self.bounds;
    [self addSubview:_scoreLabel];
    
    _scoreMinLabel = [UILabel createLabelWithDefaultText:@"0" numberOfLines:1 textColor:UIColor.fe_placeholderColor font:STFont(9)];
    [self addSubview:_scoreMinLabel];
    _scoreMinLabel.frame = CGRectMake(0.257 * CGRectGetWidth(self.bounds), 0.707  * CGRectGetHeight(self.bounds), STWidth(20), STWidth(10));
    [_scoreMinLabel sizeToFit];
    
    _scoreMaxLabel = [UILabel createLabelWithDefaultText:[NSString stringWithFormat:@"%.0f", _maxScore] numberOfLines:1 textColor:UIColor.fe_placeholderColor font:STFont(9)];
    [self addSubview:_scoreMaxLabel];
    _scoreMaxLabel.frame = CGRectMake(0.657 * CGRectGetWidth(self.bounds), 0.707  * CGRectGetHeight(self.bounds), STWidth(20), STWidth(10));
    [_scoreMaxLabel sizeToFit];
    
    UIBezierPath *trackPath = [UIBezierPath bezierPathWithArcCenter:_origin radius:_radius startAngle:_startAngle endAngle:_maxEndAngle clockwise:YES];
    _trackShapeLayer.path = trackPath.CGPath;
    
    UIBezierPath *dialsPath = [UIBezierPath bezierPathWithArcCenter:_origin radius:_radius - STWidth(14) startAngle:_startAngle endAngle:_maxEndAngle clockwise:YES];
    _dialsShapeLayer.path = dialsPath.CGPath;
}

- (void)setProgress:(CGFloat)progress {
    if (_progress == progress) return;
    _progress = progress;
    
    _score = _maxScore * progress;
    _scoreLabel.text = [self fomartForScore:_score];
    
    [self drawProgressLayerWithProgress:_progress];
}

- (void)setScore:(CGFloat)score {
    if (_score == score) return;
    _score = score;
    
    _scoreLabel.text = [self fomartForScore:score];
    
    _progress = score / _maxScore;
    
    [self drawProgressLayerWithProgress:_progress];
}

- (void)setScoreString:(NSString *)scoreString {
    if ([_scoreString isEqualToString:scoreString]) return;
    _scoreString = scoreString;
    _scoreLabel.text = _scoreString;
    _progress = _scoreString.floatValue / _maxScore;
    [self drawProgressLayerWithProgress:_progress];

}

- (void)setMaxScore:(CGFloat)maxScore {
    if (_maxScore == maxScore) return;
    _maxScore = maxScore;
    _scoreMaxLabel.text = [NSString stringWithFormat:@"%.0f", _maxScore];
    _progress = _score / _maxScore;
    
    [self drawProgressLayerWithProgress:_progress];
}

- (NSString *)fomartForScore:(CGFloat)score {
    NSString *scoreString = [NSString stringWithFormat:@"%f", score];
    if ([scoreString containsString:@"."]){//取消小数点后2位
        NSRange range = [scoreString rangeOfString:@"."];
        NSString *behindDotString = [scoreString substringFromIndex:range.location];
        if (behindDotString.length > 2) {
            scoreString = [scoreString substringToIndex:range.location + 2];
        }
    }
    return scoreString;
}

- (void)drawProgressLayerWithProgress:(CGFloat)progress {
    CGFloat endAngle = _startAngle + progress * M_PI * 1.5;
    
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:_origin radius:_radius startAngle:_startAngle endAngle:endAngle clockwise:YES];
    _progressShapeLayer.path = progressPath.CGPath;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    _progressTintColor = progressTintColor;
    _progressShapeLayer.strokeColor = progressTintColor.CGColor;
}

- (void)setTrackTintColor:(UIColor *)trackTintColor {
    _trackTintColor = trackTintColor;
    _trackShapeLayer.strokeColor = trackTintColor.CGColor;
}
@end
