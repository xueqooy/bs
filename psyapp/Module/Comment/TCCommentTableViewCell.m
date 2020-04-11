//
//  TCCommentTableViewCell.m
//  smartapp
//
//  Created by mac on 2019/7/26.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "TCCommentTableViewCell.h"
#import "TCCommentCellHelper.h"
#import "NSDate+Utils.h"
#import "UITableView+TCCommentAuthority.h"

@interface TCSubCommentView : UIView
@property (nonatomic, weak) CommentModel *model;

@property (nonatomic, weak) TCCommentCellHelper *helper;
@end

@implementation TCSubCommentView {
    UIView *_container;
    UILabel *_contentLabel;
    
    QMUIButton *_moreButton;
    
    MASConstraint *_buttonTopContraint;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = UIColor.fe_backgroundColor;
    [self setupSubviews];
    return self;
}

- (void)setupSubviews {
    _container = UIView.new;

    _contentLabel = [UILabel createLabelWithDefaultText:@"" numberOfLines:0 textColor:UIColor.fe_mainTextColor font:STFontRegular(14)];
    
    _moreButton = QMUIButton.new;
    [_moreButton setTitleColor:mHexColor(@"#3E8CF7") forState:UIControlStateNormal];
    _moreButton.titleLabel.font = STFontRegular(12);
    [_moreButton addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_container];
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.mas_equalTo(UIEdgeInsetsMake(STWidth(10), STWidth(15), STWidth(10), STWidth(15)));
    }];
    
    [_container addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
    }];
    
    [_container addSubview:_moreButton];
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        _buttonTopContraint = make.top.equalTo(_contentLabel.mas_bottom).offset(STWidth(10));
        make.left.bottom.offset(0);
    }];
}

- (void)setModel:(CommentModel *)model {
    if (model == nil ) return;
    _model = model;
     CommentModel *subCommentModel = model.firstSubComment;
    if (subCommentModel == nil) return;
    
    if (model.subCommentNum && model.subCommentNum.integerValue > 1) {
        _moreButton.hidden = NO;
        _buttonTopContraint.offset(STWidth(10));
        [_moreButton setTitle:[NSString stringWithFormat:@"全部%li条回复", (long)model.subCommentNum.integerValue] forState:UIControlStateNormal];
    } else {
        _moreButton.hidden = YES;
        _buttonTopContraint.offset(0);
    }
    
    NSMutableString *contentText = @"".mutableCopy;
    NSString *nickname = subCommentModel.user.nickname? subCommentModel.user.nickname:@" ";
    NSString *content = subCommentModel.commentInfo? subCommentModel.commentInfo : @" ";
    [contentText appendFormat:@"%@：",nickname];
    [contentText appendString:content];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:STWidth(7)];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingMiddle];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentText];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentText length])];
    [attributedString addAttribute:NSFontAttributeName value:STFontBold(14) range:NSMakeRange(0, nickname.length)];
    _contentLabel.attributedText = attributedString;
    
    [self layoutIfNeeded];
}

- (void)moreAction {
    @weakObj(self);
    [_helper moreWithRepliedBlock:^{
        [selfweak addRepliedCommentCount];
    }];
}

- (void)addRepliedCommentCount {
    NSInteger currentCount = _model.subCommentNum? _model.subCommentNum.integerValue : 0;
    _model.subCommentNum = @(currentCount + 1);
    [_moreButton setTitle:[NSString stringWithFormat:@"全部%li条回复", (long)_model.subCommentNum.integerValue] forState:UIControlStateNormal];
}
@end

@implementation TCCommentTableViewCell
{
    UIView *_container;
    TCSubCommentView *_subCommentView;
    UIImageView *_avatarImageView;
    UILabel *_nicknameLabel;
    UILabel *_dateLabel;
    UILabel *_contentLabel;
    QMUIButton *_thumbUpButton;
    UIView  *_separator;
    UILabel *_periodLabel;
    
    MASConstraint *_bottomConstrant;
    BOOL _thumbUpLocked;
    TCCommentCellHelper *_helper;
    
    
    UITapGestureRecognizer *_replyTapRecognizer;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.contentView.backgroundColor = UIColor.fe_contentBackgroundColor;
    _canCancelThumpUp = YES;
    _helper = [[TCCommentCellHelper alloc] initWithCell:self];
    [self setUpSubviews];
    return self;
}

- (void)setReplyDisabled:(BOOL)replyDisabled {
    _replyTapRecognizer.enabled = !replyDisabled;
}

- (void)setUpSubviews {
    
    _container = UIView.new;
    
    _avatarImageView = [UIImageView new];
    _avatarImageView.layer.cornerRadius = STWidth(18);
    _avatarImageView.layer.masksToBounds = YES;
    [_avatarImageView setImage:[UIImage imageNamed:@"default_header_boy"]];
    
    _nicknameLabel = [UILabel createLabelWithDefaultText:@"" numberOfLines:1 textColor:UIColor.fe_titleTextColorLighten font:STFontBold(12)];
    
    _periodLabel = [UILabel createLabelWithDefaultText:@"" numberOfLines:1 textColor:UIColor.fe_placeholderColor font:STFontRegular(12)];
    
    _dateLabel = [UILabel createLabelWithDefaultText:@"" numberOfLines:1 textColor:UIColor.fe_placeholderColor font:STFontRegular(10)];
    
    _contentLabel = [UILabel createLabelWithDefaultText:@"" numberOfLines:0 textColor:UIColor.fe_titleTextColorLighten font:STFontRegular(16)];
    _contentLabel.userInteractionEnabled = YES;
    _replyTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyAction)];
    [_contentLabel addGestureRecognizer:_replyTapRecognizer];
    
    _thumbUpButton = QMUIButton.new;
    _thumbUpButton.imagePosition = QMUIButtonImagePositionLeft;
    _thumbUpButton.spacingBetweenImageAndTitle = STWidth(5);
    _thumbUpButton.titleLabel.font = STFontRegular(12);
    [self setThumbUpButtonActive:NO];
    [_thumbUpButton addTarget:self action:@selector(thumbUpAction) forControlEvents:UIControlEventTouchUpInside];
    
    _separator = [UIView new];
    _separator.backgroundColor = UIColor.fe_separatorColor;
    
    [self.contentView addSubview:_container];
    [_container addSubview:_avatarImageView];
    [_container addSubview:_nicknameLabel];
    [_container addSubview:_periodLabel];
    [_container addSubview:_dateLabel];
    [_container addSubview:_contentLabel];
    [_container addSubview:_thumbUpButton];
    [self.contentView addSubview:_separator];
    
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(STWidth(10), STWidth(15), STWidth(10), STWidth(15)));
    }];
    
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(STSize(36, 36));
        make.left.top.offset(0);
    }];
    
    CGFloat marginLeft = STWidth(45);
    [_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(marginLeft);
        make.top.offset(0);
    }];
    
    [_periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nicknameLabel.mas_right).offset(STWidth(5));
        make.centerY.equalTo(_nicknameLabel);
        make.right.offset(0).priorityLow();
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_avatarImageView);
        make.left.offset(marginLeft);;
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(STWidth(46));
        make.left.offset(marginLeft);
        make.right.offset(0);
        make.bottom.offset(0).priorityMedium();
    }];
    
    [_thumbUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.offset(0);
        make.height.mas_equalTo(STWidth(18));
    }];
    
    [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.offset(marginLeft);;
        make.height.mas_equalTo(STWidth(0.5));
        make.right.offset(STWidth(-15));
    }];
}

//- (CGSize)sizeThatFits:(CGSize)size {
//    CGSize resultSize = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    return resultSize;
//}

- (void)setSeparatorHidden:(BOOL)separatorHidden {
    if (_separatorHidden == separatorHidden) return;
    _separatorHidden = separatorHidden;
    _separator.hidden = _separatorHidden;
}

- (void)setModel:(CommentModel *)model  {
    _model = model;
    
    _nicknameLabel.text = model.user.nickname ;
    _periodLabel.text = [NSString stringWithFormat:@"(%@)", model.user.gradeName];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:model.createTime];
    _dateLabel.text = date.formattedDateDescription;

    NSString *content = model.commentInfo;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:STWidth(7)];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingMiddle];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    [attributedString addAttribute:NSFontAttributeName value:STFontRegular(16) range:NSMakeRange(0, content.length)];
    _contentLabel.attributedText = attributedString;
    
    [_avatarImageView sd_setImageWithURL: [NSURL URLWithString:model.user.avatar.url] placeholderImage:[UIImage imageNamed:@"default_header_boy"]];
    
    NSString *thumbUpCountString = model.thumbUpNum? ([model.thumbUpNum isEqualToNumber:@0]? @"赞":  model.thumbUpNum.stringValue) : nil;
    [_thumbUpButton setTitle:thumbUpCountString forState:UIControlStateNormal];
    [self setThumbUpButtonActive:model.alreadyThumbUp];
    [_thumbUpButton layoutIfNeeded];
    
    if (_subCommentView) {
        [_subCommentView removeFromSuperview];
    }
    
    UITableView *tableView = self.qmui_tableView;
    if (tableView.tc_commentDisabled) {
        return;
    }
    
    if (model.firstSubComment && model.subCommentNum.integerValue > 0 && !_prefersReplyHidden) {
        _subCommentView = TCSubCommentView.new;
        _subCommentView.helper = _helper;
        _subCommentView.model = model;
        [_container addSubview:_subCommentView];
        [_subCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(STWidth(45));
            make.top.equalTo(_contentLabel.mas_bottom).offset(STWidth(10));
            make.right.offset(0);
            make.bottom.offset(0).priorityHigh();
        }];
    }
    
}


- (void)setThumbUpButtonActive:(BOOL)active {
    UIImage *thumbUpImage = [UIImage imageNamed:active? @"thumb_up_active": @"thumb_up"];
    UIColor *titleColor = active? UIColor.fe_mainColor : UIColor.fe_unselectedTextColor;
    [_thumbUpButton setImage:thumbUpImage forState:UIControlStateNormal];
    [_thumbUpButton setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)replyAction {
    [_helper reply];
}

- (void)thumbUpAction {
    NSString *numString;
    
    if (self.model.alreadyThumbUp == NO) {
        [TCSystemFeedbackHelper impactLight];
        if (_model.thumbUpNum) {
            numString = @(_model.thumbUpNum.integerValue + 1).stringValue;
        } else {
            numString = @"1";
        }
        [self setThumbUpButtonActive:!self.model.alreadyThumbUp];
    } else {
        if (_canCancelThumpUp) {
            if (_model.thumbUpNum && _model.thumbUpNum.integerValue > 0) {
                if (_model.thumbUpNum.integerValue - 1 > 0) {
                    numString = @(_model.thumbUpNum.integerValue - 1).stringValue;
                }
            }
            [self setThumbUpButtonActive:!self.model.alreadyThumbUp];
        } else {
            return;
        }
    }
    
    _model.alreadyThumbUp = !self.model.alreadyThumbUp;
    _model.thumbUpNum = numString? @(numString.integerValue) : nil;
    [_thumbUpButton setTitle:numString? numString : @"赞" forState:UIControlStateNormal];
    [_thumbUpButton layoutIfNeeded];
    
    [_helper thumbUp:self.model completion:^(BOOL success) {
        
    }];
}
@end



