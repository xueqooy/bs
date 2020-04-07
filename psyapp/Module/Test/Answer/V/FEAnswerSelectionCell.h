//
//  FireSelectDefaultTableViewCell.h
//  smartapp
//
//  Created by lafang on 2018/9/19.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionModel.h"
#import "QuestionChildModel.h"


@interface FEAnswerSelectionCell : UITableViewCell

@property(nonatomic,strong) OptionModel *optionModel;
@property(nonatomic, copy) void(^answeredHandler)(NSInteger optionIndex, NSString *optionText);
@property(nonatomic,assign) NSInteger curOptionIndex;
@property(nonatomic,strong) NSString *optionText;
@property(nonatomic,strong) QuestionChildModel *questionChildModel;

-(void)setOptionIndex:(NSInteger)optionIndex optionText:(NSString *)optionText selectIndex:(NSInteger)selectIndex optionModel:(OptionModel *)optionModel questionChildModel:(QuestionChildModel *)questionChildModel;

@end
