//
//  ArticleDetailViewController.h
//  smartapp
//
//  Created by 剑辉  薛 on 2019/7/2.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseViewController.h"
#import "ArticleDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum  DiscoveryArticleSource{
    DiscoveryArticleSourceList,
    DiscoveryArticleSourceSearch,
    DiscoveryArticleSourceBanner
}DiscoveryArticleSource;

@interface ArticleDetailViewController : FEBaseViewController 

@property (nonatomic) DiscoveryArticleSource source;

@property (nonatomic,strong) ArticleDetailsModel *articleModel;

@end

NS_ASSUME_NONNULL_END
