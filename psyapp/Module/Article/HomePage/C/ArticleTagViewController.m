//
//  ArticleTagViewController.m
//  smartapp
//
//  Created by lafang on 2018/10/10.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "ArticleTagViewController.h"
#import "UIView+Extension.h"
#import "UIColor+Category.h"
#import "UIImage+Category.h"
#import <Masonry/Masonry.h>
#import "UIImageView+WebCache.h"
#import "RelevanceArticleTableViewCell.h"
#import "ArticleVideoTableViewCell.h"
#import "ArticleMoreImageTableViewCell.h"
#import "EvaluateService.h"
#import "ArticleDetailsModel.h"
#import "TCHTTPService.h"

#import "MJRefresh.h"
#import "ArticleDetailViewController.h"
@interface ArticleTagViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong) UIImageView *loadImageView;

@property(nonatomic,strong) NSMutableArray<ArticleDetailsModel *> *articleModels;


@end

@implementation ArticleTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupView];
    [self loadArticles];
    
}



- (void)setupView{
    
    self.view.backgroundColor =  UIColor.fe_contentBackgroundColor;
    
    self.tableView = [[UITableView alloc] init];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[RelevanceArticleTableViewCell class] forCellReuseIdentifier:NSStringFromClass([RelevanceArticleTableViewCell class])];
    [self.tableView registerClass:[ArticleVideoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ArticleVideoTableViewCell class])];
    self.tableView.scrollsToTop = YES;
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"footer"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundColor = UIColor.fe_contentBackgroundColor;
    
    //下拉刷新
    @weakObj(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfweak loadArticles];
        [TCSystemFeedbackHelper impactLight];
    }];
    header.arrowView.image = nil;
    [header setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新数据" forState:MJRefreshStatePulling];
    [header setTitle:@"数据加载中···" forState:MJRefreshStateRefreshing];
    header.stateLabel.textColor = UIColor.fe_auxiliaryTextColor;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.backgroundColor = UIColor.clearColor;

    self.tableView.mj_header = header;
    

    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //自动更改透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    self.tableView.layer.masksToBounds = YES;
    self.tableView.layer.cornerRadius = 5;

    //防止刷新后滚动一下
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    [self.view layoutIfNeeded];
    self.headerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableHeaderView = self.headerView;
    
 
    self.loadImageView = [[UIImageView alloc] init];
    [self.loadImageView setImage:[UIImage imageNamed:@"fire_tagpage_load_bg"]];
    self.loadImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.loadImageView.layer.masksToBounds= YES;
    [self.view addSubview:self.loadImageView];
    [self.loadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    


}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articleModels?self.articleModels.count:0;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return  UITableViewAutomaticDimension;
//}
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleDetailsModel *articleModel = self.articleModels[indexPath.row];
    if (![NSString isEmptyString:articleModel.articleVideo]) {
        return STWidth(300);
    }
    return STWidth(110);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ArticleDetailsModel *articleModel = self.articleModels[indexPath.row];
    
    if(![NSString isEmptyString:articleModel.articleVideo]){
        
        ArticleVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ArticleVideoTableViewCell class]) forIndexPath:indexPath];
        
        [cell updateArticleModel:articleModel];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }else{
        RelevanceArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RelevanceArticleTableViewCell class]) forIndexPath:indexPath];
        
        [cell updateArticleModel:articleModel];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
        
            
        
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ArticleDetailsModel *model = self.articleModels[indexPath.row];

    ArticleDetailViewController *vc = [[ArticleDetailViewController alloc] init];
    vc.articleModel = model;

    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)loadArticles{
    self.articleModels = @[].mutableCopy;
    
    if(!self.categroyModel){
        return;
    }
    [self hideEmptyView];

    AVQuery *query = [AVQuery queryWithClassName:@"Article"];
    [query whereKey:@"category" equalTo:self.categroyModel.name];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.loadImageView.hidden = YES;
        if (error) {
            [QSLoadingView dismiss];
            [HttpErrorManager showErorInfo:error];
            @weakObj(self);
            [self showEmptyViewForNoNetInView:self.view refreshHandler:^{
                [selfweak loadArticles];
            }];
        } else {
            for (AVObject *object in objects) {
                ArticleDetailsModel *articleModel = [[ArticleDetailsModel alloc] initWithAVObject:object];
                
                [self.articleModels addObject:articleModel];
                [self.tableView reloadData];
            }
        }
    }];

}





@end
