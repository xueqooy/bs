//
//  TCDiscoverySearchResultModel.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/22.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface TCDimensionSearchResultItemModel : FEBaseModel
@property (nonatomic, copy) NSString *dimensionId;
@property (nonatomic, copy) NSString *dimensionName;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, strong) NSNumber *useCount;
@property (nonatomic, strong) NSNumber *isOwn;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *originPrice;
@property (nonatomic, strong) NSNumber *status;

//custom
@property (nonatomic, assign) CGFloat priceYuan;
@property (nonatomic, assign) CGFloat originPriceYuan;

@end

@interface TCDimensionSearchResultModel : FEBaseModel
@property (nonatomic, strong) NSNumber *total;
@property (nonatomic, strong) NSMutableArray <TCDimensionSearchResultItemModel *>*items;
@end

@interface TCCourseSearchResultItemModel : FEBaseModel
@property (nonatomic, copy) NSString *courseId;
@property (nonatomic, copy) NSString *courseName;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, strong) NSNumber *lessonNum;
@property (nonatomic, strong) NSNumber *lessonFinishNum;
@property (nonatomic, copy) NSArray <NSString *>*periodName;
@property (nonatomic, strong) NSNumber *courseType;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *originPrice;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, strong) NSNumber *isOwn;

//custom
@property (nonatomic, assign) CGFloat priceYuan;
@property (nonatomic, assign) CGFloat originPriceYuan;

@end

@interface TCCourseSearchResultModel : FEBaseModel
@property (nonatomic, strong) NSNumber *total;
@property (nonatomic, strong) NSMutableArray <TCCourseSearchResultItemModel *>*items;
@end

@interface TCArticleSearchResultItemModel : FEBaseModel
@property (nonatomic, copy) NSString *articleId;
@property (nonatomic, copy) NSString *articleTitle;
@property (nonatomic, copy) NSString *articleImage;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, strong) NSNumber *counterValue;
@property (nonatomic, strong) NSNumber *contentType;
@end

@interface TCArticleSearchResultModel : FEBaseModel
@property (nonatomic, strong) NSNumber *total;
@property (nonatomic, strong) NSMutableArray <TCArticleSearchResultItemModel *>*items;
@end

@interface TCDiscoverySearchResultModel : FEBaseModel
@property (nonatomic, strong) TCDimensionSearchResultModel *dimension;
@property (nonatomic, strong) TCCourseSearchResultModel *course;
@property (nonatomic, strong) TCArticleSearchResultModel *article;

@property (nonatomic, strong) NSNumber *searchArticle;
@property (nonatomic, strong) NSNumber *searchDimension;
@property (nonatomic, strong) NSNumber *searchProduct;

@end

NS_ASSUME_NONNULL_END
