//
//  EvaluationDetailDimensionsModel.h
//  smartapp
//
//  Created by mac on 2019/7/26.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface EvaluationDetailDimensionMergeResultModel : FEBaseModel
@property (nonatomic, copy) NSString *result;
@property(nonatomic, strong) NSNumber *isBadTendency;
@end

@interface EvaluationDetailDimensionsModel : FEBaseModel

@property(nonatomic, copy) NSString *topicDimensionID;

@property(nonatomic, strong) NSNumber *reportForbid;
@property(nonatomic, copy) NSString *reportForbidHint;
@property(nonatomic, copy) NSString *topicId;

@property(nonatomic, strong) NSNumber *costTime;
@property(nonatomic, strong) NSNumber *isDuplicate;//是不是重复的量表
@property(nonatomic, strong) NSNumber *isLocked;

@property(nonatomic, copy) NSString *examID;


/**
 C端
 https://www.tapd.cn/22217601/markdown_wikis/#1122217601001001797@toc16
 */
@property(nonatomic, copy) NSString *dimensionID;
@property(nonatomic, copy) NSString *dimensionName;
@property(nonatomic, copy) NSString *childDimensionID;
@property(nonatomic, copy) NSString *descriptionD;
@property(nonatomic, copy) NSString *instruction;
@property(nonatomic, copy) NSString *backgroundImage;
@property(nonatomic, strong) NSNumber *useCount;
@property(nonatomic, strong) NSNumber *questionCount;
@property(nonatomic, strong) NSNumber *estimatedTime;
@property(nonatomic, strong) NSNumber *status;
@property(nonatomic, strong) NSNumber *score;
@property(nonatomic, strong) NSNumber *isBadTendency;
@property(nonatomic, strong) NSNumber *reportStatus; //用于判断status == 0 状态下 如果该值 == 1 则表示报告生成中
@property(nonatomic, copy) NSString *result;
@property (nonatomic, strong) NSNumber *isMergeAnswer;  //是否是合并场景，@1-是
@property (nonatomic, copy) NSArray <EvaluationDetailDimensionMergeResultModel *> *results;
@property (nonatomic, strong) NSNumber *isOwn;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *originPrice;
@property (nonatomic, copy) NSString *targetUser;
@property (nonatomic, copy) NSString *gain;
@property (nonatomic, copy) NSString *whatTest;
@property (nonatomic, copy) NSString *finishTime;
@property (nonatomic, strong) NSNumber *retestGap;
@property (nonatomic, strong) NSNumber *productId;

//custom
@property (nonatomic, assign, readonly) CGFloat priceYuan;
@property (nonatomic, assign, readonly) CGFloat originPriceYuan;

@property(nonatomic, copy) NSString *childExamID;
@property (nonatomic, assign) NSTimeInterval retestRemainTime;

@end

NS_ASSUME_NONNULL_END
