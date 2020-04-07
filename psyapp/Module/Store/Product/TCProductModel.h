//
//  TCTestProductModel.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/13.
//  Copyright © 2020 Cheersmind. All rights reserved.
// https://www.tapd.cn/22217601/markdown_wikis/#1122217601001001797@toc15

#import "FEBaseModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TCProductItemBaseModel : FEBaseModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *originPrice;
@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, copy) NSString *image;


//custom
@property (nonatomic, assign) CGFloat priceYuan; //人名币元
@property (nonatomic, assign) CGFloat originPriceYuan; //人名币元

@property (nonatomic, assign) TCProductType productType;
@end

@interface TCCourseProductItemModel : TCProductItemBaseModel
@property (nonatomic, copy) NSString *courseId;
@property (nonatomic, copy) NSString *childExamId;
//@property (nonatomic, copy)   NSString *courseName;
@property (nonatomic, copy) NSString *brief; //简介
@property (nonatomic, copy) NSString *introduction; //详细简介
@property (nonatomic, assign) NSString *categoryId; //分类
@property (nonatomic, strong) NSNumber *lessonFinishNum; //课时完成数
@property (nonatomic, strong) NSNumber *lessonNum;       //课时数
@property (nonatomic, copy)   NSString *mainImg;         //主图
//@property (nonatomic, copy) NSString *coverImg;
//@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *courseType ;  //0普通课程、1生涯课程
@property (nonatomic, strong) NSNumber *status;          //课程状态，0-未完成，1-已完成
@property (nonatomic, strong) NSNumber *isOwn;
@property (nonatomic, copy) NSArray <NSString *>*periodName;

//custom
//@property (nonatomic, strong) NSArray <NSNumber*>*periodNums;
@end

@interface TCCourseProductListModel : FEBaseModel
@property (nonatomic, strong) NSNumber *total;
@property (nonatomic, strong) NSMutableArray <TCCourseProductItemModel *>*courses;
@property (nonatomic, assign) NSNumber *hasCareer;
@property (nonatomic, copy)   NSString *careerChildExamId;
@end

@interface TCTestProductItemModel : TCProductItemBaseModel
@property (nonatomic, copy) NSString *dimensionId;
//@property (nonatomic, copy) NSString *dimensionName;
//@property (nonatomic, copy) NSString *backgroundImage;
//@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, strong) NSNumber *userCount;
//@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *isOwn;
@property (nonatomic, strong) NSNumber *status;
@end

@interface TCTestProductListModel : FEBaseModel
@property (nonatomic, strong) NSNumber *total;
@property (nonatomic, strong) NSMutableArray <TCTestProductItemModel *>*items;
@end


NS_ASSUME_NONNULL_END
 
