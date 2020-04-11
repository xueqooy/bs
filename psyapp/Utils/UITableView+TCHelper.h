//
//  UITableView+TCRefresh.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/27.
//  Copyright © 2020 Cheersmind. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TCRefreshAction)(void);
@interface UIScrollView (MJRefreshHelper)
@property (nonatomic, copy) TCRefreshAction footerRefreshAction;
@property (nonatomic, copy) TCRefreshAction headerRefreshAction;

- (void)addFooterRefreshTarget:(id)target action:(SEL)action;
- (void)addHeaderRefreshTarget:(id)target action:(SEL)action;
@property (nonatomic, assign) BOOL alreadyLoadAllData;
@end

@interface UITableView (ScrollHelper)
- (void)scrollToSection:(NSInteger)section offsetFromTop:(CGFloat)offsetFromTop animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
