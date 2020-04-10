//
//  FEBaseAlertView.h
//  smartapp
//
//  Created by mac on 2019/8/2.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FEBaseAlertView <NSObject>
@optional
- (UIView *)layoutContainer;
@end

@interface FEBaseAlertView : UIView <FEBaseAlertView>
extern const NSInteger FEBaseAlertViewContainerTag;
@property (nonatomic, weak) UIView *context;

@property (nonatomic, copy) void(^extraHandlerForClickingBackground)(void);
@property (nonatomic, assign) BOOL backgroundTapDisable;
@property (nonatomic, assign) BOOL backgroundTapHideAnimationDisable;
@property (nonatomic, copy) void (^didHideBlock)(void);
- (void)showWithAnimated:(BOOL)animated;
- (void)hideWithAnimated:(BOOL)animated completion:(void(^)(void))completion;
@end

