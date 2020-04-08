//
//  UniversityTableViewCell.h
//  smartapp
//
//  Created by lafang on 2019/3/5.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversityModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UniversityTableViewCell : UITableViewCell

@property(nonatomic,assign)NSInteger index;

-(void)updateModel:(UniversityModel *) universityModel rankFilter:(NSString *)rankFilter isLastRow:(BOOL)ilr;

@end

NS_ASSUME_NONNULL_END
