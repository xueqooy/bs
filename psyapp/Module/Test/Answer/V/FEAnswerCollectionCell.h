//
//  FireSelectDefaultView.h
//  smartapp
//
//  Created by lafang on 2018/9/19.
//  Copyright © 2018年 jeyie0. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FEQuestionModel.h"
#import "FEMergeQuestionModel.h"
typedef void(^QuestionAnsweredHandler)(NSNumber *optionIndex ,NSString *optionText, NSInteger merge_subquestion_index);
typedef void(^MergeQuestionAllAnsweredHandler)(void);
@interface FEAnswerCollectionCell : UICollectionViewCell

@property(nonatomic,strong) FEQuestionModel *single_question;
@property (nonatomic, strong) FEMergeQuestionModel *merge_question;
//每一题答完回调
@property(nonatomic,copy) QuestionAnsweredHandler answeredHandler;
//合并题型。全部答完，页面切换下一页
@property(nonatomic, copy)  MergeQuestionAllAnsweredHandler merge_allSubquestionAnsweredHandler;

- (void)showSpeechAnimatedImageViewAtIdx:(NSInteger )idx;
- (void)hideSpeechAnimatedImageView;
@end

@interface FEAnswerCollectionCell (MergeQuestion)
@end
