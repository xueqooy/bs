//
//  TCBannerEventHandler.h
//  CheersgeniePlus
//
//  Created by mac on 2020/4/4.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TCBannerModel;
NS_ASSUME_NONNULL_BEGIN

@interface TCBannerEventHandler : NSObject
+ (void)handleBannerClickForBanner:(TCBannerModel *)banner viewController:(UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
