//
//  ZYProGressView.m
//  ProgressBar
//
//  Created by Apple on 2017/4/12.
//  Copyright © 2017年 xueqooy. All rights reserved.
//

#import "FEProgressBar.h"
#import "FastClickUtils.h"
@interface FEProgressBar() <UIGestureRecognizerDelegate>
@property (nonatomic, assign, readwrite) BOOL reverse;
@end

@implementation FEProgressBar
{
    UIImageView *progressview;
    UIView *trackView;
    BOOL _animated;
    NSTimeInterval _duration;
    CGFloat _damping;
    
    UITapGestureRecognizer *tgr;
    
    MASConstraint *verticalContraint;
    
    //渐变色相关
    NSArray *_colors;
    NSArray *_locations;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _reverse = NO;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    
    trackView = [[UIView alloc]init];
    trackView.backgroundColor = [UIColor grayColor];
    [self addSubview:trackView];
    [trackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    progressview = [[UIImageView alloc]init];
    progressview.backgroundColor = [UIColor redColor];
    [trackView addSubview:progressview];
    [progressview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    

}
//设置渐变参数
- (void)setGradientProgressWithColors:(NSArray<NSNumber *> *)colors locations:(NSArray<NSNumber *> *)locations{
    _colors = colors;
    _locations = locations;
}


- (void)setCornerRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
    progressview.layer.cornerRadius = radius;
}

- (void)setRoundCorner:(BOOL)roundCorner {
    _roundCorner = roundCorner;
    [self setNeedsDisplay];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    if (_roundCorner) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = self.bounds.size.height / 2;
        progressview.clipsToBounds = YES;
        progressview.layer.cornerRadius = self.bounds.size.height / 2;;
    }
    
}

-(void)setProgress:(CGFloat)progress
{
    _progress = progress;
    //延迟至下一个runloop来刷新视图
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat width = CGRectGetWidth(trackView.frame) * progress;
        if (_animated) {
            [UIView animateWithDuration:_duration?_duration:2.f delay:0 usingSpringWithDamping:_damping?_damping:0.5 initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [progressview mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(width);
                    make.top.mas_equalTo(0);
                    make.bottom.mas_equalTo(0);
                    if (_reverse) {
                       verticalContraint = make.right.mas_equalTo(0);
                    } else {
                       verticalContraint = make.left.mas_equalTo(0);
                    }
                }];
                [self layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                    [self addGradient];
            }];
        } else {
            [progressview mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(width);
                make.top.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
                if (_reverse) {
                    verticalContraint = make.right.mas_equalTo(0);
                } else {
                    verticalContraint = make.left.mas_equalTo(0);
                }
            }];
            [self addGradient];
        }
       
    });

}
//设置动画
- (void)setAnimated:(BOOL)animated withDuration:(NSTimeInterval)duration damping:(CGFloat)damping{
    _animated = animated;
    _duration = duration;
    _damping = damping;
}

-(void)setTrackTintColor:(UIColor *)trackTintColor
{
    _trackTintColor = trackTintColor;
    trackView.backgroundColor = trackTintColor;
}

-(void)setProgressTintColor:(UIColor *)progressTintColor
{
    _progressTintColor = progressTintColor;
    progressview.backgroundColor = progressTintColor;
}

//设置点击自动反正
- (void)setClickToReverse:(BOOL)clickToReverse {
    if (_clickToReverse != clickToReverse) {
        _clickToReverse = clickToReverse;
        if (clickToReverse) {
            if (!tgr) {
                tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reverseAction:)];
            }
            [self addGestureRecognizer:tgr];
        } else {
            [self removeGestureRecognizer:tgr];
        }
    }
}

//设置反转
- (void)setReverse:(BOOL)reverse{
  
    if (reverse != _reverse) {
        _reverse = reverse;

        if (verticalContraint) { //已经布局progress
            if (reverse == YES) {
                [verticalContraint uninstall];
        
                if (!_animated) {
                    [progressview mas_updateConstraints:^(MASConstraintMaker *make) {
                        verticalContraint = make.right.mas_equalTo(0);
                    }];
                } else {
                    [UIView animateWithDuration:_duration delay:0 usingSpringWithDamping:_damping initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        [progressview mas_updateConstraints:^(MASConstraintMaker *make) {
                            verticalContraint = make.right.mas_equalTo(0);
                        }];
                        [self layoutIfNeeded];
                    } completion:nil];
                }
            } else {
                [verticalContraint uninstall];

                if (!_animated) {
                    [progressview mas_updateConstraints:^(MASConstraintMaker *make) {
                        verticalContraint = make.left.mas_equalTo(0);
                    }];
                } else {
                    [UIView animateWithDuration:_duration delay:0 usingSpringWithDamping:_damping initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        [progressview mas_updateConstraints:^(MASConstraintMaker *make) {
                            verticalContraint = make.left.mas_equalTo(0);
                        }];
                        [self layoutIfNeeded];
                    } completion:nil];
                }
            }
        } else { //还没布局好progressView的话
            
        }
    }
}

//点击手势动作，反转progress
- (void)reverseAction:(UIGestureRecognizer *)sender {
     if ([FastClickUtils isFastClick]) return;
    [self setReverse:!_reverse];
}

//使用Quartz生成渐变图
- (void)addGradient {
    if (_colors.count/4 != _locations.count || _colors.count%4 != 0) return;
    
    CGFloat colors_c[_colors.count];
    CGFloat locations_c[_colors.count];
    for (int i = 0; i < _colors.count; i ++) {
        colors_c[i] = [_colors[i] floatValue];
    }
    
    for (int j = 0; j < _locations.count; j ++) {
        locations_c[j] = [_locations[j] floatValue];
    }
    
    CGFloat width = CGRectGetWidth(self.frame) * _progress;
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGGradientRef cggr;
    CGColorSpaceRef cgcs;
    size_t num = _locations.count;
    cgcs = CGColorSpaceCreateDeviceRGB();
    cggr = CGGradientCreateWithColorComponents(cgcs, colors_c, locations_c, num);
    CGPoint startPoint, endPoint;
    startPoint = CGPointMake(0.0, 0.0);
    endPoint = CGPointMake(width ,height);
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextDrawLinearGradient(ctx, cggr, startPoint, endPoint, 0);
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    [progressview setImage:gradientImage];
    progressview.layer.masksToBounds = YES;
    UIGraphicsEndImageContext();
}



@end
