//
//  UniversityRankingTableViewCell.h
//  smartapp
//
//  Created by lafang on 2019/3/14.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversityRankingItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UniversityRankingTableViewCell : UITableViewCell

-(void)updateModel:(UniversityRankingItemModel *)universityRankingItemModel;

@end

NS_ASSUME_NONNULL_END
