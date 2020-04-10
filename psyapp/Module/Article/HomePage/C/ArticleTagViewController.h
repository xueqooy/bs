//
//  ArticleTagViewController.h
//  smartapp
//
//  Created by lafang on 2018/10/10.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEBaseViewController.h"
#import "TCCategroyModel.h"
//#import "CategoriesModel.h"
@class TCNestedSimultaneousTableView;
@interface ArticleTagViewController : FEBaseViewController

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) TCCategroyModel *categroyModel;

@property(nonatomic,copy) NSString *stage;

@property (nonatomic, strong) NSIndexPath * currentIndexPath;

@end
