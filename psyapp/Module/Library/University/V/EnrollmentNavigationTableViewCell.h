//
//  EnrollmentNavigationTableViewCell.h
//  smartapp
//
//  Created by lafang on 2019/3/13.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnrollmentNavigationItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EnrollmentNavigationTableViewCell : UITableViewCell

-(void)updateModel:(EnrollmentNavigationItemModel *)enrollmentNavigationItemModel;

@end

NS_ASSUME_NONNULL_END
