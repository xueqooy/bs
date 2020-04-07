//
//  FERectSpreadTransition.h
//  TransitionTest
//
//  Created by xueqooy on 2019/12/25.
//  Copyright © 2019年 GraduationpProject. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum FERectSpreadTransitionType {
    FERectSpreadTransitionPresent,
    FERectSpreadTransitionDismiss
} FERectSpreadTransitionType;
@interface FERectSpreadTransition : NSObject <UIViewControllerAnimatedTransitioning>
+ (instancetype)transitionWithType:(FERectSpreadTransitionType)type;

@property (nonatomic, assign) FERectSpreadTransitionType type;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) UIView *targetView;

@property (nonatomic, copy) void(^didEndTransition)(FERectSpreadTransitionType type);
@end
