//
//  FECourseSurplusLabel.h
//  smartapp
//
//  Created by mac on 2019/11/6.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FECourseSurplusView : UIView
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) CGFloat labelHeight;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat arrowWidth;
@end

NS_ASSUME_NONNULL_END
