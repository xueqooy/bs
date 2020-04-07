//
//  PIClassMiddleTableViewCell.m
//  smartapp
//
//  Created by mac on 2019/10/30.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "TCDeviceLoginInfoPerfectionTableViewCell.h"
#import "PIGradeSelector.h"
@interface TCDeviceLoginInfoPerfectionTableViewCell ()
@property (weak, nonatomic) IBOutlet PISelectBox *classBar;
@property (weak, nonatomic) IBOutlet PIGenderBox *genderBar;
@property (weak, nonatomic) IBOutlet TCCommonButton *completeButton;

@end


@implementation TCDeviceLoginInfoPerfectionTableViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _completeButton.userInteractionEnabled = NO;
        _completeButton.layer.cornerRadius = STWidth(2);
        [_classBar setCategory:@"年级" placeholder:@"点击选择年级"];
        _genderBar.title = @"性别";
        _classBar.selector = [PIGradeSelector new];
        
        NSArray *boxes =  @[ _classBar, _genderBar];
        self.boxManager = [[PIBoxStateManager alloc] initWithBoxes:boxes completeButton:_completeButton completedHandler:nil];
         
    }
    return self;
}
 


- (IBAction)completeButtonClicked:(UIButton *)sender {
    PIModel *model = [PIModel new];
    model.gender = _genderBar.selectedIndex == 0? @2 : @1;
    [model setGrade:_classBar.selectedContent];
    if (_onSubmit) {
        _onSubmit(model);
    }
}


@end
