//
//  TCArticleSearchViewController.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/22.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCArticleSearchViewController.h"
#import "ArticleDetailViewController.h"

#import "RelevanceArticleTableViewCell.h"
#import "ArticleVideoTableViewCell.h"

#import "ArticleDetailsModel.h"
@interface TCArticleSearchViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TCArticleSearchViewController 
@synthesize dataManager = _dataManager;
@synthesize filter = _filter;
- (void)loadView {
    [super loadView];
    self.view.backgroundColor = UIColor.fe_contentBackgroundColor;


    self.view.backgroundColor = UIColor.fe_backgroundColor;
    _tableView = [UITableView new];
    _tableView.backgroundColor = UIColor.fe_contentBackgroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [_tableView addFooterRefreshTarget:self action:@selector(loadData)];
    _tableView.tableFooterView = ({
        UIView *view = UIView.new;
        view.frame = CGRectMake(0, 0, mScreenWidth, STWidth(10));
        view.backgroundColor = UIColor.fe_backgroundColor;
        view;
    });
    _tableView.tableFooterView = ({
        UIView *view = UIView.new;
        view.frame = CGRectMake(0, 0, mScreenWidth, mBottomSafeHeight);
        view.backgroundColor = UIColor.fe_contentBackgroundColor;
        view;
    });
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView registerClass:[RelevanceArticleTableViewCell class] forCellReuseIdentifier:NSStringFromClass([RelevanceArticleTableViewCell class])];
    [_tableView registerClass:[ArticleVideoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ArticleVideoTableViewCell class])];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
}


- (void)loadData {
    @weakObj(self);
    [self.dataManager getSearchResultByFilter:self.filter type:TCSearchTypeArticle onSuccess:^{
        [selfweak.tableView reloadData];
        [selfweak showEmptyViewIfEmpty];
    } failure:^{
        [selfweak showNetErrorViewIfNeeded];
    }];
}

- (void)startSearchWithFilter:(NSString *)filter {
    self.filter = filter;
    [self loadData];
}

- (void)showNetErrorViewIfNeeded {
    if (self.dataManager.articleResult.count == 0) {
        @weakObj(self);
        [self showEmptyViewForNoNetInView:selfweak.view refreshHandler:^{
            [selfweak loadData];
        }];
    }
}

- (void)showEmptyViewIfEmpty {
    if (self.dataManager.articleResult.count == 0) {
        [self showEmptyViewInView:self.view type:FEErrorType_NoSeek];
    } else {
        [self hideEmptyView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [mKeyWindow endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataManager.articleResult.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     ArticleDetailsModel *article = self.dataManager.articleResult[indexPath.row];
    UITableViewCell *cell;
     if(![NSString isEmptyString:article.articleVideo]){
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ArticleVideoTableViewCell class]) forIndexPath:indexPath];
     }else{
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RelevanceArticleTableViewCell class]) forIndexPath:indexPath];
           
    }

    if (article) {
        ArticleVideoTableViewCell *_cell = (ArticleVideoTableViewCell *)cell;
        [_cell updateArticleModel:article];
    } else {
        RelevanceArticleTableViewCell *_cell = (RelevanceArticleTableViewCell *)cell;
        [_cell updateArticleModel:article];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleDetailsModel *article = self.dataManager.articleResult[indexPath.row];
  
    ArticleDetailViewController *articleViewController = [[ArticleDetailViewController alloc] init];
    articleViewController.articleModel = article;
    [self.navigationController pushViewController:articleViewController animated:YES];
    
    
}
@end
