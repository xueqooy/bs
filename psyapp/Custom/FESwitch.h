//
//  FESwitch.h
//  smartapp
//
//  Created by mac on 2019/8/21.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^FESwitchHandler)(BOOL on);
@interface FESwitch : UIView
@property(nonatomic, strong) UIColor *offTintColor;
@property(nonatomic, strong) UIColor *onTintColor;
@property(nonatomic, strong) UIColor *thumbTintColor;
@property(nonatomic, strong) UIColor *thumbShadowColor;

@property(nonatomic, strong) UIView *attachView; //在左边
@property(nonatomic, assign) NSTimeInterval switchAnimationDuration;
@property(nonatomic, assign) BOOL on;
@property(nonatomic, copy)   FESwitchHandler switchHandler;

- (void)setOn:(BOOL)on hasHandler:(BOOL)has;
@end

NS_ASSUME_NONNULL_END
