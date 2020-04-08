//
//  OccupationDetailsViewController.m
//  smartapp
//
//  Created by lafang on 2019/3/11.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "OccupationDetailsViewController.h"
#import "CareerService.h"
#import "OccupationDetailsModel.h"
#import "AddItemViewsManager.h"
#import "OccupationDetailsTableViewCell.h"
#import "OccupationDetailsProTableViewCell.h"
#import "ProfessionalDetailsViewController.h"
#import "FESwitch.h"
#import "UILabel+FEChain.h"
@interface OccupationDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *headView;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *hylyLabel;//行业领域
@property(nonatomic,strong) UILabel *zylxLabel;//职业类型

@property(nonatomic,strong) UIButton *rightBtn;

@property(nonatomic,strong) OccupationDetailsModel *occupationDetailsModel;

@end

@implementation OccupationDetailsViewController {
    FESwitch *aSwitch;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self addNavigationSwitch];
    [self loadData];
    
}

- (void)addNavigationSwitch {
    aSwitch = [[FESwitch alloc] initWithFrame:CGRectMake(0, 0, [SizeTool width:40], [SizeTool height:22])];
    aSwitch.onTintColor = mHexColor(@"fc674f");
    aSwitch.attachView = ({
        UILabel *label = [UILabel create:^(UILabel *  label) {
            label.textIs(@"关注")
            .textColorIs(mHexColor(@"303132"))
            .fontIs([SizeTool font:11])
            .frameIs(CGRectMake(0, 0, [SizeTool width:30], [SizeTool height:22]));
        } addTo:nil];
        label;
    });
    
    __weak typeof(self) weakSelf = self;
    aSwitch.switchHandler = ^(BOOL on) {
        if ((on !=  [weakSelf.occupationDetailsModel.isFollow boolValue]) ) {
            [QSLoadingView show];
            [CareerService careerFollow:[weakSelf.occupationDetailsModel.occupationId stringValue] type:@"2" isFollow:([weakSelf.occupationDetailsModel.isFollow integerValue]==0 ? @1: @0) tag:weakSelf.occupationDetailsModel.occupationName success:^(id data) {
                [QSLoadingView dismiss];
                if([data[@"is_follow"] integerValue] == 1){
                    [QSToast toast:weakSelf.view message:@"关注成功"];
                    weakSelf.occupationDetailsModel.isFollow = @1;
                }else{
                    [QSToast toast:weakSelf.view message:@"已取消关注"];
                    weakSelf.occupationDetailsModel.isFollow = @0;
                }
                [weakSelf updateFolowStatus];
            } failure:^(NSError *error) {
                [QSLoadingView dismiss];
                [HttpErrorManager showErorInfo:error showView:weakSelf.view];
            }];
        }
    };
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aSwitch];
}

-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)setupView{
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.tableView registerClass:[OccupationDetailsTableViewCell class] forCellReuseIdentifier:NSStringFromClass([OccupationDetailsTableViewCell class])];
    [self.tableView registerClass:[OccupationDetailsProTableViewCell class] forCellReuseIdentifier:NSStringFromClass([OccupationDetailsProTableViewCell class])];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"footer"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsHorizontalScrollIndicator = NO;

    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 100)];
    
    self.tableView.tableHeaderView = self.headView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = @"";
    self.nameLabel.textColor = UIColor.fe_titleTextColorLighten;
//    self.nameLabel.font = [UIFont systemFontOfSize:16];
    [self.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [self.headView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView).offset(20);
        make.right.equalTo(self.headView).offset(-20);
        make.top.equalTo(self.headView).offset(20);
    }];
    
    self.hylyLabel = [[UILabel alloc] init];
    self.hylyLabel.text = @"";
    self.hylyLabel.textColor = UIColor.fe_mainTextColor;
    self.hylyLabel.font = [UIFont systemFontOfSize:15];
    [self.headView addSubview:self.hylyLabel];
    [self.hylyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView).offset(20);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.headView).offset(-20);
    }];
    
    self.zylxLabel = [[UILabel alloc] init];
    self.zylxLabel.text = @"";
    self.zylxLabel.textColor = UIColor.fe_mainTextColor;
    self.zylxLabel.font = [UIFont systemFontOfSize:14];
    [self.headView addSubview:self.zylxLabel];
    [self.zylxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hylyLabel.mas_right).offset(20);
        make.centerY.equalTo(self.hylyLabel);
    }];
//    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.rightBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
//    self.rightBtn.backgroundColor = [UIColor colorWithHexString:@"ff8b00"];
//    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [self.rightBtn setTitle:@"关注"forState:UIControlStateNormal];
//    self.rightBtn.layer.masksToBounds = YES;
//    self.rightBtn.layer.cornerRadius = 5;
//    [self.rightBtn addTarget:self action:@selector(clickRightBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
//    [self.headView addSubview:self.rightBtn];
//    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.headView).offset(-15);
//        make.centerY.equalTo(self.nameLabel);
//        make.size.mas_equalTo(CGSizeMake(64, 30));
//    }];
    
    
}

-(void)clickRightBarButtonItem{
    //关注
    if(self.occupationDetailsModel){
        [QSLoadingView show];
        [CareerService careerFollow:[self.occupationDetailsModel.occupationId stringValue] type:@"2" isFollow:([self.occupationDetailsModel.isFollow integerValue]==0 ? @1: @0) tag:self.occupationDetailsModel.occupationName success:^(id data) {
            [QSLoadingView dismiss];
            if([data[@"is_follow"] integerValue] == 1){
                [QSToast toast:self.view message:@"关注成功"];
                self.occupationDetailsModel.isFollow = @1;
            }else{
                [QSToast toast:self.view message:@"已取消关注"];
                self.occupationDetailsModel.isFollow = @0;
            }
            [self updateFolowStatus];
        } failure:^(NSError *error) {
            [QSLoadingView dismiss];
            [HttpErrorManager showErorInfo:error showView:self.view];
        }];
    }
}

-(void)updateFolowStatus{
    if([self.occupationDetailsModel.isFollow integerValue] == 1){
        [aSwitch setOn:YES hasHandler:NO];
       // [self.rightBtn setTitle:@"取消关注"forState:UIControlStateNormal];
    }else{
        [aSwitch setOn:NO hasHandler:NO];

      //  [self.rightBtn setTitle:@"关注"forState:UIControlStateNormal];
    }
}

-(void)loadData{
    [QSLoadingView show];
    [CareerService getOccupationDetail:self.occupationId success:^(id data) {
        [QSLoadingView dismiss];
        if(data){
            OccupationDetailsModel *dataModel = [MTLJSONAdapter modelOfClass:OccupationDetailsModel.class fromJSONDictionary:data error:nil];
            if(dataModel){
                self.occupationDetailsModel = dataModel;
                
                self.nameLabel.text = self.occupationDetailsModel.occupationName;
                
                self.hylyLabel.text = [NSString stringWithFormat:@"行业领域:%@",self.occupationDetailsModel.realm];
                
                self.zylxLabel.text = [NSString stringWithFormat:@"职业类型:%@",self.occupationDetailsModel.category];
                
                [self.tableView reloadData];
                
                [self updateFolowStatus];
            }
        }
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error showView:self.view];
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.occupationDetailsModel ? 2 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0){
        return self.occupationDetailsModel.introduces ? self.occupationDetailsModel.introduces.count : 0;
    }else {
        return self.occupationDetailsModel.majors ? self.occupationDetailsModel.majors.count : 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
//    headerView.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
//    return  headerView;
    UIView *headerView = [[UIView alloc] init];
    if(section == 0){
        [AddItemViewsManager addCommenTitleView:headerView title:@"职业介绍"];
    }else{
        [AddItemViewsManager addCommenTitleView:headerView title:@"对口专业"];
    }
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    footerView.contentView.backgroundColor = mHexColor(@"12b2f4");
    return  footerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        OccupationDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OccupationDetailsTableViewCell class]) forIndexPath:indexPath];
        
        NSArray<ProfessionalIntroducesModel *> *arr = self.occupationDetailsModel.introduces;
        [cell updateModel:arr[indexPath.row]];
        
        return cell;
        
    }else{
        
        OccupationDetailsProTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OccupationDetailsProTableViewCell class]) forIndexPath:indexPath];
        
        NSArray<ProfessionalCategoryModel *> *arr = self.occupationDetailsModel.majors;
        [cell updateModel:arr[indexPath.row]];
        
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 1){
        NSArray<ProfessionalCategoryModel *> *model = self.occupationDetailsModel.majors;
        ProfessionalDetailsViewController *vc = [ProfessionalDetailsViewController suspendTopPausePageVC];
        vc.majorCode = model[indexPath.row].majorCode;
        [self.navigationController pushViewController:vc animated:YES];
        

    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView ==_tableView){
        CGFloat sectionHeaderHeight = 50;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0)
        {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y,0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight)
        {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}


@end
