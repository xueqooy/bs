//
//  SegmentView.m
//  smartapp
//
//  Created by lafang on 2018/10/11.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "SegmentView.h"
#import "SegmentHeaderView.h"
#import <Masonry/Masonry.h>

#define kWidth self.frame.size.width
#define kHeight self.frame.size.height

@interface PopGestureRecognizeSimultaneouslyScrollView : UIScrollView <UIGestureRecognizerDelegate>

@end
@implementation PopGestureRecognizeSimultaneouslyScrollView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
   if (self.contentOffset.x <= 0) {
       if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
           return YES;
       }
   }
   return NO;
}
@end

@interface SegmentView () <UIScrollViewDelegate>
@property (nonatomic, strong) PopGestureRecognizeSimultaneouslyScrollView *contentScrollView;
@property (nonatomic, strong) SegmentHeaderView *header;
@property (nonatomic, strong) SegmentHeaderView *headerView;

@end


@implementation SegmentView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.headerHeight = STWidth(40);
    self.header = [[SegmentHeaderView alloc] initWithFrame:CGRectZero titleArray:nil];
    return self;
}


- (UIScrollView *)scrollView {
    return self.contentScrollView;
}

- (UIScrollView *)headerScrollView {
    return self.headerView.scrollView;
}

- (void)setTitleArray:(NSArray<NSString *> *)titleArray {
    if (titleArray.count != self.viewControllers.count) return;
    _titleArray = titleArray;
    _headerView.titleArray = _titleArray;
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers parentViewController:(UIViewController *)parentController titles:(NSArray<NSString *> *)titles {
    self.loadedViewControllerIndexSet = [NSMutableIndexSet indexSet];
    _titleArray = titles;
    if (self.headerView ) {
        [self.headerView removeFromSuperview];
        self.headerView = nil;
    }
    _headerView = [[SegmentHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, self.headerHeight) titleArray:titles];
    _headerView.itemWidth = _header.itemWidth;
    _headerView.itemSpacing = _header.itemSpacing;
    _headerView.alignment = _header.alignment;
    _headerView.titleFont = _header.titleFont;
    _headerView.selectedTitleFont = _header.selectedTitleFont;
    _headerView.titleColor = _header.titleColor;
    _headerView.selectedTitleColor = _header.selectedTitleColor;
    _headerView.moveLineHidden = _header.moveLineHidden;
    _headerView.customRightView = _header.customRightView;
    _headerView.customLeftView = _header.customLeftView;
    _headerView.bottomSeparatorHeight = _header.bottomSeparatorHeight;
    [self addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.headerHeight);
    }];
    __weak  typeof(self) weakSelf = self;
    weakSelf.headerView.selectedItemHelper = ^(NSUInteger index) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.contentScrollView setContentOffset:CGPointMake(index * kWidth, 0) animated:NO];
        
        if (index < weakSelf.viewControllers.count) {
            if (weakSelf.onViewControllerSWitch) {
                weakSelf.onViewControllerSWitch(index);
            }
            strongSelf->_selectedIndex = index;
            [weakSelf changeViewControllerToController:weakSelf.viewControllers[index]];
        }
        
    };
    
   
    if (self.contentScrollView) {
        [self.contentScrollView removeFromSuperview];
        self.contentScrollView = nil;
    }
    self.contentScrollView = [PopGestureRecognizeSimultaneouslyScrollView new];
    self.contentScrollView.contentSize = CGSizeMake(kWidth * viewControllers.count, 0);
    self.contentScrollView.delegate = self;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.bounces = NO;
    [self addSubview:self.contentScrollView];
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(self.headerView.mas_bottom).offset(0);
    }];
    
    self.viewControllers = viewControllers;
    self.rootViewController = parentController;
    if (viewControllers.count > 0) {
        UIViewController *firstViewController = viewControllers.firstObject;
        [parentController addChildViewController:firstViewController];
        [firstViewController didMoveToParentViewController:parentController];
        self.currentViewController = firstViewController;
        //至于为什么要设置成0，我也不知道，试验出来的
        CGRect frame = CGRectMake(0, 0, 0, 0);
        firstViewController.view.frame = frame;
        [self.contentScrollView addSubview:firstViewController.view];

        [self.loadedViewControllerIndexSet addIndex:0];
    }
//    [viewControllers enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        UIViewController *controller = obj;
//         [parentController addChildViewController:controller];
//        [self.contentScrollView addSubview:controller.view];
//        [controller.view mas_makeConstraints:^(MASConstraintMaker *make) {
//            if (idx == 0) {
//                make.left.offset(0);
//            } else {
//                make.left.equalTo(viewControllers[idx - 1].view.mas_right);
//            }
//            make.top.offset(0);
//            make.size.equalTo(self.contentScrollView);
//        }];
//    }];
}

- (void)changeViewControllerToController:(UIViewController *)viewController {
    if  (self.currentViewController == viewController) return;
    [self.rootViewController addChildViewController:viewController];
    NSInteger idx = [self.viewControllers indexOfObject:viewController];
    viewController.view.frame = CGRectMake(idx * kWidth, 0, kWidth, kHeight - self.headerHeight);
    [self.contentScrollView addSubview:viewController.view];
    [viewController didMoveToParentViewController:self.rootViewController];
    //加载出来就不移除视图了
    //[self.currentViewController.view removeFromSuperview];
    [self.currentViewController willMoveToParentViewController:nil];
    [self.currentViewController removeFromParentViewController];
    self.currentViewController = viewController;
    
    [self.loadedViewControllerIndexSet addIndex:idx];
    
    if (_didSwitchToViewController ){
        _didSwitchToViewController(self.currentViewController);
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    self.headerView.selectedIndex = selectedIndex;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        scrollView.scrollEnabled = NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    
    NSInteger selectedIndex = _headerView.selectedIndex;
    
    CGFloat floatIdx = offsetX / mScreenWidth;
//    NSInteger roundIdx = round(floatIdx);
    NSInteger floorIdx = floor(floatIdx);
    NSInteger ceilIdx = ceil(floatIdx);

    CGFloat progress;
    NSInteger targetIndex;
    
    if (ceilIdx > selectedIndex) {
        targetIndex = ceilIdx;
        progress = floatIdx - selectedIndex;
    } else {
        targetIndex = floorIdx;
        progress = 1 - floatIdx + floorIdx;
    }
    
    //滚动过快
    if (labs(targetIndex - selectedIndex) > 1) {
        self.headerView.selectedIndex = targetIndex > selectedIndex? selectedIndex + 1 : selectedIndex - 1;
    }
    
    NSLog(@"%f", progress);
     [self.headerView setAppearanceSelectedIndex:targetIndex progress:progress];
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger selectedIndex = (NSUInteger)self.contentScrollView.contentOffset.x / mScreenWidth;
    [self.headerView changeItemWithTargetIndex:selectedIndex];
    scrollView.scrollEnabled = YES;

}

@end

