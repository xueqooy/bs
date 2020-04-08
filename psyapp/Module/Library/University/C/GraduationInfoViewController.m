//
//  GraduationInfoViewController.m
//  smartapp
//  学校详情-毕业信息
//  Created by lafang on 2019/3/12.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "GraduationInfoViewController.h"
#import "CareerService.h"
#import "UniversityGraduationModel.h"
#import "UnivesityGraChartTableViewCell.h"
#import "UniversityGraTableViewCell.h"

@interface GraduationInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UniversityGraduationModel *universityGraduationModel;

@end

@implementation GraduationInfoViewController

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
    [self.tableView registerClass:[UnivesityGraChartTableViewCell class] forCellReuseIdentifier:NSStringFromClass([UnivesityGraChartTableViewCell class])];
    [self.tableView registerClass:[UniversityGraTableViewCell class] forCellReuseIdentifier:NSStringFromClass([UniversityGraTableViewCell class])];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"footer"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsHorizontalScrollIndicator = NO;

    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, mScreenWidth, 0.01f)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, mScreenWidth, mBottomSafeHeight)];
    
}

-(void)loadData{
    [QSLoadingView show];
    [CareerService getUniversityGraduation:self.universitySituationModel.universityModel.universityId success:^(id data) {
        [QSLoadingView dismiss];
        if(data){
            UniversityGraduationModel *dataModel = [MTLJSONAdapter modelOfClass:UniversityGraduationModel.class fromJSONDictionary:data error:nil];
            if(dataModel){
                self.universityGraduationModel = dataModel;
                [self.tableView reloadData];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error showView:self.view];
    }];
}

- (void)updateModel:(UniversitySituationModel *)universitySituationModel{
    
    self.universitySituationModel = universitySituationModel;
    
    [self loadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.universityGraduationModel ? 3 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0){
        return (self.universityGraduationModel.settled && self.universityGraduationModel.settled.count) > 0 ? 1 : 0;
    }else if(section == 1){
        return 2;
    }else{
        return (self.universityGraduationModel.overall && self.universityGraduationModel.overall.count>0) ? 1 : 0;
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
        [AddItemViewsManager addCommenTitleView:headerView title:@"总体就业率"];
    }else if(section == 1){
        [AddItemViewsManager addCommenTitleView:headerView title:@"就业与薪资"];
    }else{
        [AddItemViewsManager addCommenTitleView:headerView title:@"国内读研"];
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
        
        UnivesityGraChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UnivesityGraChartTableViewCell class]) forIndexPath:indexPath];
        
        [cell updateModel:self.universityGraduationModel.settled];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 1){
        
        UniversityGraTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UniversityGraTableViewCell class]) forIndexPath:indexPath];
        
        if(indexPath.row == 0){
            
            if(self.universityGraduationModel.overall.count>0){
                //本科直接就业
                UniversityGrduationOverallModel *model = [self getOverallByType:@"employment"];
                [cell updateModel:0 num:model.ratio];
            }else{
                [cell updateModel:0 num:@0];
            }
            
        }else{
            [cell updateModel:1 num:self.universityGraduationModel.fiveYearSalary];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        //本科读研率
        UniversityGraTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UniversityGraTableViewCell class]) forIndexPath:indexPath];
        
        UniversityGrduationOverallModel *model = [self getOverallByType:@"domestic_postgraduate"];
        [cell updateModel:2 num:model.ratio];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];


}

-(UniversityGrduationOverallModel *)getOverallByType:(NSString *)key{
    NSArray<UniversityGrduationOverallModel *> *overlls = self.universityGraduationModel.overall;
    for(int i=0;i<overlls.count;i++){
        if([key isEqualToString:overlls[i].type]){
            return overlls[i];
        }
    }
    return nil;
}

@end
