//
//  ArticleDetailViewController.m
//  smartapp
//
//  Created by 剑辉  薛 on 2019/7/2.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "EvaluateService.h"
#import "ArticleDetailsModel.h"
#import "CommentModel.h"
#import "SJVideoPlayer.h"
#import "UserService.h"
#import "TCCommentTableViewCell.h"
#import "TCTitleHeaderView.h"
#import "FECommentView.h"
#import "ArticleModel.h"
#import "FEWebViewManager.h"
//#import "FEAppURLHandler.h"
#import "UILabel+FEChain.h"
#import "FEBaseViewController+CustomTitleTransition.h"
#import "TCArticleLoader.h"
#import "UITableView+FDTemplateLayoutCell.h"
@interface ArticleDetailViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong) UIView *headerView;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *sourceNameLabel;
@property(nonatomic,strong) UILabel *publishTimeLabel;
@property(nonatomic,strong) UILabel *readCountLabel;
@property(nonatomic,strong) UIImageView *readCountImage;

@property(nonatomic,strong) UIImageView *articleImageView;
@property(nonatomic,strong) UIImageView *playImage;
@property(nonatomic,strong) SJVideoPlayer *videoPlayer;
@property(nonatomic,strong) SJPlaybackObservation *playbackObservation;

@property (nonatomic, strong) FEWebViewManager *webViewManager;


@property(nonatomic,strong) FECommentView *commentView;
@property(nonatomic,strong) UIView *emptyCommentView;



@property(nonatomic,strong) ArticleDetailsModel *articleDetailsModel;


@property(nonatomic,assign) NSInteger page;
@property(nonatomic,assign) NSInteger size;

@property(nonatomic, strong) NSMutableArray *commentsHeightArray;


@property(nonatomic,assign) CGFloat bottomHeight;

@property(nonatomic,assign) BOOL isComment;
@end

@implementation ArticleDetailViewController



#pragma mark -
#pragma mark - Life Circle & Others
- (instancetype)init {
    self = [super init];
    self.source = DiscoveryArticleSourceList;
    return self;
}

- (void)dealloc {
    if(self.videoPlayer){
        [self.videoPlayer stop];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.fe_contentBackgroundColor;
   
    self.fd_prefersNavigationBarHidden = ![NSString isEmptyString:_articleModel.articleVideo];
    
    self.page = 1;
    self.size = 20;
    
    _bottomHeight = [SizeTool height:49];
    
    _webViewManager = [FEWebViewManager new];
    [self configWebViewManager];
    
    //从其他tab跳转时无法传入articleModel， 视图创建延迟到数据请求之后
    [self setupView];
    [self updateData:_articleModel];
    [self showLoadingView];
    [self setNavigationBarShadowHidden:YES];
    self.customTitleLabel = self.defaultCustomTitleLabel;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self setNavigationBarImage:UIImage.fe_normalNavigationBarBackgroundImage];

    [self.videoPlayer vc_viewDidAppear];
    
    [mKeyWindow endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.videoPlayer vc_viewWillDisappear];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.videoPlayer vc_viewDidDisappear];
    
    if(self.videoPlayer){
        [self.videoPlayer pause];
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.videoPlayer vc_preferredStatusBarStyle];
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

-(void)setupView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = UIColor.fe_contentBackgroundColor;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[TCCommentTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TCCommentTableViewCell class])];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"footer"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dropDownToRefresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新数据" forState:MJRefreshStatePulling];
    [header setTitle:@"数据加载中···" forState:MJRefreshStateRefreshing];
    self.tableView.mj_header = header;
    
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadCommentMoreData)];
    [footer setTitle:@"上拉加载数据" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开立即加载更多数据" forState:MJRefreshStatePulling];
    [footer setTitle:@"更多数据加载中 ..." forState:MJRefreshStateRefreshing];
    footer.stateLabel.font = [UIFont systemFontOfSize:17];
    self.tableView.mj_footer = footer;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    BOOL videoType = ![NSString isEmptyString:_articleModel.articleVideo] ;
      //视频频显示头图
   if (videoType) {
       
      self.articleImageView = [[UIImageView alloc] init];
      self.articleImageView.contentMode = UIViewContentModeScaleAspectFill;
      self.articleImageView.clipsToBounds = YES;
      [self.view addSubview:self.articleImageView];
      [self.articleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.offset(mStatusBarHeight);
          make.left.right.offset(0);
          make.height.mas_equalTo(mScreenWidth * 9/16);
      }];
      if (self.articleModel.articleImg && ![self.articleModel.articleImg isEqualToString:@""]) {
          [self.articleImageView sd_setImageWithURL:[NSURL URLWithString:self.articleModel.articleImg] placeholderImage:[UIImage imageNamed:@"fire_dimension_default"] options:0 progress:nil completed:nil];
      }else{
          [self.articleImageView setImage:[UIImage imageNamed:@"fire_dimension_default"]];
      }
      self.articleImageView.userInteractionEnabled = YES;
      UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(articlePlayerClick)];
      [self.articleImageView addGestureRecognizer:tapGesturRecognizer];
      
      //视频资源
      self.playImage = [[UIImageView alloc] init];
      [self.playImage setImage:[UIImage imageNamed:@"fire_video_play"]];
      [self.articleImageView addSubview:self.playImage];
      [self.playImage mas_makeConstraints:^(MASConstraintMaker *make) {
          make.center.equalTo(self.articleImageView);
          make.size.mas_equalTo(CGSizeMake(40,40));
      }];
      self.playImage.hidden = NO;
      
      //视频播放view
      self.videoPlayer = [SJVideoPlayer player];
       self.videoPlayer.defaultEdgeControlLayer.hiddenBackButtonWhenOrientationIsPortrait = YES;
      [self.articleImageView addSubview:_videoPlayer.view];
      [self.videoPlayer.view mas_makeConstraints:^(MASConstraintMaker *make) {
          make.edges.mas_equalTo(UIEdgeInsetsZero);
      }];
      self.videoPlayer.view.hidden = YES;
      
       
      self.backBtn = [[UIButton alloc] init];
      self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(8,8,8,8);
      self.backBtn.layer.masksToBounds = YES;
      self.backBtn.layer.cornerRadius = STWidth(16);
      self.backBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
      [self.backBtn setImage:[UIImage imageNamed:@"share_back_white"] forState:UIControlStateNormal];
      [self.backBtn addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.articleImageView addSubview:self.backBtn];
      [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.left.offset(STWidth(15));
          make.size.mas_equalTo(STSize(32, 32));
      }];
  }

    
    //自动更改透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (videoType) {
           make.top.equalTo(_articleImageView.mas_bottom).offset(0);
        } else {
           make.top.mas_offset(0.5);
        }
        make.left.right.offset(0);;
        make.bottom.equalTo(self.view).offset(-_bottomHeight - mBottomSafeHeight);
    }];

    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 60)];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = UIColor.fe_titleTextColorLighten;
    [self.titleLabel setFont:STFontBold(22)];
    self.titleLabel.text = @"";
    self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.titleLabel.numberOfLines = 0;
    [self.titleLabel sizeToFit];
    [self.headerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.left.equalTo(self.headerView).offset(20);
        make.right.equalTo(self.headerView).offset(-20);
    }];
    if(self.articleModel && ![self.articleModel.articleTitle isEqualToString:@""]){
        self.titleLabel.text = self.articleModel.articleTitle;
    }
    
    self.sourceNameLabel = [[UILabel alloc] init];
    self.sourceNameLabel.textColor = UIColor.fe_mainColor;
    self.sourceNameLabel.font = [UIFont systemFontOfSize:12];
    self.sourceNameLabel.text = @"";
    [self.headerView addSubview:self.sourceNameLabel];
    [self.sourceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.left.equalTo(self.headerView).offset(20);
    }];
    
    self.publishTimeLabel = [[UILabel alloc] init];
    self.publishTimeLabel.textColor = UIColor.fe_mainTextColor;
    self.publishTimeLabel.font = [UIFont systemFontOfSize:12];
    self.publishTimeLabel.text = @"2018-08-28";
    [self.headerView addSubview:self.publishTimeLabel];
    [self.publishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sourceNameLabel);
        make.left.equalTo(self.sourceNameLabel.mas_right).offset(20);
    }];
    
    self.readCountLabel = [[UILabel alloc] init];
    self.readCountLabel.textColor = UIColor.fe_auxiliaryTextColor;
    self.readCountLabel.font = [UIFont systemFontOfSize:12];
    self.readCountLabel.text = @"1000";
    [self.headerView addSubview:self.readCountLabel];
    [self.readCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sourceNameLabel);
        make.right.equalTo(self.headerView).offset(-20);
    }];
    
    self.readCountImage = [[UIImageView alloc] init];
    [self.readCountImage setImage:[UIImage imageNamed:@"fire_read_nor"]];
    [self.headerView addSubview:self.readCountImage];
    [self.readCountImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sourceNameLabel);
        make.right.equalTo(self.readCountLabel.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];

   
    
    [self.headerView addSubview:self.webViewManager.webView];
    [self.webViewManager.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.readCountImage.mas_bottom).offset(STWidth(10));
        make.left.equalTo(self.headerView).offset(10);
        make.right.equalTo(self.headerView).offset(-10);
        make.height.mas_equalTo(0);
    }];

    __weak typeof(self) weakSelf = self;
    _commentView = [FECommentView createCommentViewWithComponent:FECommentViewComponentCollect+FECommentViewComponentLike+FECommentViewComponentDiscuss];
    _commentView.hidden = YES;
    _commentView.commentSendHandler = ^(NSString * _Nonnull content) {
       
        if ([UCManager showLoginAlertIfVisitorPatternWithMessage:@"登录后可进行评论，确定去登录吗？"]) {
            return;
        }
        [weakSelf sendComment:content];
    };
    _commentView.componentClickHandler = ^(FECommentViewComponent type) {
        if (type == FECommentViewComponentDiscuss) {
            [weakSelf scrollToComment];
        } else if (type == FECommentViewComponentLike) {
            [weakSelf like];
        } else {
            [weakSelf collect];
        }
    };
    
    [self.view addSubview:_commentView];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-mBottomSafeHeight);
        make.height.mas_equalTo(_bottomHeight);
    }];
    
}

- (void)showLoadingView {
    [self showLoadingPlaceHolderViewInView:self.view type:FESketonTypeArticle];
    if (NO == [_articleModel.contentType isEqualToNumber:@2]) {
        self.loadingPlaceholderView.imageInsets = UIEdgeInsetsMake(- mNavBarAndStatusBarHeight, 0, 0, 0);
    }
}

- (void)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dropDownToRefresh {
    if ([_articleDetailsModel.showComment boolValue]) {
        [self loadCommentData];
    }

}

-(void) loadData:(NSString *) articleId{
    //[QSLoadingView show];
//    [EvaluateService articleDetails:articleId childExamId:nil unneedCount:YES success:^(id data) {
//        //[QSLoadingView dismiss];
//        if(data){
//            ArticleDetailsModel *articleDetails = [MTLJSONAdapter modelOfClass:ArticleDetailsModel.class fromJSONDictionary:data error:nil];
//            articleDetails.dimension_JSON = data[@"dimensions"];
//            [self observeAudioStatusChangedIfNeeded];
//
//            if(articleDetails){
//                [self uploadToCloud:articleDetails];
//                if (_articleModel == nil) {  //从其他tab跳入时，articleModel == nil
//                    _articleModel = [ArticleModel new];
//                    _articleModel.articleTitle = articleDetails.articleTitle;
//                    _articleModel.contentType = articleDetails.contentType;
//                    _articleModel.articleImg = articleDetails.articleImg;
//                    if ([_articleModel.contentType isEqualToNumber:@2]) {
//                        [self.navigationController setNavigationBarHidden:YES animated:NO];
//                    }
//                    [self setupView];
//                }
//
//                [self updateData:articleDetails];
//                @weakObj(self);
//                [self addDoubleClickGestureForNavigationBarWithHandler:^{
//                    @strongObj(self);
//                    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
//                } andTitle:@""];
//
//
//            }
//        }
//
//    } failure:^(NSError *error) {
//        [HttpErrorManager showErorInfo:error showView:mKeyWindow];
//        if ([error.userInfo[@"message"] isEqualToString:@"文章已下架"]) {
//            [self showEmptyViewInView:self.view type:FEErrorType_NoData];
//            [self.emptyView setTitleText:@"文章已下架"];
//        } else {
//            @weakObj(self);
//           [self showEmptyViewForNoNetInView:self.view refreshHandler:^{
//               [selfweak loadData:articleId];
//           }];
//        }
//    }];
}

//- (void)uploadToCloud:(ArticleDetailsModel *)article {
//    AVQuery *query = [AVQuery queryWithClassName:@"Article"];
//    [query whereKey:@"articleTitle" equalTo:article.articleTitle];
//    [query getFirstObjectInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
//        if (object == nil) {
//            AVObject *object = [AVObject objectWithClassName:@"Article"];
//            [object setObject:article.articleTitle forKey:@"articleTitle"];
//            [object setObject:article.articleImg forKey:@"articleImg"];
//            [object setObject:article.category.name forKey:@"category"];
//            [object setObject:article.pageView forKey:@"pageView"];
//            [object setObject:article.sourceName forKey:@"sourceName"];
//            [object setObject:article.articleContent forKey:@"articleContent"];
//            [object setObject:article.articleVideo forKey:@"articleVideo"];
//            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//                if (succeeded) {
//                    [QSToast toastWithMessage:@"上传成功"];
//                }
//            }];
//        }
//    }];
//}

-(void)updateData:(ArticleDetailsModel *) articleDetailModel{
    if(!articleDetailModel){
        return;
    }
    self.titleLabel.text = articleDetailModel.articleTitle;
    self.customTitleLabel.text = self.articleModel.articleTitle;

    _articleDetailsModel = articleDetailModel;
    
    
    if([articleDetailModel.showComment boolValue]){
        //self.tableView.mj_header.hidden = NO;
        self.tableView.mj_footer.hidden = YES;//先隐藏上拉，评论列表请求成功后在设置
        [self loadCommentData];
    }else{
   
        [_commentView setPlaceholder:@"评论已关闭"];
        _commentView.editable = NO;
        self.tableView.mj_footer.hidden = YES;
    }
    
    NSInteger countHeight = 0;
    
    self.articleDetailsModel = articleDetailModel;
    
    [self updateSupport];
    [self updateCollect];
    
    if(!self.articleDetailsModel){
        self.titleLabel.text = articleDetailModel.articleTitle;
    }
    
    self.sourceNameLabel.text = articleDetailModel.sourceName;
    self.publishTimeLabel.text = articleDetailModel.publishDate;
    self.readCountLabel.text = [NSString stringWithFormat:@"%@",articleDetailModel.pageView];
    

    if(![NSString isEmptyString:articleDetailModel.articleVideo]){//视频
        [self addVideoObservation];
    } else {
        self.playImage.hidden = YES;
    }
    
//    //加载webView
//    NSString *articleContentString = articleDetailModel.articleContent;
//    [self.webViewManager loadHTMLString:articleContentString];

    //C端改成加载本地web
    [self loadWebViewContent];

    
    countHeight = countHeight + [StringUtils addHeightBySize:self.titleLabel width:self.headerView.width-40].height + 30;
    countHeight = countHeight + [StringUtils addHeightBySize:self.sourceNameLabel width:self.headerView.width-40].height + 20;
    
    
    self.headerView.frame = CGRectMake(0, 0, self.tableView.width, countHeight);
       
}

#pragma mark -
#pragma mark - WebView

- (void)loadWebViewContent {
    NSURL *webURL = TCArticleLoader.webURL;
//    [self.webViewManager loadHTMLString:_articleModel.articleContent];
    [self.webViewManager loadFileURL:webURL allowingReadAccessToURL:NSBundle.mainBundle.bundleURL];
}

- (void)configWebViewManager {
    _webViewManager.webView.frame = CGRectMake(10, 10, mScreenWidth - 20, 0);
    _webViewManager.webView.scrollView.backgroundColor = UIColor.fe_contentBackgroundColor;
    _webViewManager.webView.backgroundColor = UIColor.fe_contentBackgroundColor;
    _webViewManager.shouldDisableZoom = YES;
    @weakObj(self);
    //界面完成导航
    _webViewManager.didFinishNavigationHandler = ^(CGFloat contentHeight) {
        if (!selfweak) return ;
        [TCArticleLoader loadArticle:selfweak.articleDetailsModel onWebView:selfweak.webViewManager.webView WithCompletion:^(BOOL success) {
        }];
    };
    
    _webViewManager.linkHandler = ^(NSString *url) {
//        [FEAppURLHandler handleWithURL:[NSURL URLWithString:url]];
//        [selfweak UMEventStatisticsForHandlingURLString:url];
    };
    
    //web内容发生变化回调
    [_webViewManager setHandler:^(id info) {
        @strongObj(self);
        if (!self) return ;
        if ([info isKindOfClass:NSDictionary.class]) {
            NSDictionary *heightInfo = ((NSDictionary *)info);
            NSNumber *heightNumber = heightInfo[@"height"];
            if (heightNumber) {
                [self updateWebViewHeight:heightNumber.floatValue + STWidth(40)];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self hideLoadingPlaceholderView];
                });
                self.commentView.hidden = NO;
            }
        }
    } forJSCallBackKey:@"contentDidChange"];

}

- (void)updateWebViewHeight:(CGFloat)height {
    CGRect frame = _headerView.frame;
    frame.size.height += height;
    _headerView.frame = frame;
   
    //加上这句代码，为了适配低版本iOS，tableHeaderView刷新高度后，而没有刷新tableView contentSize的情况
    {
       _tableView.tableHeaderView = nil;
       _tableView.tableHeaderView = _headerView;
    }
    [_webViewManager.webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
   
   
    [self.tableView reloadData];
    
}




#pragma mark -
#pragma mark - Video
- (void)addVideoObservation {

    self.playImage.hidden = NO;
    SJPlaybackObservation *playbackObservation = [[SJPlaybackObservation alloc] initWithPlayer:self.videoPlayer];
    playbackObservation.playbackStatusDidChangeExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull player) {
        if(player.timeControlStatus == SJPlaybackTimeControlStatusPaused){
        }else if(player.timeControlStatus == SJPlaybackTimeControlStatusPlaying || player.timeControlStatus == SJPlaybackTimeControlStatusWaitingToPlay){
        }
    };
    _playbackObservation = playbackObservation;

}
//视频播放
-(void)articlePlayerClick{
    if(![NSString isEmptyString:_articleModel.articleVideo] ){
        self.videoPlayer.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:_articleModel.articleVideo]];

        self.videoPlayer.view.hidden = NO;
       
        
    }
}


#pragma mark -
#pragma mark - Comment
//发表评论
-(void)sendComment:(NSString *)text{
    
    NSString *commentInfo = text;
    if([commentInfo isEqualToString:@""]){
        [QSToast toast:self.view message:@"评论内容不能为空"];
        return;
    }
    
//    [QSLoadingView show];
//    [EvaluateService articleComment:self.articleId commentInfo:commentInfo type:0 success:^(id data) {
//        [QSLoadingView dismiss];
//        CommentModel *dataModel = [MTLJSONAdapter modelOfClass:CommentModel.class fromJSONDictionary:data error:nil];
//        if(dataModel){
//            [QSToast toast:self.view message:@"评论成功"];
//            self.isComment = YES;
//            [self loadCommentData];
//        }
//    } failure:^(NSError *error) {
//        [QSLoadingView dismiss];
//        NSDictionary *errorDic = [HttpErrorManager showErorInfo:error showView:self.view];
//        if([errorDic[@"code"] isEqualToString:@"PSY_COMMENT_TIME_INVALID"]){
//        }
//    }];
}


-(void)setCommentCount:(NSInteger)newsNum{
    [_commentView setCount:newsNum forComponent:FECommentViewComponentDiscuss];
}



-(void)updateCollect{
    if([self.articleDetailsModel.favorite integerValue] == 1){
        [_commentView setSelected:YES forComponent:FECommentViewComponentCollect];
    }else{
        [_commentView setSelected:NO forComponent:FECommentViewComponentCollect];
    }
    
}

-(void)updateSupport{
    if([self.articleDetailsModel.like integerValue] == 1){
        [_commentView setSelected:YES forComponent:FECommentViewComponentLike];
    }else{
        [_commentView setSelected:NO forComponent:FECommentViewComponentLike];
        
    }
}

- (void)scrollToComment {
//    if(self.commentModels && self.commentModels.count>0){
//        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        [[self tableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }else{
//        if(self.tableView.contentSize.height>self.tableView.frame.size.height) {
//
//            CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
//            [self.tableView setContentOffset:offset animated:YES];
//
//        }
//    }
}

- (void)like {
    //点赞
    if ([UCManager showLoginAlertIfVisitorPatternWithMessage:@"登录后可进行点赞，确定去登录吗？"]) {
        return;
    }
    
    [EvaluateService articleLike:self.articleDetailsModel.articleId success:^(id data) {
        
        if([data[@"is_like"] boolValue]){
            self.articleDetailsModel.like = @1;
            self.articleDetailsModel.pageLike = @([self.articleDetailsModel.pageLike integerValue] + 1);

        }else{
            self.articleDetailsModel.like = @0;
            self.articleDetailsModel.pageLike = @([self.articleDetailsModel.pageLike integerValue] - 1);
        }
        [self updateSupport];
    } failure:^(NSError *error) {
        [HttpErrorManager showErorInfo:error showView:self.view];
        [self updateSupport];

    }];
}

- (void)collect {
    //收藏
    if ([UCManager showLoginAlertIfVisitorPatternWithMessage:@"登录后可进行收藏，确定去登录吗？"]) {
        return;
    }
  
    [EvaluateService articleCollect:self.articleDetailsModel.articleId success:^(id data) {
        
        if([data[@"is_favorite"] boolValue]){
            self.articleDetailsModel.favorite = @1;
            self.articleDetailsModel.pageFavorite = @([self.articleDetailsModel.pageFavorite integerValue] + 1);
            [QSToast toast:self.view message:@"收藏成功"];
        }else{
            self.articleDetailsModel.favorite = @0;
            self.articleDetailsModel.pageFavorite = @([self.articleDetailsModel.pageFavorite integerValue] - 1);
            [QSToast toast:self.view message:@"取消收藏"];
        }
        
        
        [self updateCollect];
    } failure:^(NSError *error) {
        [HttpErrorManager showErorInfo:error showView:self.view];
        [self updateCollect];

    }];
}






-(void)loadCommentData{
//    [_tableView.mj_footer setState:MJRefreshStateIdle];
//    NSInteger page = 1;
//    NSString *articleId = self.articleId ? self.articleId : (self.articleDetailsModel.articleId ? self.articleDetailsModel.articleId : @"");
//    [EvaluateService articleCommentList:articleId type:0 page:page size:self.size success:^(id data) {
//        //        [QSLoadingView dismiss];
//        [self.tableView.mj_header endRefreshing];
//        if(data){
//            CommentRootMdoel *dataModel = [MTLJSONAdapter modelOfClass:CommentRootMdoel.class fromJSONDictionary:data error:nil];
//            if(dataModel && dataModel.items && dataModel.items.count>0){
//                self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//                self.page = page;
//                self.commentRootModel = dataModel;
//                self.commentModels = [[NSMutableArray alloc] init];
//                [self.commentModels addObjectsFromArray:dataModel.items];
//                [self computeHeightForComments];
//
//                [self setCommentCount:self.commentRootModel.total];
//                [UIView performWithoutAnimation:^{
//                    [self.tableView reloadData];
//                }];
//
//                if(self.commentModels.count<self.size){
//                    self.tableView.mj_footer.hidden = YES;
//                }else{
//                    self.tableView.mj_footer.hidden = NO;
//                }
//
//                if(self.isComment){
//                    //评论后滚到第一行评论
//                    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//                    [[self tableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//                }
//                self.isComment = NO;
//            } else {//无评论,显示评论为空占位图
//                [self p_addCommentEmptyView];
//            }
//        }
//    } failure:^(NSError *error) {
//        NSDictionary *info = [HttpErrorManager getErorInfo:error];
//        if (![NSString isEmptyString:info[@"message"]]) {
//            if ([info[@"message"] isEqualToString:@"不允许进行评论"]) {
//               [_commentView setPlaceholder:@"评论已关闭"];
//               _commentView.editable = NO;
//               self.tableView.mj_header.hidden = YES;
//               self.tableView.mj_footer.hidden = YES;
//           }
//        }
//
//        [self.tableView.mj_header endRefreshing];
//        [HttpErrorManager showErorInfo:error showView:self.view];
//    }];
}

-(void)loadCommentMoreData{
//    if (self.commentModels.count >= self.commentRootModel.total) {
//
//        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        return;
//
//    }
//    NSInteger page = self.page +1;
//    [EvaluateService articleCommentList:self.articleDetailsModel.articleId type:0 page:page size:self.size success:^(id data) {
//        if(data){
//            CommentRootMdoel *dataModel = [MTLJSONAdapter modelOfClass:CommentRootMdoel.class fromJSONDictionary:data error:nil];
//            if(dataModel && dataModel.items && dataModel.items.count>0){
//                self.page ++;
//                [self.commentModels addObjectsFromArray:dataModel.items];
//                [self computeHeightForComments];
//                [self.tableView reloadData];
//                [self.tableView.mj_footer endRefreshing];
//                if(self.commentModels.count >= self.rootModel.total){
//                    self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
//                }
//            }
//        }
//    } failure:^(NSError *error) {
//        [self.tableView.mj_footer endRefreshing];
//    }];
}

- (void)p_addCommentEmptyView {
    //todo
    _emptyCommentView = [UIView new];
    _emptyCommentView.frame = CGRectMake(0, 0, mScreenWidth, [SizeTool height:155.f]);
    
    UIImageView *emptyIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fire_error_comment"]];
    
    UILabel *tipLabel = [UILabel createLabelWithDefaultText:@"还没有人留言哦" numberOfLines:1 textColor:UIColor.fe_mainTextColor font:mFont(16)];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    
    [_emptyCommentView addSubview:emptyIconImageView];
    [emptyIconImageView addSubview:tipLabel];
    
    CGFloat emptyIconWidth = [SizeTool height:80];
    [emptyIconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_offset([SizeTool height:-20]);
        make.size.mas_equalTo(CGSizeMake(emptyIconWidth, emptyIconWidth));
    }];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emptyIconImageView.mas_bottom).mas_offset([SizeTool height:15]);
        make.centerX.mas_equalTo(0);
    }];
    
    self.tableView.tableFooterView = _emptyCommentView;
}

- (CGFloat)heightForCommentCellAtIndexPath:(NSIndexPath *)indexPath {
//    CommentModel *model = self.commentModels[indexPath.row];
//    return [_tableView fd_heightForCellWithIdentifier:@"TCCommentTableViewCell" cacheByKey:model.cacheUniqueKey configuration:^(TCCommentTableViewCell *cell) {
//        cell.model = model;
//    }];
    return 0;
    
}

#pragma mark -
#pragma mark - TableView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat percent = scrollView.contentOffset.y / mNavBarHeight;
    [self customTitleTransitionWithPercent:percent];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
//    return self.commentModels?self.commentModels.count:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(![self.articleDetailsModel.showComment boolValue]){
        return [SizeTool height:78];
    } else {
//        if (self.commentModels.count == 0) {
//            return STWidth(10);
//        } else {
//            return STWidth(48);
//        }
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForCommentCellAtIndexPath:indexPath];;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    
    
    if ([_articleDetailsModel.showComment boolValue] == YES) {
        view.backgroundColor = UIColor.fe_backgroundColor;
//        if (_commentModels.count != 0) {
//            TCTitleHeaderView *titleView = TCTitleHeaderView.new;
//            titleView.titleLabel.text = @"精选留言";
//            titleView.insets = STEdgeInsets(10, 15, 0, 0);
//            [view addSubview:titleView];
//            [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.offset(STWidth(10));
//                make.left.right.bottom.offset(0);
//            }];
//        }
    } else {
        view.backgroundColor = UIColor.fe_contentBackgroundColor;
        
        UIView *separatorView = [UIView new];
        separatorView.backgroundColor =  UIColor.fe_backgroundColor;
        [view addSubview:separatorView];
        [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(STSize(375, 15));
            make.top.left.mas_equalTo(0);
        }];
       [UILabel create:^(UILabel *label) {
            label.textIs(@"当前文章已关闭评论功能")
            .textColorIs(UIColor.fe_auxiliaryTextColor)
            .textAlignmentIs(NSTextAlignmentCenter)
            .fontIs(STFont(14));
           
           [label mas_makeConstraints:^(MASConstraintMaker *make) {
               make.centerX.mas_equalTo(0);
               make.centerY.offset([SizeTool height:7.5]);
           }];
        } addTo:view];
    }
    
    return view;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    return  footerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TCCommentTableViewCell class]) forIndexPath:indexPath];
//     CommentModel *aComment = self.commentModels[indexPath.row];
//    cell.model = aComment;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end










@implementation UIViewController (RotationControl)
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end


@implementation UITabBarController (RotationControl)
- (UIViewController *)sj_topViewController {
    if ( self.selectedIndex == NSNotFound )
        return self.viewControllers.firstObject;
    return self.selectedViewController;
}

- (BOOL)shouldAutorotate {
    return [[self sj_topViewController] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [[self sj_topViewController] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self sj_topViewController] preferredInterfaceOrientationForPresentation];
}
@end

@implementation UINavigationController (RotationControl)
- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

- (nullable UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (nullable UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}
@end
