//
//  UniversitySituationViewController.m
//  smartapp
//  学校详情-概况
//  Created by lafang on 2019/3/12.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UniversitySituationViewController.h"
#import "CommonSingTextTableViewCell.h"
#import "CommonScaleTextTableViewCell.h"
#import "UniversityRankingTableViewCell.h"
#import "FacultyStrengthTableViewCell.h"
#import "UniversityRankingItemModel.h"
#import "StudentSummaryTableViewCell.h"

@interface UniversitySituationViewController ()<UITableViewDataSource,UITableViewDelegate>

//@property(nonatomic,strong) NSMutableArray<UniversityRankingItemModel *> *rankArray;

@end

@implementation UniversitySituationViewController

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
    
    [self.tableView registerClass:[CommonScaleTextTableViewCell class] forCellReuseIdentifier:NSStringFromClass([CommonScaleTextTableViewCell class])];
    [self.tableView registerClass:[CommonSingTextTableViewCell class] forCellReuseIdentifier:NSStringFromClass([CommonSingTextTableViewCell class])];
    [self.tableView registerClass:[UniversityRankingTableViewCell class] forCellReuseIdentifier:NSStringFromClass([UniversityRankingTableViewCell class])];
    [self.tableView registerClass:[FacultyStrengthTableViewCell class] forCellReuseIdentifier:NSStringFromClass([FacultyStrengthTableViewCell class])];
    [self.tableView registerClass:[StudentSummaryTableViewCell class] forCellReuseIdentifier:NSStringFromClass([StudentSummaryTableViewCell class])];
    
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"footer"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsHorizontalScrollIndicator = NO;

    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, mScreenWidth, 0.01f)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, mScreenWidth, mBottomSafeHeight)];
    
}

- (void)updateModel:(UniversitySituationModel *)universitySituationModel{
    
    self.universitySituationModel = universitySituationModel;
    
    if(self.universitySituationModel){
//        self.rankArray = [[NSMutableArray alloc] init];
        
        [self.tableView reloadData];
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.universitySituationModel ? 4 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0){
        return 1;
    }else if(section == 1){
        return self.universitySituationModel.ranking ? self.universitySituationModel.ranking.count : 0;
    }else if(section == 2){
        return self.universitySituationModel.facultyStrength.items ? self.universitySituationModel.facultyStrength.items.count + 1 : 0;
    }else{
        return 1;
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
        [AddItemViewsManager addCommenTitleView:headerView title:@"简介"];
    }else if(section == 1){
        [AddItemViewsManager addCommenTitleView:headerView title:@"院校排名"];
    }else if(section == 2){
        [AddItemViewsManager addCommenTitleView:headerView title:@"师资力量"];
    }else{
        [AddItemViewsManager addCommenTitleView:headerView title:@"学生概况"];
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
        CommonScaleTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CommonScaleTextTableViewCell class]) forIndexPath:indexPath];
        
        [cell updateString:self.universitySituationModel.briefIntroduction isScale:self.universitySituationModel.isScaleBrief];
        cell.scaleCallback = ^(NSInteger index) {
            self.universitySituationModel.isScaleBrief = !self.universitySituationModel.isScaleBrief;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 1){
        UniversityRankingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UniversityRankingTableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateModel:self.universitySituationModel.ranking[indexPath.row]];
        
        return cell;
    }else if(indexPath.section == 2){
        NSArray<UniverSitynameItemModel *> *itemModels = self.universitySituationModel.facultyStrength.items;
        
        if(indexPath.row == itemModels.count){
            
            CommonSingTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CommonSingTextTableViewCell class]) forIndexPath:indexPath];
            
            [cell updateString:self.universitySituationModel.facultyStrength.summary];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            
            FacultyStrengthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FacultyStrengthTableViewCell class]) forIndexPath:indexPath];
            
            [cell updateModel:itemModels[indexPath.row]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else{
        StudentSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([StudentSummaryTableViewCell class]) forIndexPath:indexPath];
        
        [cell updateModel:self.universitySituationModel.studentData studentRatioModel:self.universitySituationModel.studentRatio];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
