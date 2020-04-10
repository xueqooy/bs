//
//  TCDicoveryBannerViewController.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/28.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCDiscoveryHomepageProtocol.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCDiscoveryBannerViewController : UIViewController <TCDiscoveryHomepageProtocol>
@property (nonatomic, readonly) UIScrollView *bannerScrollView;

- (void)setNeedsBannerAdDisplay;
- (void)displayBannerAdIfNeeded;
@end

NS_ASSUME_NONNULL_END
