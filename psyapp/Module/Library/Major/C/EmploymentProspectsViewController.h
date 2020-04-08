//
//  EmploymentProspectsViewController.h
//  smartapp
//
//  Created by lafang on 2019/3/12.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseViewController.h"
#import "ProfessionalDetailRootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EmploymentProspectsViewController : FEBaseViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ProfessionalDetailRootModel *professionalDetailRootModel;

-(void)updateModel:(ProfessionalDetailRootModel *)professionalDetailRootModel;

@end

NS_ASSUME_NONNULL_END
