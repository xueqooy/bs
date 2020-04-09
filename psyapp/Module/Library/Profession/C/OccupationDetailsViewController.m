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
    AVObject *followData;
    BOOL _isFollow;
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
        [weakSelf clickRightBarButtonItem];
    };
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aSwitch];
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
}

-(void)clickRightBarButtonItem{
    if (BSUser.currentUser == nil) {
        [UCManager showLoginAlertIfVisitorPatternWithMessage:@"需要登录"];
    }

    NSMutableArray *occupations = ((NSArray *)[self->followData objectForKey:@"occupations"]).mutableCopy;
    void (^block)(void) = ^{
        [self->followData setObject:occupations forKey:@"occupations"];
        [self->followData saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                if (self->_isFollow) {
                    [QSToast toast:self.view message:@"取消关注"];
                    self->_isFollow = NO;
                } else {
                    [QSToast toast:self.view message:@"关注成功"];
                    self->_isFollow = YES;
                }
                [self updateFolowStatus];
            }
        }];
    };
    
    if (_isFollow) {
        for (NSDictionary *occupationDic in occupations) {
            if ([occupationDic[@"occupationId"] isEqualToString:self.occupationId]) {
                [occupations removeObject:occupationDic];
                block();
                return;
            }
        }
    } else {
        NSDictionary *occupationDic = @{
            @"occupationId" : self.occupationId,
            @"occupationName" : self.occupationDetailsModel.occupationName?  self.occupationDetailsModel.occupationName : @""
        };
        [occupations addObject:occupationDic];
        block();
        return;
    }
    
    
}

-(void)updateFolowStatus{
    if(_isFollow){
        [aSwitch setOn:YES hasHandler:NO];
    }else{
        [aSwitch setOn:NO hasHandler:NO];
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
            }
        }
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error showView:self.view];
    }];
    
    [self loadFollowData];
}

- (void)loadFollowData {
    BSUser *currentUser = BSUser.currentUser;
    if (currentUser) {
        AVQuery *query = [AVQuery queryWithClassName:@"LibFollow"];
        [query whereKey:@"userId" equalTo:currentUser.objectId];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (objects.firstObject) {
                self->followData = objects.firstObject;
            } else {
                self->followData = [AVObject objectWithClassName:@"LibFollow"];
                [self->followData setObject:currentUser.objectId forKey:@"userId"];
            }
            NSArray *occupations;
            if ([self->followData objectForKey:@"occupations"]) {
                occupations = [self->followData objectForKey:@"occupations"];
                for (NSDictionary *occupationDic in occupations) {
                    if ([occupationDic[@"occupationId"] isEqualToString:self.occupationId]) {
                        self->_isFollow = YES;
                        [self updateFolowStatus];
                        return ;
                    }
                }
            } else {
                occupations = @[];
                [self->followData setObject:occupations forKey:@"occupations"];
                self->_isFollow = NO;
                [self updateFolowStatus];
                return ;
            }
        }];
    }
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
