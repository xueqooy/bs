//
//  FEDiscussViewController.m
//  smartapp
//
//  Created by mac on 2019/12/26.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FECommentViewController.h"
#import "TCCommentTableViewCell.h"
#import "FECommentView.h"
#import "UITableView+TCCommentAuthority.h"
#import "UITableView+FDTemplateLayoutCell.h"
@interface FECommentViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FECommentView *commentView;
@property (nonatomic, strong) FECommentManager *dataManager;

@property (nonatomic, strong) UIView *replyEmptyViewContainer;
@end

const CGFloat kCommentBoxHeight = 49;


@implementation FECommentViewController {
    BOOL subcommentType;
}

- (instancetype)initWithContentId:(NSString *)contentId type:(FECommentType)type{
    self = [super init];
    self.contentId = contentId;
    self.type = type;
    return self;
}

- (instancetype)initWithCommentModel:(CommentModel *)commentModel {
    self = [super init];
    self.commentModel = commentModel;
    return self;
}

- (void)reloadData {
    [self.dataManager resetData];
    [self loadData];
}

- (void)setContentId:(NSString *)contentId {
    if ([_contentId isEqualToString:contentId]) return;
    _contentId = contentId;
    self.dataManager.contentId = contentId;

}

- (void)setType:(FECommentType)type {
    _type = type;
    self.dataManager.type = _type;
}

- (void)setCommentModel:(CommentModel *)commentModel {
    _commentModel = commentModel;
    _type = FECommentTypeReply;
    _contentId = _commentModel.commentId;
    self.dataManager.contentId = _contentId;
    self.dataManager.type = _type;
    
    [self updateCommentPlaceholder];
}

- (void)updateCommentPlaceholder {
    if (_commentView) {
        if (_type == FECommentTypeReply) {
            NSString *nickname = _commentModel.userData.nickname? _commentModel.userData.nickname : @" ";
            _commentView.placeholder = [NSString stringWithFormat:@"回复 %@", nickname];
        } else {
            _commentView.placeholder = @"写评论";
        }
        
    }
}

- (void)setCommentDisabled:(BOOL)commentDisabled {
    if (_commentDisabled == commentDisabled) return;
    _commentDisabled = commentDisabled;
    if (_commentDisabled) {
        if (_commentView) {
            [_commentView removeFromSuperview];
        }
    } else {
        [self addCommentView];
    }
    
    
    if (_tableView) {
        _tableView.tc_commentDisabled = _commentDisabled;
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (_commentDisabled) {
                make.bottom.offset(0);
            } else {
                make.bottom.offset(-STWidth(kCommentBoxHeight) - mBottomSafeHeight);
            }
        }];
    }
}

- (void)loadView {
    [super loadView];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.contentInset = UIEdgeInsetsMake(STWidth(10), 0, 0, 0);
    _tableView.backgroundColor = UIColor.fe_contentBackgroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.allowsSelection = NO;
    _tableView.tc_commentDisabled = _commentDisabled;
    _tableView.tableHeaderView = ({
        UIView *view = UIView.new;
        view.frame = CGRectMake(0, 0, mScreenWidth, CGFLOAT_MIN);
        view;
    });
    [_tableView registerClass:TCCommentTableViewCell.class forCellReuseIdentifier:@"TCCommentTableViewCell"];
    [_tableView addFooterRefreshTarget:self action:@selector(loadData)];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        if (_commentDisabled) {
            make.bottom.offset(0);
        } else {
            make.bottom.offset(-STWidth(kCommentBoxHeight) - mBottomSafeHeight);
        }
    }];
    
    if (_commentDisabled) return;
    [self addCommentView];
}

- (void)addCommentView {
    _commentView = [FECommentView createCommentViewWithComponent:FECommentViewComponentNone];
    [self updateCommentPlaceholder];
    @weakObj(self);
    _commentView.commentSendHandler = ^(NSString * _Nonnull comment) {
        @strongObj(self);
        [self.dataManager commitComment:comment completion:^(BOOL success, CommentModel *model) {
            if (success) {
                [QSToast toast:mKeyWindow message:@"评论成功"];
                if (selfweak.repliedBlock) selfweak.repliedBlock();
                [selfweak.dataManager resetData];
                [selfweak loadData];
            }
        }];
    };

    [self.view addSubview:_commentView];
    [_commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(mScreenWidth, STWidth(kCommentBoxHeight)));
        make.bottom.equalTo(self.view).offset(-mBottomSafeHeight);
        make.centerX.mas_equalTo(0);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([NSString isEmptyString:self.title]) {
        self.title = @"评论详情";
    }
    self.view.backgroundColor = UIColor.fe_contentBackgroundColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];

}

- (FECommentManager *)dataManager {
    if (_dataManager == nil) {
        _dataManager = [[FECommentManager alloc] initWithContentId:_contentId type:_type];
    }
    return _dataManager;
}

- (UIView *)replyEmptyViewContainer {
    if (_replyEmptyViewContainer) {
        _replyEmptyViewContainer = UIView.new;
    }
    return _replyEmptyViewContainer;
}

- (void)loadData {
    @weakObj(self);
    [_dataManager loadCommentDataWithSuccess:^{
        GCD_ASYNC_MAIN(^{
            @strongObj(self);
            [self.tableView reloadData];
            if (self.dataManager.hasLoadAll) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                self.tableView.mj_footer.hidden = NO;
                [self.tableView.mj_footer endRefreshing];
            }
            
            [self setEmptyViewHidden:!self.dataManager.isEmpty];
            
            if (self.commentCountChangedHandler) {
                self.commentCountChangedHandler(self.dataManager.commentRootModel.total);
            }
        });
    } failure:nil];
}

- (void)setEmptyViewHidden:(BOOL)hidden {
    if (hidden) {
        [self hideEmptyView];
    } else {
        UIView *superView = _type == FECommentTypeReply? self.replyEmptyViewContainer : _tableView;
        [self showEmptyViewInView:superView type:FEErrorType_NoComment];
        self.emptyView.titleLabel.text = _type == FECommentTypeReply? @"还没有人回复哦" : @"还没有人留言哦";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.emptyView updateLayoutWithInsets:UIEdgeInsetsZero];
        });
    }
}

- (CGFloat)heightForCommentCellAtIndexPath:(NSIndexPath *)indexPath {
    CommentModel *commentModel;
    if (indexPath.section == 0) {
        commentModel = _commentModel;
    } else {
        commentModel = self.dataManager.commentModels[indexPath.row];
    }
    if (commentModel == nil) return 0;
    return [_tableView fd_heightForCellWithIdentifier:@"TCCommentTableViewCell" cacheByKey:commentModel.cacheUniqueKey configuration:^(TCCommentTableViewCell *cell) {
        cell.replyDisabled = _type == FECommentTypeReply;
        cell.prefersReplyHidden = _type == FECommentTypeReply;
        cell.model = commentModel;
    }];
}
#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (_type == FECommentTypeReply) {
            return 1;
        } else {
            return 0;
        }
    } else {
       return _dataManager.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForCommentCellAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommentTableViewCell" forIndexPath:indexPath];
    cell.separatorHidden = indexPath.section == 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentModel *commentModel;
    if (indexPath.section == 0) {
        commentModel = _commentModel;
    } else {
        commentModel = self.dataManager.commentModels[indexPath.row];
    }
    if (commentModel == nil) return;
    TCCommentTableViewCell *_cell = (TCCommentTableViewCell *)cell;
    _cell.replyDisabled = _type == FECommentTypeReply;
    _cell.prefersReplyHidden = _type == FECommentTypeReply;
    _cell.model = commentModel;
    
    @weakObj(self);
    if (_type == FECommentTypeReply) {
        _cell.replySuccessBlock = ^{
            [selfweak.dataManager resetData];
            [selfweak loadData];
        };
    } else {
        _cell.replySuccessBlock = nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0 && _type == FECommentTypeReply) {
        UIView *view = UIView.new;
        UIView *separator = UIView.new;
        separator.frame = CGRectMake(0, STWidth(10), mScreenWidth, STWidth(10));
        separator.backgroundColor = UIColor.fe_backgroundColor;
        [view addSubview:separator];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 && _type == FECommentTypeReply) {
        return STWidth(20);
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1 && _type == FECommentTypeReply) {
        if (_dataManager.isEmpty) {
            return self.replyEmptyViewContainer;
        } else {
            UIView *view = UIView.new;
            UILabel *label = [UILabel.alloc qmui_initWithFont:STFontBold(20) textColor:UIColor.fe_titleTextColorLighten];
            label.frame = CGRectMake(STWidth(15), STWidth(10), 0, 0);
            label.text = @"全部回复";
            [label sizeToFit];
            [view addSubview:label];
            return view;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1 && _type == FECommentTypeReply) {
        if (_dataManager.isEmpty) {
            return STWidth(400);
        } else {
            return STWidth(38);
        }
    }
    return 0;
}
@end
