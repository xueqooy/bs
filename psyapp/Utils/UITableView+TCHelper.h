//
//  UITableView+TCRefresh.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/27.
//  Copyright © 2020 Cheersmind. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FooterRefreshAction)(void);
@interface UITableView (MJRefreshHelper)
@property (nonatomic, copy) FooterRefreshAction footerRefreshAction;
- (void)addFooterRefreshTarget:(id)target action:(SEL)action;

@property (nonatomic, assign) BOOL alreadyLoadAllData;
@end

@interface UITableView (ScrollHelper)
- (void)scrollToSection:(NSInteger)section offsetFromTop:(CGFloat)offsetFromTop animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
