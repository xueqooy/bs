//
//  TCTestProductModel.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/13.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCProductModel.h"

@implementation TCProductItemBaseModel
- (instancetype)init {
    self = [super init];
    self.productType = TCProductTypeUnknown;
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"name" : @"name",
        @"image" : @"image",
        @"productId" : @"product_id",
        @"price" : @"price",
        @"originPrice" : @"price_original"
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

@implementation TCCourseProductItemModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"courseId" : @"course_id",
        @"productId" : @"product_id",
        @"name" : @"course_name",
        @"brief" : @"brief",
        @"introduction" : @"introduction",
        @"categoryId" : @"category_id",
        @"mainImg" : @"main_img",
        @"image" : @"cover_img",
        @"price" : @"price",
        @"originPrice" : @"price_original",
        @"courseType" : @"course_type",
        @"isOwn" : @"is_own",
        @"lessonNum" : @"lesson_num",
        @"lessonFinishNum" : @"lesson_finish_num",
        @"status" : @"status",
        @"childExamId" : @"child_exam_id",
        @"periodName" : @"period_name"
    };
}

//- (NSArray<NSNumber *> *)periodNums {
//    NSMutableArray *temp = @[].mutableCopy;
//    for (NSString *periodString in self.periodName) {
//
//        NSNumber *periodNumber = @(PeriodIntFromString(periodString));
//        [temp addObject:periodNumber];
//    }
//    return temp;
//}

@end

@implementation TCCourseProductListModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"total" : @"total",
        @"courses" : @"courses",
        @"hasCareer" : @"has_career",
        @"careerChildExamId" : @"child_exam_id"
    };
}

+ (NSValueTransformer *)coursesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:TCCourseProductItemModel.class];
}
@end

@implementation TCTestProductItemModel
- (instancetype)init {
    self = [super init];
    self.productType = TCProductTypeTest;
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"dimensionId" : @"dimension_id",
        @"name" : @"dimension_name",
        @"image" : @"background_image",
        @"productId" : @"product_id",
        @"userCount" : @"use_count",
        @"price" : @"price",
        @"originPrice" : @"price_original",
        @"isOwn" : @"is_own",
        @"status" : @"status"
    };
}
@end

@implementation TCTestProductListModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"total" : @"total",
        @"items" : @"items"
    };
}

+ (NSValueTransformer *)itemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:TCTestProductItemModel.class];
}
@end
