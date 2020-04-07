//
//  FEBottomPopUpView.h
//  smartapp
//
//  Created by mac on 2019/12/20.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FEBottomPopUpViewContainer <NSObject>
@optional
- (void)willShow;
- (void)didShow;
- (void)didHide;
@property (nonatomic, copy) void (^hideAction)(void);
@end

@interface FEBottomPopUpView : UIView <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView <FEBottomPopUpViewContainer>*containerView;
- (void)show;
- (void)hide;
@property (nonatomic, assign) BOOL clickBackgroundToHideEnable;
@end

NS_ASSUME_NONNULL_END
