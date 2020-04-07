//
//  TCTestHistoryRecordView.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/7.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCTestHistoryRecordView.h"

@interface TCTestHistoryRecordCell :UITableViewCell
- (void)updateWithHistoryItem:(TCTestHistoryModel *)item;
@end

@interface TCTestHistoryRecordView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation TCTestHistoryRecordView
@synthesize height = _height;
@synthesize margins = _margins;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _tableView = [UITableView new];
    self.margins = UIEdgeInsetsMake(0, STWidth(15), 0, STWidth(15));
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = STWidth(48);
    
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    return self;
}

- (void)setHistoryRecord:(NSArray<TCTestHistoryModel *> *)historyRecord {
    if (historyRecord && historyRecord.count > 0) {
        _historyRecord = historyRecord;
        self.height = historyRecord.count * STWidth(48);
        [_tableView reloadData];
    } else {
        self.height = STWidth(10);
        [self showsEmptyView];
    }
}

- (void)showsEmptyView {
    UILabel *emptyLabel = [UILabel.alloc qmui_initWithFont:STFontRegular(14) textColor:UIColor.fe_placeholderColor];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.text = @"无历史测评记录，请先开始测评";
    [self addSubview:emptyLabel];
    [emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.equalTo(self).offset(-STWidth(20));
    }];
    
    QMUIButton *button = QMUIButton.new;
    [button setTitle:@"开始测评" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.fe_titleTextColorLighten forState:UIControlStateNormal];
    button.layer.cornerRadius = 2;
    button.layer.borderColor = UIColor.fe_separatorColor.CGColor;
    button.layer.borderWidth = 1;
    [button addTarget:self action:@selector(actionForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(STSize(100, 32));
        make.centerX.offset(0);
        make.centerY.equalTo(self).offset(STWidth(20));
    }];
}

- (void)actionForButton:(UIButton *)sender {
    if (_onStartTestButtonClick) _onStartTestButtonClick();
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _historyRecord.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCTestHistoryRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCTestHistoryRecordCell"];
    if (!cell) {
        cell = [[TCTestHistoryRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TCTestHistoryRecordCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_historyRecord == nil || _historyRecord.count == 0) return;
    TCTestHistoryModel *item = self.historyRecord[indexPath.row];
    TCTestHistoryRecordCell *_cell = (TCTestHistoryRecordCell *)cell;
    [_cell updateWithHistoryItem:item];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *childDimensionId = self.historyRecord[indexPath.row].childDimensionId;
    if (_onTap) _onTap(childDimensionId);
}
@end

@implementation TCTestHistoryRecordCell {
    UILabel *_dateLabel;
    UILabel *_resultLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _dateLabel = [UILabel.alloc qmui_initWithFont:STFontRegular(14) textColor:UIColor.fe_titleTextColorLighten];
    [self.contentView addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.offset(0);
    }];
    
    _resultLabel = [UILabel.alloc qmui_initWithFont:STFontRegular(12) textColor:UIColor.fe_safeColor];
    _resultLabel.layer.cornerRadius = STWidth(2);
    _resultLabel.layer.borderWidth = STWidth(1);
    _resultLabel.layer.borderColor = UIColor.fe_safeColor.CGColor;
    _resultLabel.backgroundColor = [UIColor.fe_safeColor colorWithAlphaComponent:0.05];
    [self.contentView addSubview:_resultLabel];
    [_resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.offset(STWidth(-16));
    }];
    
    UIImageView *arrowImageVIew = UIImageView.new;
    UIImage *arrowImage = [UIImage imageNamed:@"fire_common_right_next"];
    arrowImageVIew.image = arrowImage;
    [self.contentView addSubview:arrowImageVIew];
    [arrowImageVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.offset(0);
        make.size.mas_equalTo(STSize(11.5, 11.5));
    }];
    
    self.qmui_borderWidth = STWidth(0.5);
    self.qmui_borderColor = UIColor.fe_separatorColor;
    self.qmui_borderPosition = QMUIViewBorderPositionBottom;
    return self;
}

- (void)updateWithHistoryItem:(TCTestHistoryModel *)item {
    if (item == nil || [NSString isEmptyString:item.finishTime]) return;
    NSString *date = item.finishTime;
    if (item.finishTime.length > 9) {
        date = [date substringToIndex:10];
    }
    date = [date stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    _dateLabel.text = date;
    
    if ([NSString isEmptyString:item.result]) return;
    NSString *result = item.result;
    result = [result stringByReplacingOccurrencesOfString:@"#" withString:@"、"];
    _resultLabel.text = [NSString stringWithFormat:@"  %@  ", result];
    CGSize size = [_resultLabel sizeThatFits:CGSizeZero];
    [_resultLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width  > STWidth(245)? STWidth(245) : size.width);
    }];
    
    if (item.isBadTendency) {
        _resultLabel.textColor = item.isBadTendency.boolValue? UIColor.fe_warningColor : UIColor.fe_safeColor;
        _resultLabel.layer.borderColor = item.isBadTendency.boolValue? UIColor.fe_warningColor.CGColor : UIColor.fe_safeColor.CGColor;
        _resultLabel.backgroundColor = [item.isBadTendency.boolValue? UIColor.fe_warningColor : UIColor.fe_safeColor colorWithAlphaComponent:0.05];
    }
    
    
}

@end


