//
//  UniversityProfessionalViewController.m
//  smartapp
//  学校详情-专业
//  Created by lafang on 2019/3/12.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UniversityProfessionalViewController.h"
#import "UniversityProfessionalTableViewCell.h"
#import "CareerService.h"
#import "UniversityMajorRootModel.h"
#import "YNPageScrollMenuView.h"
#import "YNPageConfigration.h"
#import "UIView+YNPageExtend.h"
#import "UniversityKeySubjectModel.h"
#import "ProfessionalDetailsViewController.h"

@interface UniversityProfessionalViewController ()<UITableViewDataSource,UITableViewDelegate,YNPageScrollMenuViewDelegate>

@property(nonatomic,strong)UIView *filterView;

@property(nonatomic,assign)NSInteger curSelectIndex;
@property(nonatomic,strong)NSArray<UniversityMajorModel *> *universityMajorModels;   //开设专业
@property(nonatomic,strong)NSMutableArray<UniversityKeySubjectModel *> *keySubjectModels;   //重点学科
@property(nonatomic,strong)NSMutableArray<UniversityKeySubjectModel *> *firstSubjectModels; //一流学科

@end

@implementation UniversityProfessionalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
//    [self loadData];
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
    [self.tableView registerClass:[UniversityProfessionalTableViewCell class] forCellReuseIdentifier:NSStringFromClass([UniversityProfessionalTableViewCell class])];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"footer"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsHorizontalScrollIndicator = NO;

    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, mScreenWidth, 0.01f)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, mScreenWidth, mBottomSafeHeight)];
    
    self.filterView = [[UIView alloc] init];
    self.filterView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.filterView];
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(134);
        make.height.mas_equalTo(40);
    }];
    
    YNPageConfigration *fourthConfigStyle = [YNPageConfigration defaultConfig];
    fourthConfigStyle.converColor = [UIColor grayColor];
    fourthConfigStyle.showConver = NO;
    fourthConfigStyle.itemFont = [UIFont systemFontOfSize:15];
    fourthConfigStyle.selectedItemFont = [UIFont systemFontOfSize:15];
    fourthConfigStyle.selectedItemColor = UIColor.fe_textColorHighlighted;
    fourthConfigStyle.normalItemColor = UIColor.fe_mainTextColor;
    fourthConfigStyle.lineColor = UIColor.fe_textColorHighlighted;
    fourthConfigStyle.itemMaxScale = 1.0;//选中项文字变大
    fourthConfigStyle.itemMargin = 30;
    
    self.curSelectIndex = 0;
    YNPageScrollMenuView *menuView = [YNPageScrollMenuView pagescrollMenuViewWithFrame:CGRectMake(0, 0, mScreenWidth, 40) titles:@[@"开设专业", @"重点学科", @"一流学科"].mutableCopy configration:fourthConfigStyle delegate:self currentIndex:self.curSelectIndex];
    
    [self.filterView addSubview:menuView];
    
}

// 点击item
- (void)pagescrollMenuViewItemOnClick:(UIButton *)button index:(NSInteger)index{
    
    self.curSelectIndex = index;
    
    if(index == 0){
        //开设专业
        if(self.universityMajorModels){
            [self.tableView reloadData];
        }else{
            [self loadData];
        }
    }else if(index == 1){
        //重点学科
        if(self.keySubjectModels){
            [self.tableView reloadData];
        }else{
            [self getKeySubjects:@"national_key"];
        }
    }else{
        //一流学科
        if(self.firstSubjectModels){
            [self.tableView reloadData];
        }else{
            [self getKeySubjects:@"double_first_class"];
        }
    }
}

// 点击Add按钮
- (void)pagescrollMenuViewAddButtonAction:(UIButton *)button{
    
}

-(void)loadData{
    [QSLoadingView show];
    [CareerService getUniversityProfessionals:self.universitySituationModel.universityModel.universityId success:^(id data) {
        [QSLoadingView dismiss];
        if(data){
            UniversityMajorRootModel *dataModel = [MTLJSONAdapter modelOfClass:UniversityMajorRootModel.class fromJSONDictionary:data error:nil];
            if(dataModel){
                self.universityMajorModels = dataModel.items;
                [self.tableView reloadData];
            }
            
        }
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error showView:self.view];
    }];
    
}

-(void)getKeySubjects:(NSString *)nationalKey{
    [QSLoadingView show];
    [CareerService getUniversityKeySubjects:self.universitySituationModel.universityModel.universityId nationalKey:nationalKey success:^(id data) {
        [QSLoadingView dismiss];
        if(data){
            NSArray<UniversityKeySubjectModel *> *dataModel = [MTLJSONAdapter modelsOfClass:UniversityKeySubjectModel.class fromJSONArray:data[@"items"] error:nil];
            if(dataModel){
                
                UniversityKeySubjectModel *model = [[UniversityKeySubjectModel alloc] init];
                model.name = @"";
                if(self.curSelectIndex == 1){
                    self.keySubjectModels = [[NSMutableArray alloc] init];
                    [self.keySubjectModels addObject:model];//增加一个空对象，放在第一个section占位筛选菜单空间
                    [self.keySubjectModels addObjectsFromArray:dataModel];
                    [self.tableView reloadData];
                }else{
                    self.firstSubjectModels = [[NSMutableArray alloc] init];
                    [self.firstSubjectModels addObject:model];//增加一个空对象，放在第一个section占位筛选菜单空间
                    [self.firstSubjectModels addObjectsFromArray:dataModel];
                    [self.tableView reloadData];
                }
            }
            
            
        }
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error showView:self.view];
    }];
}

- (void)updateModel:(UniversitySituationModel *)universitySituationModel{
    
    self.universitySituationModel = universitySituationModel;
    
    if(universitySituationModel){
        if(![universitySituationModel.universityModel.chinaDegree isEqualToString:@"本科"]){
            self.filterView.hidden = YES;
        }
        [self loadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(self.curSelectIndex == 0){
        return 1;
    }else if(self.curSelectIndex == 1){
        return self.keySubjectModels ? self.keySubjectModels.count : 0;
    }else{
        return self.firstSubjectModels ? self.firstSubjectModels.count : 0;;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(self.curSelectIndex == 0){
        return self.universityMajorModels ? self.universityMajorModels.count : 0;
    }else if(self.curSelectIndex == 1){
        if(section == 0){
            return 0;
        }else{
            return self.keySubjectModels ? self.keySubjectModels[section].items.count : 0;
        }
        
    }else{
        if(section == 0){
            return 0;
        }else{
            return self.firstSubjectModels ? self.firstSubjectModels[section].items.count : 0;
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if(![self.universitySituationModel.universityModel.chinaDegree isEqualToString:@"本科"]){
        return 0;
    }
    return 40;
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
    headerView.backgroundColor = UIColor.fe_buttonBackgroundColorActive;
    UILabel *label = [[UILabel alloc] init];
    if(self.curSelectIndex == 0){
        label.text = @"";
    }else if(self.curSelectIndex == 1){
        label.text = self.keySubjectModels[section].name;
    }else{
        label.text = self.firstSubjectModels[section].name;
    }
    
    label.textColor = UIColor.fe_titleTextColorLighten;
    label.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(20);
        make.right.equalTo(headerView).offset(-20);
        make.centerY.equalTo(headerView);
    }];
    return  headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    //    footerView.contentView.backgroundColor = [UIColor colorWithHexString:@"#12b2f4"];
    return  footerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UniversityProfessionalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UniversityProfessionalTableViewCell class]) forIndexPath:indexPath];
    
    if(self.curSelectIndex == 0){
        [cell updateProfessionalData:self.universityMajorModels[indexPath.row]];
    }else if(self.curSelectIndex == 1){
        [cell updateKeySubjectData:self.keySubjectModels[indexPath.section] index:indexPath.row];
    }else{
        [cell updateKeySubjectData:self.firstSubjectModels[indexPath.section] index:indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.curSelectIndex == 0){
        ProfessionalDetailsViewController *vc = [ProfessionalDetailsViewController suspendTopPausePageVC];
        vc.majorCode = self.universityMajorModels[indexPath.row].majorCode;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSLog(@"-----offset------:::%lg",scrollView.contentOffset.y);
    
    if(![self.universitySituationModel.universityModel.chinaDegree isEqualToString:@"本科"]){
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY<=-40){
        CGFloat ofy = abs(offsetY);
        [self.filterView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(ofy-2);
            make.height.mas_equalTo(40);
        }];
    }else{
        [self.filterView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(40);
            make.height.mas_equalTo(40);
        }];
    }
    
    
}

@end
