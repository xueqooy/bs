//
//  FireSelectDefaultView.m
//  smartapp
//
//  Created by lafang on 2018/9/19.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEAnswerCollectionCell.h"
#import "FEAnswerSelectionCell.h"
#import "FEAnswerMergeSelectionCell.h"


@interface FEAnswerCollectionCell ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;

@property(nonatomic,strong) NSArray<OptionModel *> *single_options;
@property(nonatomic,strong) QuestionChildModel *single_answer;
@property(nonatomic,assign) NSInteger option_index;
@property (nonatomic, assign) NSInteger single_selectedIndex;
@property (nonatomic, copy)   NSString *single_answerText;

@property (nonatomic, strong) NSMutableArray <NSNumber *>*merge_selectedIndexes;
@property (nonatomic, strong) NSMutableArray <NSString *>*merge_answerTexts;;


@property (nonatomic, assign) BOOL isSpeakingTitle;

@property (nonatomic, assign) BOOL isMerge;

@end
#define SingleSelectionCellPrimaryHeight STWidth(60)
#define MergeSelectionCellHeight STWidth(91)
@implementation FEAnswerCollectionCell


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.textColor = UIColor.fe_titleTextColorLighten;
        self.titleLabel.font = STFont(18);
        self.titleLabel.numberOfLines = 0;
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(STWidth(15));
            make.right.equalTo(self).offset(-STWidth(15));
            make.top.equalTo(self).offset(0);
        }];
        
        self.tableView = [[UITableView alloc] init];
        self.tableView.backgroundColor = UIColor.fe_contentBackgroundColor;
        self.tableView.tableFooterView = ({
            UIView *tableFooterView = [UIView new];
            tableFooterView.frame = CGRectMake(0, 0, mScreenWidth, [SizeTool width:120]);
            tableFooterView;
        });
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(STWidth(20));
            make.bottom.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
        }];
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}



-(void)setSingle_question:(FEQuestionModel *)single_question{
    _isMerge = NO;
    _single_question = single_question;
    _single_options = _single_question.options;
    _single_answer = single_question.childQuestion;
    _single_selectedIndex = - 1;
    _single_answerText = @"";
    
    if(_single_answer){
        for(int i = 0; i < _single_options.count; i ++){
            if([_single_options[i].optionId isEqualToString: _single_answer.optionId]){
                _single_selectedIndex = i;
                _single_answerText = _single_answer.optionText;
                break;
            }
        }
    }
    
    [self.titleLabel setText:_single_question.stem lineSpacing:STWidth(2)];
    
    
    [self.tableView registerClass:[FEAnswerSelectionCell class] forCellReuseIdentifier:NSStringFromClass([FEAnswerSelectionCell class])];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
    

}

- (void)setMerge_question:(FEMergeQuestionModel *)merge_question {
    _isMerge = YES;
    _merge_question = merge_question;
    _merge_selectedIndexes = @[].mutableCopy;
    _merge_answerTexts = @[].mutableCopy;
    for (int i = 0; i < _merge_question.subQuestions.count; i ++) {
        FEMergeSubquestionModel *subquestion = _merge_question.subQuestions[i];
        NSInteger selectedIndex = -1;
        NSString *answerText = @"";
        if (subquestion.answers && subquestion.answers.optionID != nil) {
            NSArray <FEMergeSubquestionOptionModel*> *options = _merge_question.options;
            for (int j = 0; j < options.count; j ++) {
                FEMergeSubquestionOptionModel *option = options[j];
                if ([option.optionID isEqualToString:subquestion.answers.optionID]) {
                    selectedIndex = j;
                    //answerText = option.content;//合并答题暂时没有文本输入类型的
                    break;
                }
            }
        }
        [_merge_selectedIndexes addObject:@(selectedIndex)];
        [_merge_answerTexts addObject:answerText];
    }
    
    [self.titleLabel setText:_merge_question.stem lineSpacing:STWidth(2)];
    
    [self.tableView registerClass:[FEAnswerMergeSelectionCell class] forCellReuseIdentifier:NSStringFromClass([FEAnswerMergeSelectionCell class])];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isMerge == NO) {
        return _single_options.count;
    } else {
        return _merge_question.subQuestions.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return _isMerge? 0 :STWidth(10);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isMerge) {
        return MergeSelectionCellHeight;
    } else {
        CGFloat estimatedCellHeight = [self getContentTextHeightForSingleOption:_single_options[indexPath.section]];
        if (estimatedCellHeight < SingleSelectionCellPrimaryHeight) {
            return SingleSelectionCellPrimaryHeight;
        } else {
            return estimatedCellHeight;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (_isMerge) {
        return nil;
    } else {
        UIView *footerView = [UIView new];
        footerView.backgroundColor = UIColor.fe_contentBackgroundColor;
        return  footerView;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_isMerge) {
        FEAnswerSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FEAnswerSelectionCell class]) forIndexPath:indexPath];
        [cell setOptionIndex:indexPath.section optionText:_single_answerText selectIndex:_single_selectedIndex optionModel:_single_options[indexPath.section] questionChildModel:_single_answer];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        @weakObj(self);
        cell.answeredHandler = ^(NSInteger optionIndex,NSString *optionText) {
            @strongObj(self);
            self.single_selectedIndex = optionIndex;
            self.single_answerText = optionText;
            [self.tableView reloadData];
            if(self.answeredHandler){
                self.answeredHandler(@(optionIndex), optionText, -1);
            }
        };
        return cell;
    } else {
        FEAnswerMergeSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FEAnswerMergeSelectionCell class]) forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        NSMutableArray <NSString *>*options = @[].mutableCopy;
        for (int i = 0; i < _merge_question.options.count; i++) {
            FEMergeSubquestionOptionModel *option = _merge_question.options[i];
            [options addObject:option.content];
        }
        
        [cell setSelectedIndex:_merge_selectedIndexes[indexPath.section].integerValue options:options subject:_merge_question.subQuestions[indexPath.section].subStem];
  

        @weakObj(self);
        cell.answeredHandler = ^(NSInteger optionIndex, NSString * _Nonnull optionText) {
            @strongObj(self);
            
            //保存
            if(self.answeredHandler){
                self.answeredHandler(@(optionIndex), optionText, indexPath.section);
            }
            
            self.merge_selectedIndexes[indexPath.section] = @(optionIndex);
            self.merge_answerTexts[indexPath.section] = optionText;//目前无用
            
        
            //判断是否全部回答
            BOOL allAnswered = YES;
            for (NSNumber *index in self.merge_selectedIndexes) {
                if ([index isEqualToNumber:@(-1)]) {
                    allAnswered = NO;
                }
            }
            
            if (allAnswered) {
                [self.tableView reloadData];

                if (self.merge_allSubquestionAnsweredHandler) {
                    self.merge_allSubquestionAnsweredHandler();
                }
            }
        };
        
        return cell;
        
    }
    
}


- (CGFloat)getContentTextHeightForSingleOption:(OptionModel *)option {
    NSString *content = option.content;
    CGFloat textHeight = [content getHeightForFont:STFont(16) width:mScreenWidth - STWidth(60)];
    return textHeight;
}

@end
