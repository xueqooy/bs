//
//  SegmentView.h
//  smartapp
//
//  Created by lafang on 2018/10/11.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentHeaderView.h"

@interface SegmentView : UIView
@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) UIScrollView *headerScrollView;

@property (nonatomic, weak) UIViewController *rootViewController;
@property (nonatomic, strong) NSArray <UIViewController *>* viewControllers;
@property (nonatomic, weak)  UIViewController *currentViewController;
@property (nonatomic, copy) NSArray <NSString *>*titleArray;
@property (nonatomic, strong) NSMutableIndexSet *loadedViewControllerIndexSet;//保存加载过的viewController索引
@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, strong, readonly) SegmentHeaderView *header; //用于设置header样式

- (void)setViewControllers:(NSArray <UIViewController *>*)viewControllers  parentViewController:(UIViewController *)parentController titles:(NSArray <NSString *>*)titles ;

@property (nonatomic, copy) void (^onViewControllerSWitch)(NSInteger idx);
@property (nonatomic, copy) void (^didSwitchToViewController)(UIViewController *viewController);

@end

