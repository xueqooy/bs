//
//  ArticleDetailViewController.m
//  smartapp
//
//  Created by 剑辉  薛 on 2019/7/2.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "EvaluateService.h"
#import "articleModel.h"
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

#import "FECommentManager.h"
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
@property(nonatomic,strong) FECommentManager *commentManager;

@property(nonatomic, strong) NSMutableArray *commentsHeightArray;


@property(nonatomic,assign) CGFloat bottomHeight;

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
  
    _bottomHeight = [SizeTool height:49];
    
    _webViewManager = [FEWebViewManager new];
    _commentManager = [[FECommentManager alloc] initWithContentId:self.articleModel.articleId type:FECommentTypeArticle];
    [self configWebViewManager];
    
    //从其他tab跳转时无法传入articleModel， 视图创建延迟到数据请求之后
    [self setupView];
    [self updateView];
    [self showLoadingView];
    [self setNavigationBarShadowHidden:YES];
    self.customTitleLabel = self.defaultCustomTitleLabel;
    self.customTitleLabel.text = self.articleModel.articleTitle;
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
        
    
    [self.tableView addFooterRefreshTarget:self action:@selector(loadCommentData)];
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
    self.publishTimeLabel.textColor = UIColor.fe_placeholderColor;
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
    [self loadCommentData];
}

//- (void)uploadToCloud:(articleModel *)article {
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

-(void)updateView{

    self.titleLabel.text = _articleModel.articleTitle;
    self.customTitleLabel.text = self.articleModel.articleTitle;
    
    [self loadCommentData];
    
    NSInteger countHeight = 0;
        
    [self updateSupport];
    [self updateCollect];
    
    if(!self.articleModel){
        self.titleLabel.text = _articleModel.articleTitle;
    }
    
    self.sourceNameLabel.text = _articleModel.sourceName;
    self.publishTimeLabel.text = _articleModel.publishDate;
    self.readCountLabel.text = [NSString stringWithFormat:@"%@",_articleModel.pageView];
    

    if(![NSString isEmptyString:_articleModel.articleVideo]){//视频
        [self addVideoObservation];
    } else {
        self.playImage.hidden = YES;
    }
    
//    //加载webView
//    NSString *articleContentString = articleModel.articleContent;
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
        [TCArticleLoader loadArticle:selfweak.articleModel onWebView:selfweak.webViewManager.webView WithCompletion:^(BOOL success) {
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
    @weakObj(self);
    [self.commentManager commitComment:text completion:^(BOOL success, CommentModel * _Nullable model) {
        if (success) {
            [QSToast toast:selfweak.view message:@"评论成功"];
            [selfweak.commentManager resetData];
            [selfweak loadCommentData];
        }
    }];
    
}


-(void)setCommentCount:(NSInteger)newsNum{
    [_commentView setCount:newsNum forComponent:FECommentViewComponentDiscuss];
}



-(void)updateCollect{
    if([self.articleModel.favorite integerValue] == 1){
        [_commentView setSelected:YES forComponent:FECommentViewComponentCollect];
    }else{
        [_commentView setSelected:NO forComponent:FECommentViewComponentCollect];
    }
    
}

-(void)updateSupport{
    NSArray *thumpUpUsers = self.articleModel.thumpUpUsers;
    BOOL alreadyThumpUp = NO;
    for (BSUser *user in thumpUpUsers) {
        if ([user.objectId isEqualToString:BSUser.currentUser.objectId]) {
            alreadyThumpUp = YES;
            self.articleModel.alreadyThumpUp = YES;
            break;
        }
    }
    [_commentView setSelected:alreadyThumpUp forComponent:FECommentViewComponentLike];
    [_commentView setCount:self.articleModel.thumpUpNum.intValue forComponent:FECommentViewComponentLike];
}

- (void)scrollToComment {
    if(self.commentManager.isEmpty == NO){
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [[self tableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else{
        if(self.tableView.contentSize.height>self.tableView.frame.size.height) {

            CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
            [self.tableView setContentOffset:offset animated:YES];

        }
    }
}

- (void)like {
    //点赞
    if ([UCManager showLoginAlertIfVisitorPatternWithMessage:@"登录后可进行点赞，确定去登录吗？"]) {
        return;
    }
    
    if(self.articleModel.alreadyThumpUp){
        self.articleModel.alreadyThumpUp = NO;
        self.articleModel.thumpUpNum = @([self.articleModel.thumpUpNum integerValue] - 1);

    }else{
        self.articleModel.alreadyThumpUp = YES;
        self.articleModel.thumpUpNum = @([self.articleModel.thumpUpNum integerValue] + 1);
    }
//    [_commentView setSelected:self.articleModel.alreadyThumpUp forComponent:FECommentViewComponentLike]; //automaticlly
    [_commentView setCount:self.articleModel.thumpUpNum.intValue forComponent:FECommentViewComponentLike];
    
    AVObject *object = [AVObject objectWithClassName:@"Article" objectId:self.articleModel.articleId];
    [object fetchInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        NSMutableArray <BSUser *>*users = [object objectForKey:@"thumpUpUsers"];
        if (users == nil) users = @[].mutableCopy;
        if (self.articleModel.alreadyThumpUp == NO) {
            for (BSUser *user in users) {
                if([user.objectId isEqualToString:BSUser.currentUser.objectId]) {
                    [users removeObject:user];
                    break;
                }
            }
            [object setObject:users forKey:@"thumpUpUsers"];
            [object incrementKey:@"thumpUp" byAmount:@(-1)];
            [object saveInBackground];
        } else {
            for (BSUser *user in users) {
                if([user.objectId isEqualToString:BSUser.currentUser.objectId]) {
                    return;
                }
            }
            [users addObject:BSUser.currentUser];
            [object setObject:users forKey:@"thumpUpUsers"];
            [object incrementKey:@"thumpUp"];
            [object saveInBackground];
        }
        self.articleModel.thumpUpUsers = users;

    }];
 
}

- (void)collect {
    //收藏
    if ([UCManager showLoginAlertIfVisitorPatternWithMessage:@"登录后可进行收藏，确定去登录吗？"]) {
        return;
    }
  
    [EvaluateService articleCollect:self.articleModel.articleId success:^(id data) {
        
        if([data[@"is_favorite"] boolValue]){
            self.articleModel.favorite = @1;
            self.articleModel.pageFavorite = @([self.articleModel.pageFavorite integerValue] + 1);
            [QSToast toast:self.view message:@"收藏成功"];
        }else{
            self.articleModel.favorite = @0;
            self.articleModel.pageFavorite = @([self.articleModel.pageFavorite integerValue] - 1);
            [QSToast toast:self.view message:@"取消收藏"];
        }
        
        
        [self updateCollect];
    } failure:^(NSError *error) {
        [HttpErrorManager showErorInfo:error showView:self.view];
        [self updateCollect];

    }];
}


-(void)loadCommentData{
    @weakObj(self);
    [_commentManager loadCommentDataWithSuccess:^{
        selfweak.tableView.alreadyLoadAllData = selfweak.commentManager.hasLoadAll;
        if (selfweak.commentManager.isEmpty == NO) {
            selfweak.tableView.tableFooterView = UIView.new;
            [UIView performWithoutAnimation:^{
                [selfweak.commentView setCount:selfweak.commentManager.count forComponent:FECommentViewComponentDiscuss];
                [selfweak.tableView reloadData];
            }];
        } else {
            [selfweak p_addCommentEmptyView];
        }
    } failure:^{
        [selfweak.tableView.mj_footer endRefreshing];
    }];
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
    CommentModel *model = self.commentManager.commentModels[indexPath.row];
    return [_tableView fd_heightForCellWithIdentifier:@"TCCommentTableViewCell" cacheByKey:model.cacheUniqueKey configuration:^(TCCommentTableViewCell *cell) {
        cell.model = model;
    }];
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
    return self.commentManager.commentModels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.commentManager.isEmpty == YES) {
        return STWidth(10);
    } else {
        return STWidth(48);
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForCommentCellAtIndexPath:indexPath];;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    
    
    view.backgroundColor = UIColor.fe_backgroundColor;
    if (self.commentManager.isEmpty == NO) {
        TCTitleHeaderView *titleView = TCTitleHeaderView.new;
        titleView.titleLabel.text = @"同学的留言";
        titleView.insets = STEdgeInsets(10, 15, 0, 0);
        [view addSubview:titleView];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(STWidth(10));
            make.left.right.bottom.offset(0);
        }];
    }
    return view;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    return  footerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TCCommentTableViewCell class]) forIndexPath:indexPath];
     CommentModel *aComment = self.commentManager.commentModels[indexPath.row];
    cell.model = aComment;

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
