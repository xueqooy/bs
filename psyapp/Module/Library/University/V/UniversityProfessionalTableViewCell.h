//
//  UniversityProfessionalTableViewCell.h
//  smartapp
//
//  Created by lafang on 2019/3/22.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversityMajorModel.h"
#import "UniversityKeySubjectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UniversityProfessionalTableViewCell : UITableViewCell

-(void)updateProfessionalData:(UniversityMajorModel *) universityMajorModel;

-(void)updateKeySubjectData:(UniversityKeySubjectModel *) universityKeySubjectModel index:(NSInteger) index;

@end

NS_ASSUME_NONNULL_END
