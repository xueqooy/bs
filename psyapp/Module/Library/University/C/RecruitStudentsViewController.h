//
//  RecruitStudentsViewController.h
//  smartapp
//
//  Created by lafang on 2019/3/12.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseViewController.h"
#import "UniversitySituationModel.h"
#import "AddItemViewsManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecruitStudentsViewController : FEBaseViewController

@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic,strong) UniversitySituationModel *universitySituationModel;

-(void)updateModel:(UniversitySituationModel *)universitySituationModel;

@end

NS_ASSUME_NONNULL_END
