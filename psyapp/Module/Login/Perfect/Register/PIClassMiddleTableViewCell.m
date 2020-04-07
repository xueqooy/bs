//
//  PIClassMiddleTableViewCell.m
//  smartapp
//
//  Created by mac on 2019/10/30.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "PIClassMiddleTableViewCell.h"
//#import "PIGradeSelector.h"

#import "TCPeriodSelectionView.h"
@interface PIClassMiddleTableViewCell ()
@property (weak, nonatomic) IBOutlet PIInputBox *nickBar;
@property (weak, nonatomic) IBOutlet PIInputBox *nameBar;
@property (weak, nonatomic) IBOutlet PISelectBox *classBar;
@property (weak, nonatomic) IBOutlet PIGenderBox *genderBar;


@property (weak, nonatomic) IBOutlet TCCommonButton *completeButton;

@end


@implementation PIClassMiddleTableViewCell 

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _completeButton.userInteractionEnabled = NO;
        _completeButton.layer.cornerRadius = STWidth(2);

        [_nickBar setCategory:@"昵称" placeholder:@"2-12位数字/英文/中文"];
        [_nameBar setCategory:@"姓名" placeholder:@"设置姓名"];
        [_classBar setCategory:@"年级" placeholder:@"点击选择年级"];
        _genderBar.title = @"性别";
        TCPeriodSelectionView *selectionView = [[TCPeriodSelectionView alloc] initWithOptions:@[@"高一", @"高二", @"高三"] selectedIndex:-1];
        selectionView.onSelected = ^(NSString * _Nonnull content, NSInteger index) {
        };
        _classBar.selector = selectionView;
        
        NSArray *boxes =  @[_nickBar, _nameBar, _classBar, _genderBar];
        self.boxManager = [[PIBoxStateManager alloc] initWithBoxes:boxes completeButton:_completeButton completedHandler:nil];
         
    }
    return self;
}
 
- (void)setExistingNickname:(NSString *)nickname {
    if ([NSString isEmptyString:nickname]) {
        self.nickBar.inputEnabled = YES;
        return;
    }
    self.nickBar.inputEnabled = NO;
    self.nickBar.inputedContent = nickname;
    
    self.boxManager.completeCount ++;
}

- (IBAction)completeButtonClicked:(UIButton *)sender {
    PIModel *model = [PIModel modelWithName:_nameBar.inputedContent nick:_nickBar.inputedContent birthDay:@"" gender:_genderBar.selectedIndex == 0? @2 : @1];
    [model setGrade:_classBar.selectedContent];
    [self postInformationSubmissionNoticeWithModel:model];
}

@end
