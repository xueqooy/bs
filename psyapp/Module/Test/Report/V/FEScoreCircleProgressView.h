//
//  FEScoreCircleProgressView.h
//  smartapp
//
//  Created by mac on 2019/9/18.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FEScoreCircleProgressView : UIView
//这2个属性互相影响
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat score;
@property (nonatomic, copy) NSString *scoreString;
@property (nonatomic, assign) CGFloat maxScore;

@property (nonatomic,strong) UIColor *progressTintColor;
@property (nonatomic, strong) UIColor *trackTintColor;
@end

NS_ASSUME_NONNULL_END
