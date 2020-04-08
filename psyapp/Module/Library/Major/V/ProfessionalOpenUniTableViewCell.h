//
//  ProfessionalOpenUniTableViewCell.h
//  smartapp
//
//  Created by lafang on 2019/3/14.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversityModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfessionalOpenUniTableViewCell : UITableViewCell

-(void)updateModel:(UniversityModel *)universityModel;

@end

NS_ASSUME_NONNULL_END
