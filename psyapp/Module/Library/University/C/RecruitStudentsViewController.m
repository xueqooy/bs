//
//  RecruitStudentsViewController.m
//  smartapp
//  学校详情-招生录取
//  Created by lafang on 2019/3/12.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "RecruitStudentsViewController.h"
#import "CareerService.h"
#import "EnrollmentRootModel.h"
#import "EnrollmentOfficeTableViewCell.h"
#import "EnrollmentNavigationTableViewCell.h"
#import "CollegeAdmissionTableViewCell.h"
#import "ProfessionalAdmissionTableViewCell.h"
#import "AdmissionParamModel.h"
#import "UniversityAdminsionModel.h"
#import "ProfessionalAdminsionModel.h"
#import "CommonBottomMenuView.h"
#import "YTKKeyValueStore.h"
#import "ProvinceRootModel.h"
#import "QSWebViewBaseController.h"
#import "UniversityYearModel.h"
#import "UniversityKindModel.h"
@interface RecruitStudentsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) EnrollmentRootModel *enrollmentRootModel;

@property(nonatomic,strong) NSMutableArray<EnrollmentNavigationItemModel *> *enrollmentNavigationItemModels;//招生章程分组列表打平数据

@property(nonatomic,strong) NSArray<UniversityAdminsionModel *> *universityAdminsionModels;
@property(nonatomic,strong) NSArray<ProfessionalAdminsionModel *> *professionalAdminsionModels;

@property(nonatomic,strong) NSMutableArray<NSString *> *provinceArray;
@property(nonatomic,strong) NSArray<ProvinceModel *> *provinceModels;
@property(nonatomic,strong) NSArray<UniversityYearModel *> *yearArray;
@property(nonatomic,strong) NSArray<UniversityKindModel *> *pakindArray;
@property(nonatomic,strong) NSArray<UniversityKindModel *> *uakindArray;

@property(nonatomic,strong) NSString *uaProvince;
@property(nonatomic,strong) NSString *uaKind;

@property(nonatomic,strong) NSString *paProvince;
@property(nonatomic,strong) NSString *paYear;
@property(nonatomic,strong) NSString *paKind;

@end

@implementation RecruitStudentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
}


-(void)setupView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.tableView registerClass:[EnrollmentOfficeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([EnrollmentOfficeTableViewCell class])];
    [self.tableView registerClass:[EnrollmentNavigationTableViewCell class] forCellReuseIdentifier:NSStringFromClass([EnrollmentNavigationTableViewCell class])];
    [self.tableView registerClass:[CollegeAdmissionTableViewCell class] forCellReuseIdentifier:NSStringFromClass([CollegeAdmissionTableViewCell class])];
    [self.tableView registerClass:[ProfessionalAdmissionTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ProfessionalAdmissionTableViewCell class])];

    
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"footer"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, mScreenWidth, 0.01f)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, mScreenWidth, mScreenHeight)];
    
}

-(void)loadData{
    UniversityModel *model = self.universitySituationModel.universityModel;
    [CareerService getUniversityStudentBrochure:model.universityId success:^(id data) {
        if(data){
            EnrollmentRootModel *dataModel = [MTLJSONAdapter modelOfClass:EnrollmentRootModel.class fromJSONDictionary:data error:nil];
            if(dataModel){
                self.enrollmentRootModel = dataModel;
                
                self.enrollmentNavigationItemModels = [[NSMutableArray alloc] init];
                NSArray<EnrollmentNavigationModel *> *models = self.enrollmentRootModel.enrollmentNavigation;
                for(int i=0;i<models.count;i++){
                    NSArray<EnrollmentNavigationItemModel *> *itemModels = models[i].items;
                    for(int j=0;j<itemModels.count;j++){
                        if(j==0){
                            itemModels[j].fatherName = models[i].name;
                        }else{
                            itemModels[j].fatherName = @"";
                        }
                        [self.enrollmentNavigationItemModels addObject:itemModels[j]];
                    }
                }
                
                [self.tableView reloadData];
                
                //先取缓存数据
                YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:YTK_DB_NAME];
                NSDictionary *province = [store getObjectById:YTK_PROVINCE_KEY fromTable:YTK_TABLE_UNIVERSITY];
                [store close];
                if(province){
                    if(dataModel){
                        ProvinceRootModel *dataModel = [MTLJSONAdapter modelOfClass:ProvinceRootModel.class fromJSONDictionary:province error:nil];
                        self.provinceModels = dataModel.items;
                        self.provinceArray = [[NSMutableArray alloc] init];
                        for(int i=0;i<self.provinceModels.count;i++){
                            ProvinceModel *model = self.provinceModels[i];
                            [self.provinceArray addObject:model.name];
                        }
                        [self initYearAndKind];
                    }
                }else{
                    [CareerService getProvinceList:^(id data) {
                        if(data){
                            ProvinceRootModel *dataModel = [MTLJSONAdapter modelOfClass:ProvinceRootModel.class fromJSONDictionary:data error:nil];
                            if(dataModel){
                                ProvinceRootModel *dataModel = [MTLJSONAdapter modelOfClass:ProvinceRootModel.class fromJSONDictionary:province error:nil];
                                self.provinceModels = dataModel.items;
                                self.provinceArray = [[NSMutableArray alloc] init];
                                for(int i=0;i<self.provinceModels.count;i++){
                                    ProvinceModel *model = self.provinceModels[i];
                                    [self.provinceArray addObject:model.name];
                                }
                                [self initYearAndKind];
                            }
                        }
                    } failure:^(NSError *error) {
                        [HttpErrorManager showErorInfo:error showView:self.view];
                        
                    }];
                }
                
                
                
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)initYearAndKind{
    [CareerService getAdmissionStuYear:^(id data) {
        if(data){
            NSArray<UniversityYearModel *> *yearArray = [MTLJSONAdapter modelsOfClass:UniversityYearModel.class fromJSONArray:data[@"items"] error:nil];
            if(yearArray){
                
                UniversityModel * model = self.universitySituationModel.universityModel;
                
                self.yearArray = yearArray;
                
                self.uaProvince = model.state;
                self.paProvince = model.state;
                self.paYear = [yearArray[0].year stringValue];
                
                [CareerService getAdminssionKinds:self.uaProvince year:self.paYear success:^(id data) {
                    if(data){
                        NSArray<UniversityKindModel *> *kindArray = [MTLJSONAdapter modelsOfClass:UniversityKindModel.class fromJSONArray:data[@"items"] error:nil];
                        if(kindArray){
                            
                            self.pakindArray = kindArray;
                            self.uakindArray = kindArray;
                            
                            self.uaKind = kindArray[0].kind;
                            self.paKind = kindArray[0].kind;
                            
                            [self getUniversityAdminsion];
                            
                            [self getProfessionalAdminsion];
                        }
                    }
                } failure:^(NSError *error) {
                    
                }];
            }
            
        }
    } failure:^(NSError *error) {
        
    }];
}

//获取院校录取
-(void)getUniversityAdminsion{
    AdmissionParamModel *model = [[AdmissionParamModel alloc] init];
    model.province = self.uaProvince;
    model.kind = self.uaKind;
    model.school = self.universitySituationModel.universityModel.cnName;
    [QSLoadingView show];
    [CareerService getAdminsionUniversities:model success:^(id data) {
        [QSLoadingView dismiss];
        if(data){
            NSArray<UniversityAdminsionModel *> *dataModels = [MTLJSONAdapter modelsOfClass:UniversityAdminsionModel.class fromJSONArray:data[@"items"] error:nil];
            if(dataModels){
                self.universityAdminsionModels = dataModels;
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error showView:self.view];
    }];
}

//专业录取
-(void)getProfessionalAdminsion{
    
    AdmissionParamModel *model = [[AdmissionParamModel alloc] init];
    model.province = self.paProvince;
    model.kind = self.paKind;
    model.year = self.paYear;
    model.school = self.universitySituationModel.universityModel.cnName;
    [QSLoadingView show];
    [CareerService getAdminsionMajors:model success:^(id data) {
        [QSLoadingView dismiss];
        if(data){
            NSArray<ProfessionalAdminsionModel *> *dataModels = [MTLJSONAdapter modelsOfClass:ProfessionalAdminsionModel.class fromJSONArray:data[@"items"] error:nil];
            if(dataModels && dataModels.count>0){
                self.professionalAdminsionModels = dataModels;
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            }
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
    return self.enrollmentRootModel ? 4 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0){
        return 3;
    }else if(section == 1){
        return self.enrollmentNavigationItemModels.count;
    }else if(section == 2){
//        return self.universityAdminsionModels ? 1 : 0;
        return 1;
    }else{
//        return self.professionalAdminsionModels ? 1 : 0;
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
        [AddItemViewsManager addCommenTitleView:headerView title:@"招生办信息"];
    }else if(section == 1){
        [AddItemViewsManager addCommenTitleView:headerView title:@"招生章程"];
    }else if(section == 2){
        [AddItemViewsManager addCommenTitleView:headerView title:@"院校录取"];
    }else{
        [AddItemViewsManager addCommenTitleView:headerView title:@"专业录取"];
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
        EnrollmentOfficeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EnrollmentOfficeTableViewCell class]) forIndexPath:indexPath];
        if(indexPath.row == 0){
            [cell updateModel:self.enrollmentRootModel.enrollmentOffice.contactInfo key:@"contactInfo"];
        }else if(indexPath.row == 1){
            [cell updateModel:self.enrollmentRootModel.enrollmentOffice.website key:@"website"];
        }else{
            [cell updateModel:self.enrollmentRootModel.enrollmentOffice.address key:@"address"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 1){
        EnrollmentNavigationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EnrollmentNavigationTableViewCell class]) forIndexPath:indexPath];
        
        [cell updateModel:self.enrollmentNavigationItemModels[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 2){
        CollegeAdmissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CollegeAdmissionTableViewCell class]) forIndexPath:indexPath];
        
        [cell updateModel:self.universityAdminsionModels curProvince:self.uaProvince curKind:self.uaKind];
        
        cell.filterCallBack = ^(NSInteger index) {
            if(index == 1){
                CommonBottomMenuView *showView = [[CommonBottomMenuView alloc] initWithData:self.provinceArray title:@"生源地"];
                showView.menuCallBack = ^(NSInteger index) {
                    self.uaProvince = self.provinceArray[index];
                    
                    [CareerService getAdminssionKinds:self.uaProvince year:@"" success:^(id data) {
                        if(data){
                            
                            NSArray<UniversityKindModel *> *kindArray = [MTLJSONAdapter modelsOfClass:UniversityKindModel.class fromJSONArray:data[@"items"] error:nil];
                            if(kindArray){
                                
                                self.uakindArray = kindArray;
                                self.uaKind = kindArray[0].kind;
                                [self getUniversityAdminsion];
                                
                            }
                        }
                     } failure:^(NSError *error) {
                         
                     }];
                    
                };
                [showView showInView:[UIApplication sharedApplication].keyWindow];
            }else{
                NSMutableArray<NSString *> *array = [[NSMutableArray alloc] init];
                for(int i=0;i<self.uakindArray.count;i++){
                    [array addObject:self.uakindArray[i].kind];
                }
                CommonBottomMenuView *showView = [[CommonBottomMenuView alloc] initWithData:array title:@"文理分科"];
                showView.menuCallBack = ^(NSInteger index) {
                    self.uaKind = self.uakindArray[index].kind;
                    [self getUniversityAdminsion];
                };
                [showView showInView:[UIApplication sharedApplication].keyWindow];
            }
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        ProfessionalAdmissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProfessionalAdmissionTableViewCell class]) forIndexPath:indexPath];
        
        [cell updateModel:self.professionalAdminsionModels curProvince:self.paProvince curYear:self.paYear curKind:self.paKind];
        
        cell.filterCallBack = ^(NSInteger index) {
            if(index == 1){
                CommonBottomMenuView *showView = [[CommonBottomMenuView alloc] initWithData:self.provinceArray title:@"生源地"];
                showView.menuCallBack = ^(NSInteger index) {
                    self.paProvince = self.provinceArray[index];
                    [CareerService getAdminssionKinds:self.paProvince year:self.paYear success:^(id data) {
                        if(data){
                            NSArray<UniversityKindModel *> *kindArray = [MTLJSONAdapter modelsOfClass:UniversityKindModel.class fromJSONArray:data[@"items"] error:nil];
                            if(kindArray){
                                
                                self.pakindArray = kindArray;
                                self.paKind = kindArray[0].kind;
                                [self getProfessionalAdminsion];
                                
                            }
                        }
                    } failure:^(NSError *error) {
                        
                    }];
                };
                [showView showInView:[UIApplication sharedApplication].keyWindow];
            }else if(index == 2){
                NSMutableArray<NSString *> *array = [[NSMutableArray alloc] init];
                for(int i=0;i<self.yearArray.count;i++){
                    [array addObject:[self.yearArray[i].year stringValue]];
                }
                CommonBottomMenuView *showView = [[CommonBottomMenuView alloc] initWithData:array title:@"年份"];
                showView.menuCallBack = ^(NSInteger index) {
                    self.paYear = [self.yearArray[index].year stringValue];
                    [CareerService getAdminssionKinds:self.paProvince year:self.paYear success:^(id data) {
                        if(data){
                            NSArray<UniversityKindModel *> *kindArray = [MTLJSONAdapter modelsOfClass:UniversityKindModel.class fromJSONArray:data[@"items"] error:nil];
                            if(kindArray){
                                
                                self.pakindArray = kindArray;
                                self.paKind = kindArray[0].kind;
                                [self getProfessionalAdminsion];
                                
                            }
                        }
                    } failure:^(NSError *error) {
                        
                    }];
                };
                [showView showInView:[UIApplication sharedApplication].keyWindow];
            }else{
                NSMutableArray<NSString *> *array = [[NSMutableArray alloc] init];
                for(int i=0;i<self.pakindArray.count;i++){
                    [array addObject:self.pakindArray[i].kind];
                }
                CommonBottomMenuView *showView = [[CommonBottomMenuView alloc] initWithData:array title:@"文理分科"];
                showView.menuCallBack = ^(NSInteger index) {
                    self.paKind = self.pakindArray[index].kind;
                    [self getProfessionalAdminsion];
                };
                [showView showInView:[UIApplication sharedApplication].keyWindow];
            }
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0){
        if(indexPath.row == 1){
            //招生办地址
            QSWebViewBaseController *vc = [[QSWebViewBaseController alloc] init];
            vc.url = self.enrollmentRootModel.enrollmentOffice.website;
            vc.navigationItem.title = @"招生办地址";
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }else if(indexPath.section == 1){
        
        //招生章程
        QSWebViewBaseController *vc = [[QSWebViewBaseController alloc] init];
        vc.url = self.enrollmentNavigationItemModels[indexPath.row].url;
        vc.navigationItem.title = self.enrollmentNavigationItemModels[indexPath.row].name;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


@end
