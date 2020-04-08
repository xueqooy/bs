//
//  ProfessionalBaseInfoViewController.m
//  smartapp
//  专业详情-基本信息
//  Created by lafang on 2019/3/12.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "ProfessionalBaseInfoViewController.h"
#import "OccupationDetailsTableViewCell.h"
#import "CommonSingTextTableViewCell.h"
#import "OccupationDetailsProTableViewCell.h"
#import "OccupationDetailsViewController.h"

@interface ProfessionalBaseInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ProfessionalBaseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated{
    
}

-(void)setupView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.tableView registerClass:[OccupationDetailsTableViewCell class] forCellReuseIdentifier:NSStringFromClass([OccupationDetailsTableViewCell class])];
    [self.tableView registerClass:[OccupationDetailsProTableViewCell class] forCellReuseIdentifier:NSStringFromClass([OccupationDetailsProTableViewCell class])];
    [self.tableView registerClass:[CommonSingTextTableViewCell class] forCellReuseIdentifier:NSStringFromClass([CommonSingTextTableViewCell class])];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"footer"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsHorizontalScrollIndicator = NO;

    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, mScreenWidth, 0.01f)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, mScreenWidth, mBottomSafeHeight)];
    
}

-(void)updateModel:(ProfessionalDetailRootModel *)professionalDetailRootModel{
    self.professionalDetailRootModel = professionalDetailRootModel;
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(self.professionalDetailRootModel){
        if(self.professionalDetailRootModel.occupations && self.professionalDetailRootModel.occupations.count>0){
            return 3;
        }else{
            return 2;
        }
    }else{
        return 0;
    }
//    return self.professionalDetailRootModel ? 3 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0){
        return self.professionalDetailRootModel.introduces ? self.professionalDetailRootModel.introduces.count : 0;
    }else if(section == 1){
        return 1;
    }else{
        return self.professionalDetailRootModel.occupations ? self.professionalDetailRootModel.occupations.count : 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
//    headerView.contentView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    
    UIView *headerView = [[UIView alloc] init];
    if(section == 0){
        [AddItemViewsManager addCommenTitleView:headerView title:@"专业介绍"];
    }else if(section == 1){
        [AddItemViewsManager addCommenTitleView:headerView title:@"课程概览"];
    }else{
        [AddItemViewsManager addCommenTitleView:headerView title:@"对口职业"];
    }
    return  headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    //    footerView.contentView.backgroundColor = [UIColor colorWithHexString:@"#12b2f4"];
    return  footerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        
        OccupationDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OccupationDetailsTableViewCell class]) forIndexPath:indexPath];
        
        [cell updateModel:self.professionalDetailRootModel.introduces[indexPath.row]];
        
        return cell;
        
    }else if(indexPath.section == 1){
        
        CommonSingTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CommonSingTextTableViewCell class]) forIndexPath:indexPath];
        
        [cell updateString:self.professionalDetailRootModel.course];
        
        return cell;
        
    }else{
        
        OccupationDetailsProTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OccupationDetailsProTableViewCell class]) forIndexPath:indexPath];
        
        [cell updateModelPro:self.professionalDetailRootModel.occupations[indexPath.row]];
        
        return cell;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(indexPath.section == 2){
        NSArray<ProfessionalOccupationsModel *> *models = self.professionalDetailRootModel.occupations;
        OccupationDetailsViewController *vc = [[OccupationDetailsViewController alloc] init];
        vc.occupationId = [models[indexPath.row].occupationId stringValue];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}




@end
