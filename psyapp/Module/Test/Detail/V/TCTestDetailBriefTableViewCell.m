//
//  TCTestDetailBriefTableViewCell.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/1.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCTestDetailBriefTableViewCell.h"
#import "TCTestTitleLabelView.h"
@implementation TCTestDetailBriefTableViewCell {
    UILabel *_briefLabel;
    TCTestTitleLabelView *_suitLabelView;
    TCTestTitleLabelView *_gainLabelView;
    TCTestTitleLabelView *_noticeLabelView;
    MASConstraint *_bottomConstraint;
    
    __weak UIView *_lastView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setupSubviews];
    return self;
}

- (void)setupSubviews {
    _briefLabel = [[UILabel alloc] init];
    _briefLabel.textColor =  UIColor.fe_mainTextColor;
    _briefLabel.font = STFontRegular(14);
    _briefLabel.numberOfLines = 0;
    [self.contentView addSubview:_briefLabel];
    [_briefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(STWidth(2));
        make.left.offset([SizeTool width:15]);
        make.right.offset(-[SizeTool width:15]);
        make.width.mas_equalTo(STWidth(350)).priority(999);
        _bottomConstraint = make.bottom.offset(STWidth(-10));
    }];
    _lastView = _briefLabel;
}

- (void)setBriefText:(NSString *)briefText {
    _briefText = briefText;
    [_briefLabel setHtmlText:briefText lineSpacing:STWidth(7)];
    
}

- (void)setSuitText:(NSString *)suitText {
    if (suitText == nil) return;
    _suitText = suitText;
    self.suitLabelView.mainText = _suitText;
}

- (void)setGainText:(NSString *)gainText {
    if (gainText == nil) return;

    _gainText = gainText;
    self.gainLabelView.mainText = _gainText;
}

- (void)setNoticeText:(NSString *)noticeText {
    if (noticeText == nil) return;
    _noticeText = noticeText;
    self.noticeLabelView.mainText = _noticeText;
}

- (TCTestTitleLabelView *)suitLabelView {
    if (_suitLabelView) return _suitLabelView;
    _suitLabelView = TCTestTitleLabelView.new;
    _suitLabelView.titleText = @"适合谁测";
    [self.contentView addSubview:_suitLabelView];
    [_suitLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lastView.mas_bottom).offset(STWidth(10));
        make.left.offset(STWidth(15));
        make.right.offset(STWidth(-15));
        [_bottomConstraint uninstall];
        _bottomConstraint = make.bottom.offset(STWidth(-10));
    }];
    _lastView = _suitLabelView;
    return _suitLabelView;
}

- (TCTestTitleLabelView *)gainLabelView {
    if (_gainLabelView) return _gainLabelView;
    _gainLabelView = TCTestTitleLabelView.new;
    _gainLabelView.titleText = @"你将获得";
    [self.contentView addSubview:_gainLabelView];
    [_gainLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lastView.mas_bottom).offset(STWidth(10));
        make.left.offset(STWidth(15));
        make.right.offset(STWidth(-15));
        [_bottomConstraint uninstall];
        _bottomConstraint = make.bottom.offset(STWidth(-10));
    }];
    _lastView = _gainLabelView;
    return _gainLabelView;
}

- (TCTestTitleLabelView *)noticeLabelView {
    if (_noticeLabelView) return _noticeLabelView;
    _noticeLabelView = TCTestTitleLabelView.new;
    _noticeLabelView.titleText = @"测评须知";
    [self.contentView addSubview:_noticeLabelView];
    [_noticeLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lastView.mas_bottom).offset(STWidth(10));
        make.left.offset(STWidth(15));
        make.right.offset(STWidth(-15));
        [_bottomConstraint uninstall];
        _bottomConstraint = make.bottom.offset(STWidth(-10));
    }];
    _lastView = _noticeLabelView;
    return _noticeLabelView;
}
@end
