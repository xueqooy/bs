//
//  OccupationDetailsTableViewCell.h
//  smartapp
//
//  Created by lafang on 2019/3/11.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfessionalIntroducesModel.h"
#import "AddItemViewsManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface OccupationDetailsTableViewCell : UITableViewCell

-(void)updateModel:(ProfessionalIntroducesModel *)professionalIntroducesModel;

@end

NS_ASSUME_NONNULL_END
