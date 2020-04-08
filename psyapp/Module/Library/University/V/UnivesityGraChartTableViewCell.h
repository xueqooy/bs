//
//  UnivesityGraChartTableViewCell.h
//  smartapp
//
//  Created by lafang on 2019/3/18.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversityGraduationSettledModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UnivesityGraChartTableViewCell : UITableViewCell

-(void)updateModel:(NSArray<UniversityGraduationSettledModel *> *)universityGraduationSettledModels;

@end

NS_ASSUME_NONNULL_END
