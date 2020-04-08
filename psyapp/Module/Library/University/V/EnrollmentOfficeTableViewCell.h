//
//  EnrollmentOfficeTableViewCell.h
//  smartapp
//
//  Created by lafang on 2019/3/13.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnrollmentOfficeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EnrollmentOfficeTableViewCell : UITableViewCell

-(void)updateModel:(NSString *)contentStr key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
