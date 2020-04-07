//
//  TCProductCategoryModel.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/13.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCProductCategoryModel.h"

@implementation TCProductCategoryModel {
    id _productList;
}
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"categoryName" : @"name",
        @"categoryId" : @"id",
        @"backgroundImage" : @"background_img",
        @"backgroundColor" : @"background_color",
        @"icon" : @"icon"
    };
}

- (void)setProductList:(id)productList {
    _productList = productList;
}

- (id)productList {
    return _productList;
}
@end
