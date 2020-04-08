//
//  OccupationTableViewCell.h
//  smartapp
//
//  Created by lafang on 2019/3/11.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfessionalOccupationsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OccupationTableViewCell : UITableViewCell

-(void)updateModel:(ProfessionalOccupationsModel*) occupationModel isLastRow:(BOOL)ilr;
- (void)updateWithName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
