//
//  FEEvaluationCareerReportCollectionViewCell.h
//  smartapp
//
//  Created by mac on 2019/12/9.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEEvaluationReportCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface FEEvaluationCareerReportCollectionViewCell : FEEvaluationReportCollectionViewCell
@property (nonatomic, copy) void (^occupationRecommendTagClickHandler)(NSInteger idx);
@end

NS_ASSUME_NONNULL_END
