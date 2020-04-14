//
//  BSLibCell.m
//  psyapp
//
//  Created by mac on 2020/4/14.
//  Copyright © 2020 cheersmind. All rights reserved.
//

#import "BSLibCell.h"
#import "TCFilterCollectionCell.h"
@implementation BSLibCell  {
    UIImageView *_iconImageView;
    UILabel *_nameLabel;
    UILabel *_updatedAtLabel;
    UILabel *_includedLabel;
    QMUIButton *_tagDescLabel;
    UICollectionView *_tagCollectionView;
    NSMutableIndexSet *_selectedIndexSet;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _cellType = BSLibCellTypeUniversity;
    self.layer.shadowColor = UIColor.blackColor.CGColor;
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.backgroundColor = UIColor.fe_contentBackgroundColor;
    self.layer.cornerRadius = STWidth(8);
    _selectedIndexSet = [NSMutableIndexSet indexSet];
    [self setupSubviews];
    return self;
}

- (void)setupSubviews {
    UIView *container = UIView.new;
    [self addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(STEdgeInsets(15, 15, 10, 15));
    }];
    
    [container addTapGestureWithBlock:^{
        if (self->_onTap){
            self->_onTap();
        }
    }];
    
    _iconImageView = UIImageView.new;
    _iconImageView.clipsToBounds = YES;
    _iconImageView.layer.cornerRadius = STWidth(4);
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [container addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(STSize(105, 90));
        make.top.left.offset(0);
    }];
    
    _nameLabel = [UILabel.alloc qmui_initWithFont:STFontBold(24) textColor:UIColor.fe_titleTextColorLighten];
    [container addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_iconImageView.mas_right).offset(STWidth(20));
        make.top.right.offset(0);
    }];
    
    _includedLabel = [UILabel.alloc qmui_initWithFont:STFontRegular(14) textColor:UIColor.fe_mainTextColor];
    [container addSubview:_includedLabel];
    [_includedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_nameLabel);
        make.centerY.equalTo(_iconImageView).offset(STWidth(5));
    }];
    
    _updatedAtLabel = [UILabel.alloc qmui_initWithFont:STFontRegular(12) textColor:UIColor.fe_placeholderColor];
    [container addSubview:_updatedAtLabel];
    [_updatedAtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_includedLabel);
        make.bottom.equalTo(_iconImageView);
    }];
    
    _tagDescLabel = [QMUIButton new];
    _tagDescLabel.titleLabel.font = STFontBold(12);
    _tagDescLabel.spacingBetweenImageAndTitle = STWidth(2);
    [_tagDescLabel setTitleColor:UIColor.fe_textColorHighlighted forState:UIControlStateNormal];
    [container addSubview:_tagDescLabel];
    [_tagDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.bottom.offset(-STWidth(7));
    }];
    
    UICollectionViewFlowLayout *flowLayout = UICollectionViewFlowLayout.new;
    flowLayout.minimumInteritemSpacing = STWidth(10);
    flowLayout.minimumLineSpacing = STWidth(15);
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _tagCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _tagCollectionView.backgroundColor = UIColor.fe_contentBackgroundColor;
    _tagCollectionView.dataSource = self;
    _tagCollectionView.delegate = self;
    
    _tagCollectionView.showsHorizontalScrollIndicator = NO;
    _tagCollectionView.showsVerticalScrollIndicator = NO;
    _tagCollectionView.bounces = NO;
    [_tagCollectionView registerClass:TCFilterCollectionCell.class forCellWithReuseIdentifier:@"TCFilterCollectionCell"];
    [container addSubview:_tagCollectionView];
    [_tagCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.offset(0);
        make.left.equalTo(_tagDescLabel.mas_right);
        make.height.mas_equalTo(STWidth(30));
    }];
}

- (void)setIconImageURL:(NSURL *)iconImageURL {
    _iconImageURL = iconImageURL;
    [_iconImageView sd_setImageWithURL:iconImageURL];
}

- (void)setName:(NSString *)name {
    _name = name;
    _nameLabel.text = _name;
}

- (void)setUpdateAt:(NSString *)updateAt {
    _updateAt = updateAt;
    _updatedAtLabel.text = [NSString stringWithFormat:@"更新于%@", updateAt];
}

- (void)setIncludedCount:(NSInteger)includedCount {
    _includedCount = includedCount;
    NSString *text;
    switch (_cellType) {
        case BSLibCellTypeUniversity:
            text = [NSString stringWithFormat:@"共收录全国%@所大学", @(_includedCount)];
            break;
        case BSLibCellTypeMajor:
            text = [NSString stringWithFormat:@"共收录%@个专业", @(_includedCount)];
            break;
        case BSLibCellTypeOccupation:
            text = [NSString stringWithFormat:@"共收录%@种职业", @(_includedCount)];
            break;
        default:
            break;
    }
    _includedLabel.text = text;
}

- (void)setHotTag:(BOOL)hotTag {
    _hotTag = hotTag;
    if (hotTag) {
        [_tagDescLabel setImage:[UIImage imageNamed:@"search_hot"] forState:UIControlStateNormal];
        [_tagDescLabel setTitle:@"热门  " forState:UIControlStateNormal];
    }
}

- (void)setTags:(NSArray<NSString *> *)tags {
    _tags = tags;
    [_tagCollectionView reloadData];
}
#pragma mark - collectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _tags.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TCFilterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TCFilterCollectionCell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    TCFilterCollectionCell *_cell = (TCFilterCollectionCell *)cell;
    NSString *tag = _tags[indexPath.row];
    _cell.title = tag;
    @weakObj(_cell);
    _cell.touchHandler = ^ {
        _cellweak.selected = YES;
        [self->_selectedIndexSet addIndex:indexPath.item];
        if (self.onTag) self.onTag(tag);
    };
    if ([_selectedIndexSet containsIndex:indexPath.item]) {
        _cell.selected = YES;
    } else {
        _cell.selected = NO;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *content = _tags[indexPath.item];
    //计算字体宽度
    CGRect itemFrame = [content boundingRectWithSize:CGSizeMake(0, STWidth(27)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : STFontRegular(12)} context:nil];
    CGFloat width = itemFrame.size.width + STWidth(20);
    
  
    return CGSizeMake(width, STWidth(27));
}
@end
