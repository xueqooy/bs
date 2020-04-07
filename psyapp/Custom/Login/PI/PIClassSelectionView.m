//
//  PIClassSelectionView.m
//  ClassSelection
//
//  Created by xueqooy on 2019/10/30.
//  Copyright © 2019年 cheers-genius. All rights reserved.
//

#import "PIClassSelectionView.h"
#import "PIClassSelectionViewCell.h"
#import "PICommonInfo.h"

@interface PIClassSelectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray <NSArray *>*classInfo;
@property (nonatomic, copy) NSArray *levelInfo;
@property (nonatomic, weak) PIClassSelectionViewCell *selectedCell;
@property (nonatomic, copy) NSString *selectedClassName;

@end

@implementation PIClassSelectionView
- (void)setUnselected {
    if (_selectedCell != nil) {
        [_selectedCell setState:NO];
        _selectedCell = nil;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self initData];
    [self setupSubviews];
    [self setEvent];
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:STWidth(16)];
}

- (void)setCorners:(UIRectCorner)corners
                   radius:(CGFloat)radius{
    
    UIBezierPath *round = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *shape = [[CAShapeLayer alloc]init];
    
    [shape setPath:round.CGPath];
    
    self.layer.mask = shape;
}

- (void)initData {
    _classInfo = @[@[PIMiddle10, PIMiddle11, PIMiddle12], @[PIMiddle7, PIMiddle8, PIMiddle9, PIMiddle4, PIMiddle5, PIMiddle6, PIMiddle1, PIMiddle2, PIMiddle3], @[PILittle1, PILittle2, PILittle3]];
    _levelInfo = @[@"高中阶段", @"义务教育阶段", @"学前阶段"];
}

- (void)setupSubviews {
    self.backgroundColor = UIColor.fe_contentBackgroundColor;
        
    UIView *container = [UIView new];
    container.backgroundColor = UIColor.fe_contentBackgroundColor;
    [self addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(STWidth(15), STWidth(15), STWidth(15), STWidth(15)));
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.minimumLineSpacing = STWidth(20);
    flowLayout.minimumInteritemSpacing = STWidth(22);
    flowLayout.itemSize = CGSizeMake(STWidth(100), STWidth(40));
    flowLayout.estimatedItemSize = CGSizeMake(0, 0);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = UIColor.fe_contentBackgroundColor;
    collectionView.allowsSelection = NO;
    collectionView.bounces = NO;
    [container addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    _collectionView = collectionView;
}

- (void)setEvent {
    
   [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"classselectionheader"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _levelInfo.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _classInfo[section].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"classselection%li%li", (long)indexPath.section, (long)indexPath.item];
    [_collectionView registerClass:[PIClassSelectionViewCell class] forCellWithReuseIdentifier:identifier];
    
    PIClassSelectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    PIClassSelectionViewCell *_cell = (PIClassSelectionViewCell *)cell;
    @weakObj(self);
    @weakObj(_cell);
    _cell.touchHandler = ^(NSString *content){
        if (selfweak.selectedCell != _cellweak && selfweak.selectedCell != nil) {
            [selfweak.selectedCell setState:NO];
        }
        selfweak.selectedCell = _cellweak;
        selfweak.selectedClassName = content;
        if (selfweak.onSelected) {
            selfweak.onSelected(content);
        }
    };
    [_cell setTitle:_classInfo[indexPath.section][indexPath.item]];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(STWidth(mScreenWidth - STWidth(30)), STWidth(35));
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"classselectionheader" forIndexPath:indexPath];
    if ([header viewWithTag:3333]) {
        UILabel *label = [header viewWithTag:3333];
        label.text = _levelInfo[indexPath.section];
        return header;
    }
    
    UILabel *label = [UILabel new];
    label.tag = 3333;
    label.text = _levelInfo[indexPath.section];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = UIColor.fe_mainTextColor;
    [header addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.offset(STWidth(-10));
    }];
    label.text = _levelInfo[indexPath.section];
    return header;
}


@end
