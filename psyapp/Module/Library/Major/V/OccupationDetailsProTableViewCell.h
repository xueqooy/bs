//
//  OccupationDetailsProTableViewCell.h
//  smartapp
//
//  Created by lafang on 2019/3/12.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfessionalCategoryModel.h"
#import "ProfessionalOccupationsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OccupationDetailsProTableViewCell : UITableViewCell

-(void)updateModel:(ProfessionalCategoryModel *)professionalCategoryModel;//职业对口专业

-(void)updateModelPro:(ProfessionalOccupationsModel *)professionalOccupationsModel;//专业对口职业

@end

NS_ASSUME_NONNULL_END
