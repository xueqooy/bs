//
//  FEMergeAnswerModel.h
//  smartapp
//
//  Created by mac on 2019/11/11.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

@interface FEMergeSubquestionAnswerModel : FEBaseModel
@property (nonatomic, copy) NSString *optionID;
@property (nonatomic, copy) NSString *optionText;
@end

@interface FEMergeSubquestionOptionModel : FEBaseModel
@property (nonatomic, copy) NSString *optionID;
@property (nonatomic, copy) NSString *content;
@end

@interface FEMergeSubquestionModel : FEBaseModel
@property (nonatomic, copy) NSString *childFactorID;
@property (nonatomic, copy) NSString *subStem;
@property (nonatomic, copy) FEMergeSubquestionAnswerModel *answers;

@end

@interface FEMergeQuestionModel : FEBaseModel
@property (nonatomic, copy) NSString *questionID;
@property (nonatomic, copy) NSString *stem;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, copy) NSArray <FEMergeSubquestionOptionModel *>*options;
@property (nonatomic, copy) NSArray <FEMergeSubquestionModel *>*subQuestions;
@end


