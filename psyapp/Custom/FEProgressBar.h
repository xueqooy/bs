//
//  FEProgressBar.h
//  ProgressBar
//
//  Created by Apple on 2017/4/12.
//  Copyright © 2017年 xueqooy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FEProgressBar : UIView

@property (nonatomic,assign) CGFloat progress;

@property (nonatomic,strong) UIColor *progressTintColor;

@property (nonatomic,strong) UIColor *trackTintColor;

@property (nonatomic, assign, readonly) BOOL reverse;

@property (nonatomic, assign) BOOL clickToReverse;

@property (nonatomic, assign) BOOL roundCorner;

- (void)setReverse:(BOOL)reverse;

- (void)setGradientProgressWithColors:(NSArray <NSNumber *>*)colors locations:(NSArray <NSNumber *>*)locations;

- (void)setCornerRadius:(CGFloat)radius;

- (void)setAnimated:(BOOL)animated withDuration:(NSTimeInterval)duration damping:(CGFloat)damping;
@end



