//
//  ArticleModel.m
//  smartapp
//
//  Created by lafang on 2018/8/25.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "ArticleModel.h"

@implementation ArticleModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"articleId":@"id",
             @"articleTitle":@"article_title",
             @"articleImg":@"article_img",
             @"pageView":@"page_view",
             @"pageFavorite":@"page_favorite",
             @"testCount":@"test_count",
             @"isReferenceTest":@"is_reference_test",
             @"summary":@"summary",
             @"tags":@"tags",
             @"source":@"source_name",
             @"sourceType":@"source_type",
             @"publishDate":@"publish_date",
             @"contentType":@"contentType",
             @"type" : @"type",
             @"category":@"category",
             @"favorite":@"is_favorite",
             @"like":@"is_like",
             @"pageLike" : @"page_like",
             @"articleImgs":@"article_imgs",
             @"categoryName" : @"category_name"
              };
}
//"user_data":[
//    {
//        "user_id":"long",
//        "user_name":"string",
//        "nick_name":"string",
//        "avatar":"string"
//    }
//],

+ (NSValueTransformer *)tagsJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:ArticleModel.class];
}

+ (NSValueTransformer *)categoryJSONTransformer {
    
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:CategoriesModel.class];
    
}


@end
