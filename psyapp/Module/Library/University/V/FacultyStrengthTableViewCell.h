//
//  FacultyStrengthTableViewCell.h
//  smartapp
//
//  Created by lafang on 2019/3/13.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniverSitynameItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FacultyStrengthTableViewCell : UITableViewCell

@property(nonatomic,strong)UniverSitynameItemModel *univerSitynameItemModel;

-(void)updateModel:(UniverSitynameItemModel *)univerSitynameItemModel;

@end

NS_ASSUME_NONNULL_END
