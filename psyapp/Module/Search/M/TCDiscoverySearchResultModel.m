//
//  TCDiscoverySearchResultModel.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/22.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCDiscoverySearchResultModel.h"

@implementation TCDimensionSearchResultItemModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"dimensionId" : @"dimension_id",
        @"dimensionName" : @"dimension_name",
        @"categoryName" : @"category_name",
        @"useCount" : @"use_count",
        @"isOwn" : @"isOwn",
        @"image" : @"image",
        @"price" : @"price",
        @"originPrice" : @"price_original",
        @"status" : @"status",
    };
}

- (CGFloat)priceYuan {
    if (_price) {
        return _price.floatValue / 100;
    } else {
        return 0;
    }
}

- (CGFloat)originPriceYuan {
    if (_originPrice) {
        return _originPrice.floatValue / 100;
    } else {
        return 0;
    }
}
@end

@implementation TCDimensionSearchResultModel : FEBaseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"total" : @"total",
        @"items" : @"items"
    };
}

+ (NSValueTransformer *)itemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:TCDimensionSearchResultItemModel.class];
}
@end

@implementation TCCourseSearchResultItemModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"courseId" : @"course_id",
        @"courseName" : @"course_name",
        @"categoryName" : @"category_name",
        @"lessonNum" : @"lesson_num",
        @"lessonFinishNum" : @"lesson_finish_num",
        @"periodName" : @"period_name",
        @"courseType" : @"course_type",
        @"price" : @"price",
        @"originPrice" : @"price_original",
        @"image" : @"image",
        @"isOwn" : @"is_own",
    };
}

- (CGFloat)priceYuan {
    if (_price) {
        return _price.floatValue / 100;
    } else {
        return 0;
    }
}

- (CGFloat)originPriceYuan {
    if (_originPrice) {
        return _originPrice.floatValue / 100;
    } else {
        return 0;
    }
}
@end

@implementation TCCourseSearchResultModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"total" : @"total",
        @"items" : @"items"
    };
}

+ (NSValueTransformer *)itemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:TCCourseSearchResultItemModel.class];
}
@end

@implementation TCArticleSearchResultItemModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"articleId" : @"id",
        @"articleTitle" : @"article_title",
        @"articleImage" : @"article_img",
        @"categoryName" : @"category_name",
        @"counterValue" : @"counter_value",
        @"contentType"  : @"content_type"
    };
}
@end

@implementation TCArticleSearchResultModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"total" : @"total",
        @"items" : @"items"
    };
}

+ (NSValueTransformer *)itemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:TCArticleSearchResultItemModel.class];
}
@end

@implementation TCDiscoverySearchResultModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"dimension" : @"dimension",
        @"course" : @"course",
        @"article" : @"article",
        @"searchArticle" : @"search_article",
        @"searchDimension" : @"search_dimension",
        @"searchProduct" : @"search_product"
    };
}
@end
