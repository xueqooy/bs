//
//  SwipeUpInteractiveTransition.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/21.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SwipeUpInteractiveTransition : UIPercentDrivenInteractiveTransition
/// 手势中...
@property (nonatomic, assign) BOOL isInteracting;
/// 完成动画
@property (nonatomic, assign) BOOL shouldComplete;
// 初始化
- (instancetype)initWithGestureViewController:(UIViewController *)gestureVC;

@end

NS_ASSUME_NONNULL_END
