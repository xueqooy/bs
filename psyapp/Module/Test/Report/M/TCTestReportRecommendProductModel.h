//
//  TCTestReportRecommendProductModel.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/27.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "FEBaseModel.h"
#import "TCProductModel.h"
NS_ASSUME_NONNULL_BEGIN
//@interface TCProductItemBaseModel : FEBaseModel
//@property (nonatomic, copy) NSString *name;
//@property (nonatomic, strong) NSNumber *price;
//@property (nonatomic, strong) NSNumber *originPrice;
//@property (nonatomic, strong) NSNumber *productId;
//@property (nonatomic, copy) NSString *image;
////custom
//@property (nonatomic, assign) CGFloat priceYuan; //人名币元
//@property (nonatomic, assign) CGFloat originPriceYuan; //人名币元
//
//@property (nonatomic, assign) TCProductType productType;
//@end

@interface TCRecommendProductModel : TCProductItemBaseModel
@property (nonatomic, strong) NSNumber *productType_number;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, strong) NSNumber *suitablePeriod;
@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, strong) NSNumber *isBest;
@property (nonatomic, strong) NSNumber *itemUseCount;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *updateTime;
@end

@interface TCTestReportRecommendProductModel : FEBaseModel
@property (nonatomic, copy) NSArray <TCRecommendProductModel *>*recommendCourse;
@property (nonatomic, copy) NSArray <TCRecommendProductModel *>*recommendDimension;

- (NSArray <TCRecommendProductModel *>*)generateThreeRandomTestData;
@end

NS_ASSUME_NONNULL_END
