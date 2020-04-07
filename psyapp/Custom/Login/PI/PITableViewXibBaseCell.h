//
//  PITableViewBaseCell.h
//  smartapp
//
//  Created by mac on 2019/10/31.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIInputBox.h"
#import "PISelectBox.h"
#import "PIGenderBox.h"
#import "TCCommonButton.h"
#import "PIBoxStateManager.h"
#import "PIModel.h"
#import "PIBirthDaySelector.h"
#import "PIGuardianSelector.h"
typedef void(^CallBack)(PIModel *model);
@interface PITableViewXibBaseCell : UITableViewCell
@property (nonatomic, strong)  PIBoxStateManager *boxManager;

- (void)postInformationSubmissionNoticeWithModel:(PIModel *)model;
@end

