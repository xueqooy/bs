//
//  UITableView+TCRefresh.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/27.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "UITableView+TCHelper.h"



@implementation UIScrollView (MJRefreshHelper)
static char kAssociatedObjectKey_alreadyLoadAllData;
- (void)setAlreadyLoadAllData:(BOOL)alreadyLoadAllData {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_alreadyLoadAllData, [NSNumber numberWithBool:alreadyLoadAllData], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (alreadyLoadAllData) {
        [self.mj_footer endRefreshingWithNoMoreData];
    } else {
        self.mj_footer.state = MJRefreshStateIdle;
    }
}

- (BOOL)alreadyLoadAllData {
    return [objc_getAssociatedObject(self, &kAssociatedObjectKey_alreadyLoadAllData) boolValue];
}

static char kAssociatedObjectKey_footerRefreshAction;
- (void)setFooterRefreshAction:(TCRefreshAction)footerRefreshAction {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_footerRefreshAction, footerRefreshAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (footerRefreshAction != nil) {
        self.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:footerRefreshAction];
        [self initRefreshFooter:(MJRefreshAutoStateFooter *)self.mj_footer];
    } else {
        self.mj_footer = nil;
    }
}

- (TCRefreshAction)footerRefreshAction {
    return objc_getAssociatedObject(self, &kAssociatedObjectKey_footerRefreshAction);
}

static char kAssociatedObjectKey_headerRefreshAction;
- (void)setHeaderRefreshAction:(TCRefreshAction)headerRefreshAction {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_headerRefreshAction, headerRefreshAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (headerRefreshAction != nil) {
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:headerRefreshAction];
        [self initRefreshHeader:(MJRefreshNormalHeader *)self.mj_header];
    } else {
        self.mj_header = nil;
    }
}

- (TCRefreshAction)headerRefreshAction {
    return objc_getAssociatedObject(self, &kAssociatedObjectKey_headerRefreshAction);
}

- (void)addFooterRefreshTarget:(id)target action:(SEL)action {
    NSObject *_target = target;
    if (_target != nil && action != nil && [_target respondsToSelector:action]) {
        self.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:target refreshingAction:action];
        [self initRefreshFooter:(MJRefreshAutoStateFooter *)self.mj_footer];
    } else {
        self.mj_footer = nil;
    }
}

- (void)addHeaderRefreshTarget:(id)target action:(SEL)action {
    NSObject *_target = target;
    if (_target != nil && action != nil && [_target respondsToSelector:action]) {
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
        [self initRefreshHeader:((MJRefreshNormalHeader *)self.mj_header)];
    } else {
        self.mj_header = nil;
    }
}

- (void)initRefreshFooter:(MJRefreshAutoStateFooter *)footer{
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStatePulling];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = STFontRegular(16);
    footer.stateLabel.textColor = UIColor.fe_placeholderColor;
}

- (void)initRefreshHeader:(MJRefreshNormalHeader *)header {
    header.arrowView.image = nil;
    [header setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新数据" forState:MJRefreshStatePulling];
    [header setTitle:@"数据加载中···" forState:MJRefreshStateRefreshing];
    header.stateLabel.textColor = UIColor.fe_placeholderColor;
    
    header.lastUpdatedTimeLabel.hidden = YES;
    header.backgroundColor = UIColor.clearColor;
}


@end

@implementation UITableView (ScrollHelper)

- (void)scrollToSection:(NSInteger)section offsetFromTop:(CGFloat)offsetFromTop animated:(BOOL)animated{
    if (section >= self.numberOfSections ) return;
    CGFloat topBottomInset = self.contentInset.top + self.contentInset.bottom;
    CGFloat scrollableHeight = self.contentSize.height + topBottomInset;
    if (scrollableHeight < self.frame.size.height) {
        return;
    }
    
    //offset相当于contentSize
    
    CGRect sectionFrame = [self rectForSection:section];
    CGPoint scrollLocation = CGPointMake(0, sectionFrame.origin.y - offsetFromTop );

    //超出可滚动范围
    if (scrollLocation.y + self.contentInset.top + CGRectGetHeight(self.frame)  > scrollableHeight) {
        scrollLocation.y = scrollableHeight - CGRectGetHeight(self.frame) - self.contentInset.top;
    }
        
    [self setContentOffset:scrollLocation animated:animated];
    
}

@end
