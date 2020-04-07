//
//  TCProductCategoryModel.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/13.
//  Copyright © 2020 Cheersmind. All rights reserved.
//  https://www.tapd.cn/22217601/markdown_wikis/#1122217601001001797@toc13

#import "FEBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TCProductCategoryModel <T>: FEBaseModel
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, copy) NSString *backgroundImage;
@property (nonatomic, copy) NSString *backgroundColor;
@property (nonatomic, copy) NSString *icon;


//custom (弃用)
- (void)setProductList:(T)productList;
- (T)productList;
@end

NS_ASSUME_NONNULL_END
