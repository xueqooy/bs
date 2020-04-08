//
//  ProfessionalOpenUniversityViewController.m
//  smartapp
//  专业详情-开设院校
//  Created by lafang on 2019/3/12.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "ProfessionalOpenUniversityViewController.h"
#import "ProfessionalOpenUniTableViewCell.h"
#import "CareerService.h"
#import "UniversityRootModel.h"
#import "MJRefresh.h"
#import "StringUtils.h"
#import "CommonBottomMenuView.h"
#import "YTKKeyValueStore.h"
#import "ConstantConfig.h"
#import "ProvinceRootModel.h"
#import "UniversityDetailsViewController.h"

@interface ProfessionalOpenUniversityViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UIView *filterView;
@property(nonatomic,strong) UIButton *provinceBtn;
@property(nonatomic,strong) UIButton *typeBtn;

@property(nonatomic,strong)UniversityRootModel *rootModel;
@property(nonatomic,strong)NSMutableArray<UniversityModel *> *universityModels;

@property(nonatomic,strong) NSMutableArray<NSString *> *provinceArray;
@property(nonatomic,strong) NSArray<ProvinceModel *> *provinceModels;
@property(nonatomic,strong) NSString *provinceFilter;

@property(nonatomic,assign) NSInteger page;
@property(nonatomic,assign) NSInteger size;

@end

@implementation ProfessionalOpenUniversityViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.page = 1;
    self.size = 20;
    
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
    [self.tableView registerClass:[ProfessionalOpenUniTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ProfessionalOpenUniTableViewCell class])];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"footer"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsHorizontalScrollIndicator = NO;

    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, mScreenWidth, 0.01f)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, mScreenWidth, mBottomSafeHeight)];
    
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新数据" forState:MJRefreshStatePulling];
    [header setTitle:@"数据加载中···" forState:MJRefreshStateRefreshing];
    self.tableView.mj_header = header;
    
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"上拉加载数据" forState:MJRefreshStateIdle];
    [footer setTitle:@"更多数据加载中 ..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
    
    footer.stateLabel.font = [UIFont systemFontOfSize:17];
    
    footer.stateLabel.textColor = UIColor.fe_mainTextColor;
    self.tableView.mj_footer = footer;
    
    self.filterView = [[UIView alloc] init];
    self.filterView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.filterView];
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(134);
        make.height.mas_equalTo(50);
    }];
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = UIColor.fe_backgroundColor;
    [self.filterView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.filterView);
        make.height.mas_equalTo(10);
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = UIColor.fe_separatorColor;
    [self.filterView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.filterView);
        make.height.mas_equalTo(1);
    }];
    
    self.provinceBtn = [StringUtils createButton:@"学校所在地" color:@"666666" font:13];
    [self.provinceBtn addTarget:self action:@selector(filterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.provinceBtn setImage:[UIImage imageNamed:@"career_filter_bottom"] forState:UIControlStateNormal];
//    self.provinceBtn.layer.masksToBounds = YES;
//    self.provinceBtn.layer.cornerRadius = 5;
//    self.provinceBtn.layer.borderWidth = 1;
//    self.provinceBtn.layer.borderColor = [UIColor colorWithHexString:@"666666"].CGColor;
    [self.filterView addSubview:self.provinceBtn];
    [self.provinceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.filterView).offset(mScreenWidth/4-40);
        make.centerY.equalTo(self.filterView).offset(7);
        make.size.mas_equalTo(CGSizeMake(80, 28));
    }];
    [self.provinceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.provinceBtn.imageView.size.width, 0, self.provinceBtn.imageView.size.width)];
    [self.provinceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.provinceBtn.titleLabel.bounds.size.width, 0, -self.provinceBtn.titleLabel.bounds.size.width)];
    
    
    
//    self.typeBtn = [StringUtils createButton:@"学校类型" color:@"666666" font:13];
//    [self.typeBtn addTarget:self action:@selector(filterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.typeBtn setImage:[UIImage imageNamed:@"career_filter_bottom"] forState:UIControlStateNormal];
//    [self.filterView addSubview:self.typeBtn];
//    [self.typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.filterView).offset(-(mScreenWidth/4-40));
//        make.centerY.equalTo(self.filterView).offset(5);
//        make.size.mas_equalTo(CGSizeMake(80, 28));
//    }];
//    [self.typeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.typeBtn.imageView.size.width, 0, self.typeBtn.imageView.size.width)];
//    [self.typeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.typeBtn.titleLabel.bounds.size.width, 0, -self.typeBtn.titleLabel.bounds.size.width)];
    
}

-(void)filterBtnClick:(UIButton *)btn{
    if(btn == self.provinceBtn){
        //生源地筛查
        CommonBottomMenuView *showView = [[CommonBottomMenuView alloc] initWithData:self.provinceArray title:@"学校所在地"];
        showView.menuCallBack = ^(NSInteger index) {
            self.provinceFilter = self.provinceArray[index];
            [self updateProvinceBtn];
            [self loadData];
        
        };
        [showView showInView:[UIApplication sharedApplication].keyWindow];
    }else{
        //学校类型筛查
        [QSToast toast:self.view message:@"暂无"];
    }
}

-(void)updateModel:(ProfessionalDetailRootModel *)professionalDetailRootModel{
    self.professionalDetailRootModel = professionalDetailRootModel;
    if(professionalDetailRootModel){
//        [self loadData];
        [self loadProvinceData];
    }
}

-(void)loadProvinceData{
    //先取缓存数据
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:YTK_DB_NAME];
    NSDictionary *province = [store getObjectById:YTK_PROVINCE_KEY fromTable:YTK_TABLE_UNIVERSITY];
    if(province){
        ProvinceRootModel *dataModel = [MTLJSONAdapter modelOfClass:ProvinceRootModel.class fromJSONDictionary:province error:nil];
        self.provinceModels = dataModel.items;
        self.provinceArray = [[NSMutableArray alloc] init];
        [self.provinceArray addObject:@"全国"];
        for(int i=0;i<self.provinceModels.count;i++){
            ProvinceModel *model = self.provinceModels[i];
            [self.provinceArray addObject:model.name];
        }
        self.provinceFilter = self.provinceArray[0];
        [self updateProvinceBtn];
        [self loadData];
    }else{
        [CareerService getProvinceList:^(id data) {
            if(data){
                ProvinceRootModel *dataModel = [MTLJSONAdapter modelOfClass:ProvinceRootModel.class fromJSONDictionary:data error:nil];
                if(dataModel){
                    ProvinceRootModel *dataModel = [MTLJSONAdapter modelOfClass:ProvinceRootModel.class fromJSONDictionary:province error:nil];
                    self.provinceModels = dataModel.items;
                    self.provinceArray = [[NSMutableArray alloc] init];
                    [self.provinceArray addObject:@"全国"];
                    for(int i=0;i<self.provinceModels.count;i++){
                        ProvinceModel *model = self.provinceModels[i];
                        [self.provinceArray addObject:model.name];
                    }
                    self.provinceFilter = self.provinceArray[0];
                    [self updateProvinceBtn];
                    [self loadData];
                }
            }
        } failure:^(NSError *error) {
            [HttpErrorManager showErorInfo:error showView:self.view];
            
        }];
    }
    [store close];
}

-(void)loadData{
//    __weak typeof(self) weakSelf = self;
    NSInteger page = 1;
    [QSLoadingView show];
    [CareerService getProfessionalUniversitys:self.professionalDetailRootModel.majorCode state:self.provinceFilter instituteType:@"" page:page size:self.size success:^(id data) {
        [QSLoadingView dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
        if(data){
            self.page = page;
            UniversityRootModel *dataModel = [MTLJSONAdapter modelOfClass:UniversityRootModel.class fromJSONDictionary:data error:nil];
            if(dataModel){
                self.rootModel = dataModel;
                self.universityModels = [[NSMutableArray alloc] init];
                [self.universityModels addObjectsFromArray:dataModel.items];
                [self.tableView reloadData];
            }
            
            if(self.universityModels.count<self.size){
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
            }
        }
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error showView:self.view];
        [self.tableView.mj_header endRefreshing];
    }];
}

-(void)updateProvinceBtn{
    [self.provinceBtn setTitle:self.provinceFilter forState:UIControlStateNormal];
}

-(void)loadMoreData{
    
    if (self.universityModels.count >= self.rootModel.total) {
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
        
    }
    NSInteger page = self.page +1;
    [CareerService getProfessionalUniversitys:self.professionalDetailRootModel.majorCode state:self.provinceFilter instituteType:@"" page:page size:self.size success:^(id data) {
        [self.tableView.mj_footer endRefreshing];
        if(data){
            UniversityRootModel *dataModel = [MTLJSONAdapter modelOfClass:UniversityRootModel.class fromJSONDictionary:data error:nil];
            if(dataModel){
                self.page ++;
                [self.universityModels addObjectsFromArray:dataModel.items];
                [self.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        [HttpErrorManager showErorInfo:error showView:self.view];
        [self.tableView.mj_footer endRefreshing];
    }];
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.universityModels ? self.universityModels.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 80;
//}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    headerView.contentView.backgroundColor = [UIColor whiteColor];
    return  headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    //    footerView.contentView.backgroundColor = [UIColor colorWithHexString:@"#12b2f4"];
    return  footerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProfessionalOpenUniTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProfessionalOpenUniTableViewCell class]) forIndexPath:indexPath];
    
    [cell updateModel:self.universityModels[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UniversityDetailsViewController *vc = [UniversityDetailsViewController suspendTopPausePageVC];
    vc.universityModel = self.universityModels[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    NSLog(@"-----offset------:::%lg",scrollView.contentOffset.y);
    
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
