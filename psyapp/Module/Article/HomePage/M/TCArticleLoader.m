//
//  TCArticleLoader.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/28.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCArticleLoader.h"
#import "ArticleDetailsModel.h"
#import "EvaluationDetailDimensionsModel.h"
#import "TCJSONHelper.h"
@implementation TCArticleLoader
+ (NSURL *)webURL {
    NSURL *URL = [NSBundle.mainBundle URLForResource:@"webView" withExtension:@"html"];
    return URL;
}

+ (void)loadArticle:(ArticleDetailsModel *)article onWebView:(WKWebView *)webView WithCompletion:(nonnull void (^)(BOOL))completion {
    if (!webView) {
        if (completion) completion(NO);
        return;
    }
    
    if (!article) {
        if (completion) completion(NO);
        return;
    }
    
    NSMutableDictionary *params = @{}.mutableCopy;

    if (article.dimension_JSON && ![article.dimension_JSON isKindOfClass:NSNull.class]) {
        [params setObject:article.dimension_JSON forKey:@"dimensions"];
    }
    
    if (NO == [NSString isEmptyString:article.articleContent]) {
        [params setObject:article.articleContent forKey:@"article_content"];
    }
    
    [params setObject:@"false" forKey:@"overdue"];
    
    if (NO == [NSString isEmptyString:article.childExamId]) {
        [params setObject:article.childExamId forKey:@"child_exam_id"];
    }

    NSString *jsonString  =  [TCJSONHelper JSONStringWithDictionary:params];
    NSString *js = [NSString stringWithFormat:@"JSBridge.getData(%@);", jsonString];

    [webView evaluateJavaScript:js completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        if (error) {
            if (completion) completion(NO);
        } else {
            if (completion) completion(YES);
        }
    }];
}
@end
