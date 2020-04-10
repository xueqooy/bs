//
//  TCArticleLoader.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/28.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
@class ArticleDetailsModel;

NS_ASSUME_NONNULL_BEGIN

@interface TCArticleLoader : NSObject
@property (nonatomic, class, readonly) NSURL *webURL;

+ (void)loadArticle:(ArticleDetailsModel *)article onWebView:(WKWebView *)webView WithCompletion:(void (^)(BOOL success))completion;
@end

NS_ASSUME_NONNULL_END
