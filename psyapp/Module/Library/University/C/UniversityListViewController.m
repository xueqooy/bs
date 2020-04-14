//
//  UniversityListViewController.m
//  smartapp
//
//  Created by lafang on 2019/2/15.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UniversityListViewController.h"
#import "ZJChooseControlView.h"
#import "ZJChooseShowView.h"
#import "UniversityTableViewCell.h"
#import "UniversityDetailsViewController.h"
#import "CareerService.h"
#import "ProvinceRootModel.h"
#import "DegreesRootModel.h"
#import "UniversityRootModel.h"
#import "YTKKeyValueStore.h"
#import "MJRefresh.h"


@interface UniversityListViewController ()<UITableViewDelegate,UITableViewDataSource,ZJChooseControlDelegate>

@property(nonatomic ,strong) UITableView *tableView;
@property(nonatomic ,weak) ZJChooseControlView *chooseControlView;
@property(nonatomic ,strong) ZJChooseShowView *showView;

@property (nonatomic,strong) UniversityRootModel *rootModel;
@property(nonatomic,strong) NSMutableArray<UniversityModel *> *universityModels;
@property(nonatomic,strong) NSMutableArray<ProvinceModel *> *provinceModels;
@property(nonatomic,strong) NSArray<DegreesModel *> *degreeModels;

@property(nonatomic,strong) NSString *areaFilter;//当前地区筛选条件
@property(nonatomic,strong) NSString *degreeFilter;//当前学位筛选条件
@property(nonatomic,strong) NSString *rankFilter;//当前排名筛选条件

@property(nonatomic,assign) NSInteger page;
@property(nonatomic,assign) NSInteger size;

@end

@implementation UniversityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"院校排名列表";
    
    self.page = 1;
    self.size = 20;
    
    
    [self getProvinces];
    @weakObj(self);
    [self getDegreesWithCompletion:^{
        [selfweak setupView];
        [selfweak loadData];
    }];
}

-(void)setupView{
    
    self.areaFilter = @"全国";
    
    NSArray *array = @[self.areaFilter,self.degreeFilter, _rankName];
    ZJChooseControlView *chooseView = [[ZJChooseControlView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 50)];
    chooseView.backgroundColor = UIColor.fe_contentBackgroundColor;
    chooseView.delegate = self;
    chooseView.layer.borderColor = UIColor.fe_separatorColor.CGColor;
    chooseView.layer.borderWidth = 0.5;
    [chooseView setUpAllViewWithTitleArr:array];
    _chooseControlView = chooseView;
    [self.view addSubview:chooseView];
    [self.view addSubview:self.tableView];

}


-(ZJChooseShowView *)showView{
    if (!_showView) {
        _showView = [[ZJChooseShowView alloc]initWithFrame:CGRectMake(0, 50, mScreenWidth, mScreenHeight - mNavBarAndStatusBarHeight - 50)];
        _showView.hidden = YES;
        
        self.chooseControlView = self.chooseControlView;
        
        __weak typeof(self) weakSelf = self;
        //筛选回调
        self.showView.filterCallback = ^(NSInteger type, NSInteger index, NSString *result) {
            if(type == 0){
                weakSelf.areaFilter = result;
            }else if(type == 1){
                weakSelf.degreeFilter = result;
                if([result isEqualToString:@"本科"]){
                    weakSelf.rankFilter = [weakSelf getDegreeRank:0];
                }else{
                    weakSelf.rankFilter = [weakSelf getDegreeRank:0];
                }
            }else if(type == 2){
                weakSelf.rankFilter = [weakSelf getDegreeRank:index];
            }
            [weakSelf loadData];
        };
 
    }
    return _showView;
}

-(NSString *)getDegreeRank:(NSInteger)index{
    
    NSString *str = @"";
    DegreesModel *model;
    if([self.degreeFilter isEqualToString:@"本科"]){
        
        for(int i=0;i<self.degreeModels.count;i++){
            if([self.degreeModels[i].name isEqualToString:@"本科"]){
                model = self.degreeModels[i];
                break;
            }
        }
        
    }else{
        for(int i=0;i<self.degreeModels.count;i++){
            if([self.degreeModels[i].name isEqualToString:@"专科"]){
                model = self.degreeModels[i];
                break;
            }
        }
    }
    
    if(model){
        NSArray<DegreesRankingModel *> *rankModels = model.rankingItems;
        str = rankModels[index].code;
    }
    
    return str;
}

-(void)loadData{
    __weak typeof(self) weakSelf = self;
    NSInteger page = 1;
    [QSLoadingView show];
//    BOOL isUniversity = [self.degreeFilter isEqualToString:@"本科"];
    [CareerService getUniversityList:self.rankFilter chinaDegree:self.degreeFilter state:self.areaFilter page:page size:self.size success:^(id data) {
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
//            [self uploadToCloudForData:dataModel.items forUniversity:isUniversity];
            if(self.universityModels.count<self.size){
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
            }
        }else{
            [self showEmptyViewInView:self.view type:FEErrorType_NoCollection];
        }
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error showView:self.view];
        [self.tableView.mj_header endRefreshing];
        [self showEmptyViewForNoNetInView:self.view refreshHandler:^{
            [weakSelf loadData];
        }];
    }];
    
}

//- (void)uploadToCloudForData:(NSArray <UniversityModel *>*)data forUniversity:(BOOL)forUniversity {
//    NSMutableArray *universities = @[].mutableCopy;
//    for (UniversityModel *model in data) {
//        AVObject *university = [AVObject objectWithClassName:@"UniversityLib"];
//        [university setObject:model.cnName forKey:@"cnName"];
//        [university setObject:model.logoUrl forKey:@"logoUrl"];
//        [university setObject:model.universityId forKey:@"universityId"];
//        [university setObject:model.state forKey:@"state"];
//
//        UniversityBasicInfoModel *basicInfo = model.basicInfo;
//        [university setObject:basicInfo.publicOrPrivate forKey:@"publicOrPrivate"];
//        [university setObject:basicInfo.chinaBelongTo forKey:@"chinaBelongTo"];
//        [university setObject:basicInfo.instituteQuality forKey:@"instituteQuality"];
//        [university setObject:basicInfo.instituteType forKey:@"instituteType"];
//
//        [university setObject:forUniversity?@"university" : @"college" forKey:@"universityOrCollege"];
//
//        [universities addObject:university];
//
//
//    }
//    [AVObject saveAllInBackground:universities block:^(BOOL succeeded, NSError * _Nullable error) {
//        if (succeeded) {
//            [QSToast toastWithMessage:@"上传成功"];
//        }
//    }];
//}

-(void)loadMoreData{
    
    if (self.universityModels.count >= self.rootModel.total) {
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
        
    }
//    BOOL isUniversity = [self.degreeFilter isEqualToString:@"本科"];

    NSInteger page = self.page +1;
    [CareerService getUniversityList:self.rankFilter chinaDegree:self.degreeFilter state:self.areaFilter page:page size:self.size success:^(id data) {
        [self.tableView.mj_footer endRefreshing];
        if(data){
            UniversityRootModel *dataModel = [MTLJSONAdapter modelOfClass:UniversityRootModel.class fromJSONDictionary:data error:nil];
//            [self uploadToCloudForData:dataModel.items forUniversity:isUniversity];

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

-(void)initProvinceList{
    self.provinceModels = [[NSMutableArray alloc] init];
    ProvinceModel *model = [[ProvinceModel alloc] init];
    model.name = @"全国";
    model.code = @"";
    [self.provinceModels addObject:model];
}

-(void)getProvinces{
    
    //先取缓存数据
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:YTK_DB_NAME];
    NSDictionary *province = [store getObjectById:YTK_PROVINCE_KEY fromTable:YTK_TABLE_UNIVERSITY];
    if(province){
        ProvinceRootModel *dataModel = [MTLJSONAdapter modelOfClass:ProvinceRootModel.class fromJSONDictionary:province error:nil];
        [self initProvinceList];
        [self.provinceModels addObjectsFromArray:dataModel.items];
        [self.showView updateZeroArr:self.provinceModels];
    }else{
        [CareerService getProvinceList:^(id data) {
            if(data){
                ProvinceRootModel *dataModel = [MTLJSONAdapter modelOfClass:ProvinceRootModel.class fromJSONDictionary:data error:nil];
                if(dataModel){
                    [self initProvinceList];
                    [self.provinceModels addObjectsFromArray:dataModel.items];
                    [self.showView updateZeroArr:self.provinceModels];
                }
            }
        } failure:^(NSError *error) {
            [HttpErrorManager showErorInfo:error showView:self.view];
            
        }];
    }
    [store close];
}

-(void)getDegreesWithCompletion:(void(^)(void))completion{
    
    
    [CareerService getDegreesList:^(id data) {
        if(data){
            DegreesRootModel *dataModel = [MTLJSONAdapter modelOfClass:DegreesRootModel.class fromJSONDictionary:data error:nil];
            if(dataModel){
                self.degreeModels = dataModel.items;
                NSInteger degreeIdx = 0;
                NSInteger rankIdx = 0;
                self.degreeFilter = @"本科";
                if (!self.rankName) {
                    self.rankName = @"本科排名";
                    self.rankFilter = @"cn_china15";
                } else {
                    if ([self.rankName isEqualToString:@"专科排名"]) {
                        self.degreeFilter = @"专科";
                        self.rankFilter = @"cn_zhuanke16";
                        degreeIdx = 1;
                    } else {
                        for (DegreesRankingModel *model in self.degreeModels[0].rankingItems) {
                            if ([model.name isEqualToString:self.rankName]) {
                                self.rankFilter = model.code;
                                break;
                            }
                            rankIdx ++;
                        }
                    }
                }
                if (self.rankFilter == nil) {
                    self.rankName = @"本科排名";
                    self.rankFilter = @"cn_china15";
                    degreeIdx = 0;
                    rankIdx = 0;
                }
                
                [self.showView updateThreeArr:self.degreeModels atIndex:degreeIdx];
                [self.showView updateFourArr:self.degreeModels[degreeIdx].rankingItems atIndex:rankIdx];
                if (completion) completion();
            }
        }
    } failure:^(NSError *error) {
        [HttpErrorManager showErorInfo:error];
    }];
    
    
}



#pragma mark - 选中的按钮事件
-(void)chooseControlWithBtnArray:(NSArray *)array button:(UIButton *)sender{
    
    [self.view addSubview:self.showView];
    self.showView.hidden = NO;
    [self.showView chooseControlViewBtnArray:array Action:sender];
    
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, mScreenWidth, mScreenHeight - mNavBarAndStatusBarHeight - 50) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
        _tableView.tableFooterView = ({
            UIView *view = UIView.new;
            view.frame = CGRectMake(0, 0, mScreenHeight, mBottomSafeHeight);
            view.backgroundColor = UIColor.fe_contentBackgroundColor;
            view;
        });
        [_tableView registerClass:[UniversityTableViewCell class] forCellReuseIdentifier:NSStringFromClass([UniversityTableViewCell class])];
        
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
        
        footer.stateLabel.textColor = UIColor.fe_auxiliaryTextColor;
        self.tableView.mj_footer = footer;
        self.tableView.showsHorizontalScrollIndicator = NO;

        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //自动更改透明度
        self.tableView.mj_header.automaticallyChangeAlpha = YES;
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.universityModels ? self.universityModels.count : 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UniversityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UniversityTableViewCell class]) forIndexPath:indexPath];
    
    [cell updateModel:self.universityModels[indexPath.row] rankFilter:self.rankFilter isLastRow:indexPath.row == self.universityModels.count - 1? YES: NO];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UniversityDetailsViewController *vc = [UniversityDetailsViewController suspendTopPausePageVC];
    vc.universityModel = self.universityModels[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
