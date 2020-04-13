//
//  FEMyCollectViewController.m
//  smartapp
//
//  Created by lafang on 2018/8/21.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEMyCollectViewController.h"
#import <Masonry/Masonry.h>
#import "UIView+Extension.h"
#import "UIColor+Category.h"
#import "UCManager.h"
#import "FEArticleTableViewCell.h"
#import "EvaluateService.h"
#import "QSLoadingView.h"
#import "QSToast.h"
#import "HttpErrorManager.h"
#import "ArticleDetailsModel.h"
#import "ArticleDetailViewController.h"
#import "ConstantConfig.h"
#import "MJRefresh.h"
#import "FERectSpreadTransition.h"

@interface FEMyCollectViewController ()<UITableViewDataSource,UITableViewDelegate, UINavigationControllerDelegate>

@property(nonatomic,strong) NSMutableArray<ArticleDetailsModel *> *articleModels;

@property (nonatomic, strong) NSIndexPath *selectedCellIndexPath;

@end

@implementation FEMyCollectViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的收藏";
    self.view.backgroundColor = UIColor.fe_backgroundColor;

    if (UCManager.sharedInstance.isVisitorPattern) {
         [self showEmptyViewInView:self.view type:FEErrorType_NoData];
        return;
    }
    self.navigationController.delegate = self;


    [self setupSubViews];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.commonLineView.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void) setupSubViews {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[FEArticleTableViewCell class] forCellReuseIdentifier:NSStringFromClass([FEArticleTableViewCell class])];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"footer"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = UIColor.fe_backgroundColor;
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, CGFLOAT_MIN)];
        view;
    });
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
;
    }];
    
    [self.view layoutIfNeeded];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.articleModels?self.articleModels.count:0;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0;
}

//此方法表示自定义高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    headerView.contentView.backgroundColor = UIColor.fe_backgroundColor;
    
    return  headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    footerView.contentView.backgroundColor = UIColor.fe_backgroundColor;
    return  footerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FEArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FEArticleTableViewCell class]) forIndexPath:indexPath];
    [cell setModel:self.articleModels[indexPath.section]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    @weakObj(self);
    cell.resultCollect = ^(ArticleDetailsModel *articleModel) {
        [selfweak loadData];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _selectedCellIndexPath = indexPath;

    ArticleDetailViewController *vc = [[ArticleDetailViewController alloc] init];
    vc.articleModel = self.articleModels[indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        FERectSpreadTransition *transiton = [FERectSpreadTransition transitionWithType:FERectSpreadTransitionPresent];
        transiton.duration = 0.25;
        transiton.targetView = [_tableView cellForRowAtIndexPath:_selectedCellIndexPath];
        return transiton;
    } else {
        return nil;
    }
    
}

-(void)loadData{
    if (BSUser.currentUser == nil) return;
    self.articleModels = @[].mutableCopy;
    AVQuery *query = [[AVQuery alloc] initWithClassName:@"ArticleCollection"];
    [query whereKey:@"userId" equalTo:BSUser.currentUser.objectId];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        if (error || object == nil) {
            [self showEmptyViewInView:self.view type:FEErrorType_NoCollection];
            return ;
        } else {
            NSArray *articles = [object objectForKey:@"articles"];
            if (articles == nil || articles.count == 0) {
                [self showEmptyViewInView:self.view type:FEErrorType_NoCollection];
                return ;
            } else {
                for (AVObject *article in articles) {
                    [article fetch];
                    ArticleDetailsModel *articleModel = [[ArticleDetailsModel alloc] initWithAVObject:article];
                    [self.articleModels addObject:articleModel];
                }
                [self.tableView reloadData];
            }
        }
    }];
    
}


@end
