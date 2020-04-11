//
//  ArticleDetailsModel.m
//  smartapp
//
//  Created by lafang on 2018/8/25.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "ArticleDetailsModel.h"
#import "EvaluationDetailDimensionsModel.h"
@implementation ArticleDetailsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"articleId":@"id",
             @"articleTitle":@"article_title",
             @"articleImg":@"article_img",
             @"articleContent":@"article_content",
             @"articleVideo":@"article_video",
             @"videoId":@"video_id",
             @"sourceType":@"source_type",
             @"sourceName":@"source_name",
             @"sourceWebUrl":@"source_web_url",
             @"sourceAppUrl":@"source_app_url",
             @"pageView":@"page_view",
             @"pageFavorite":@"page_favorite",
             @"pageLike":@"page_like",
             @"testCount":@"test_count",
             @"isReferenceTest":@"is_reference_test",
             @"contentShort":@"content_short",
             @"tags":@"tags",
             @"source":@"source",
             @"publishDate":@"publish_date",
             @"contentType":@"content_type",
             @"userData":@"user_data",
             @"favorite":@"is_favorite",
             @"like":@"is_like",
             @"showComment":@"show_comment",
             @"topicInfo":@"topic_info",
             @"category":@"category",
             @"mediaTimelong" : @"media_time_long",
             @"hasTest" : @"has_test",
             @"inFreeMode" : @"in_free_mode",
             @"dimensions" : @"dimensions"
             };
}



+ (NSValueTransformer *)dimensionsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:EvaluationDetailDimensionsModel.class];
}

+ (NSValueTransformer *)userDataJSONTransformer {
    
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:ArticleUser.class];
    
}


+ (NSValueTransformer *)topicInfoJSONTransformer {
    
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:ArticleTopicInfo.class];
    
}

+ (NSValueTransformer *)categoryJSONTransformer {
    
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:CategoriesModel.class];
    
}

- (instancetype)initWithAVObject:(AVObject *)object {
    self = [super init];
    self.articleContent = [object objectForKey:@"articleContent"];
    self.articleImg = [object objectForKey:@"articleImg"];
    self.articleTitle = [object objectForKey:@"articleTitle"];
    AVFile *videoFile = [object objectForKey:@"video"];
    self.articleVideo = videoFile.url;
    CategoriesModel *category = CategoriesModel.new;
    category.name = [object objectForKey:@"category"];
    self.category = category;
    self.pageView = [object objectForKey:@"pageView"];
    self.sourceName = [object objectForKey:@"sourceName"];
    return self;
}
@end
