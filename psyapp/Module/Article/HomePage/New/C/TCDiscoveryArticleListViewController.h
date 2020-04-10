//
//  TCDiscoveryArticleListViewController.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/28.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "FEBaseViewController.h"
#import "TCDiscoveryHomepageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TCDiscoveryArticleListViewController : FEBaseViewController <TCDiscoveryHomepageProtocol>
@property (nonatomic, readonly) UIScrollView *currentScrollView;
@property (nonatomic, copy) void (^verticalScrollViewBlock)(UIScrollView *scrollView);//垂直滚动scrollView变化时回调
@property (nonatomic, copy) void (^horizontalSrollViewBlock)(UIScrollView *contentScrollView, UIScrollView *segmentScrollView);//竖屏滚动scrollView变化时回调
- (void)resetAllScrollViewOffset;


@end

NS_ASSUME_NONNULL_END
