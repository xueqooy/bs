//
//  TCTestReportRecommendProductModel.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/27.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCTestReportRecommendProductModel.h"
@implementation TCRecommendProductModel
- (TCProductType)productType {
    if (self.productType_number) {
        return self.productType_number.integerValue;
    }
    return TCProductTypeUnknown;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"productId" : @"product_id",
        @"name" : @"product_name",
        @"productType_number" : @"product_type",
        @"itemId" : @"item_id",
        @"price" : @"price",
        @"originPrice" : @"price_original",
        @"image" : @"icon",
        @"suitablePeriod" : @"suitable_period",
        @"categoryId" : @"category_id",
        @"isBest" : @"is_best",
        @"itemUseCount" : @"item_use_count",
        @"createTime" : @"create_time",
        @"updateTime" : @"update_time",
    };
}

@end


@implementation TCTestReportRecommendProductModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"recommendCourse" : @"recommand_course",
        @"recommendDimension" : @"recommand_dimension"
    };
}

+ (NSValueTransformer *)recommendCourseJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:TCRecommendProductModel.class];
}

+ (NSValueTransformer *)recommendDimensionJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:TCRecommendProductModel.class];
}

- (NSArray<TCRecommendProductModel *> *)generateThreeRandomTestData {
    NSArray *testData = @[];
    if (self.recommendDimension != nil && ![self.recommendDimension isKindOfClass:NSNull.class]) {
        testData = self.recommendDimension;
    }
   
    NSInteger testCount = testData.count;
    NSMutableArray *data = @[].mutableCopy;
    if (testCount  <= 3) {
        [data addObjectsFromArray:testData];
    } else if (testCount > 3) {
        for (int i = 0; i < 3; i ++) {
            [data addObject: testData[i]];
        }
    }
    return data;
}
@end
