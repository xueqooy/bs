//
//  StudentSummaryTableViewCell.h
//  smartapp
//
//  Created by lafang on 2019/3/18.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentDataModel.h"
#import "StudentRatioModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StudentSummaryTableViewCell : UITableViewCell

-(void)updateModel:(StudentDataModel *)studentDataModel studentRatioModel:(StudentRatioModel *)studentRatioModel;

@end

NS_ASSUME_NONNULL_END
