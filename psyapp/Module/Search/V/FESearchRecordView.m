//
//  FESearchRecordView.m
//  smartapp
//
//  Created by xueqooy on 2019/7/12.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FESearchRecordView.h"
#import "FEEqualSpaceFlowLayoutEvolve.h"
#import "FECommonAlertView.h"

@interface FESearchRecordView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout >

@property (nonatomic, strong) UICollectionView *collectionView;
//@property (nonatomic, strong) UIButton *trashButton;
@property (nonatomic, assign) NSInteger maxCap;
@end

static NSString * const kSearchRecordKey = @"search_record";
@implementation FESearchRecordView
{
    NSMutableArray *records;
}
#pragma mark - public
- (instancetype)init {
    self = [super init];
    if (self) {
        self.maxCap = 20;
//        records = @[@"测试", @"好棒我啊啊 啊啊啊", @"是打算打算打算打算打算打算打算的大时代大厦的啊的爱上大叔的撒 阿斯顿", @"das", @"1",@"dsadasdasdas", @"说的是当时的"].mutableCopy;
        [self _loadLocalSearchRecords];
        [self addSubview:self.collectionView];
    }
    return self;
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.collectionView.frame = frame;
}

- (void)setMaximumCapacityOfRecords:(NSInteger)n {
    _maxCap = n;
}

- (void)reloadRecords {
    [self _loadLocalSearchRecords];
    [self.collectionView reloadData];
}

- (void)saveSearchRecord:(NSString *)aRecord {
    
    NSMutableArray *data = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] objectForKey:kSearchRecordKey];
    NSMutableArray *newRecords;
    if (data.count == 0) {
        newRecords = @[].mutableCopy;
        [newRecords addObject:aRecord];
    } else {
        newRecords = [NSMutableArray arrayWithArray:data];
        if (data.count >= _maxCap) { //超出记录最大容量
            [newRecords removeLastObject];
        }
        BOOL new = YES;     //查重
        for (NSString *anOldRecord in data) {
            if ([anOldRecord isEqualToString:aRecord]) {
                new = NO;
            }
        }
        if (new) {
            [newRecords insertObject:aRecord atIndex:0]; //倒序
        }
    }
    //存档
    [[NSUserDefaults standardUserDefaults] setObject:newRecords forKey:kSearchRecordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self reloadRecords];
}
#pragma mark - private

- (void)_loadLocalSearchRecords {
    records = @[].mutableCopy;
    NSArray *data = [[NSUserDefaults standardUserDefaults] objectForKey:kSearchRecordKey];
    records = data.mutableCopy;
    if (records.count != 0) {
        [self addSubview:self.collectionView];
    }
}

#pragma mark - lazy
-(UICollectionView *)collectionView
{
    if(!_collectionView){
        
        FEEqualSpaceFlowLayoutEvolve *flowLayout = [[FEEqualSpaceFlowLayoutEvolve alloc]initWthType:AlignWithLeft];
        
        _collectionView =[ [UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = UIColor.fe_contentBackgroundColor;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        
        //注册
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellReuseIdentifier"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerViewReuseIdentifier"];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return records.count;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellReuseIdentifier" forIndexPath:indexPath];
    
    cell.layer.cornerRadius = 2;
    cell.backgroundColor = UIColor.fe_buttonBackgroundColorActive;

    UILabel *seekContentLabel = [[UILabel alloc] init];
    seekContentLabel.font = [UIFont systemFontOfSize:14];
    seekContentLabel.textColor = UIColor.fe_auxiliaryTextColor;
    seekContentLabel.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:seekContentLabel];
    [seekContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).offset(11);
        make.centerY.equalTo(cell);
        make.right.equalTo(cell).mas_offset(-11);
    }];
    seekContentLabel.tag = 2019;
    
    
    UILabel *_seekContentLabel = [cell viewWithTag:2019];
    _seekContentLabel.text = records[indexPath.item];
    [_seekContentLabel sizeToFit];
    return cell;
}



//设置头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerViewReuseIdentifier" forIndexPath:indexPath];
    
    if(kind == UICollectionElementKindSectionHeader){
        UILabel *sectionLabel = [[UILabel alloc] init];
        sectionLabel.tag = 2020;
       
        [headerReusableView addSubview:sectionLabel];
        [sectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerReusableView).offset(15);
            make.centerY.equalTo(headerReusableView);
        }];
        sectionLabel.textColor = UIColor.fe_mainTextColor;
        sectionLabel.font = [UIFont systemFontOfSize:14];
        UILabel *_sectionLabel = [headerReusableView viewWithTag:2020];
        _sectionLabel.text =  @"历史记录";
        
        UIButton *trashButton = [UIButton new];
        trashButton.tag = 2021;
        [trashButton setImage:records? [UIImage imageNamed:@"trash"]:nil forState:UIControlStateNormal];;
        [headerReusableView addSubview:trashButton];
        [trashButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(18, 18));
            make.right.equalTo(headerReusableView).offset(-18);
            make.centerY.equalTo(headerReusableView);
        }];
        
        [trashButton addTarget:self action:@selector(deleteAllRecords)
               forControlEvents:UIControlEventTouchUpInside];
        
    }
    headerReusableView.hidden = records.count?NO:YES;
   
    return headerReusableView;
}
- (void)deleteAllRecords {
    [mKeyWindow endEditing:YES];
    FECommonAlertView *alert = [[FECommonAlertView alloc] initWithTitle:@"确定要删除所有历史记录吗" leftText:@"取消" rightText:@"确定" icon:nil];
    alert.resultIndex = ^(NSInteger index) {
        if (index == 2) {
            NSMutableArray *emptyRecord = @[].mutableCopy;
            [[NSUserDefaults standardUserDefaults] setObject:emptyRecord forKey:kSearchRecordKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self reloadRecords];
        }
    };
    [alert showCustomAlertView];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(_collectionView.frame.size.width, 50);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectString = records[indexPath.item];
    if (selectString) {
        if (_selectCompletionHandler) {
            _selectCompletionHandler(selectString);
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *content = records[indexPath.item];
    //计算字体宽度
    CGRect itemFrame = [content boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    CGFloat width = itemFrame.size.width + 20;
    
    if(width > self.frame.size.width - 42 - 15 ){
        return CGSizeMake(self.frame.size.width - 15 - 42 ,40);
    }
    return CGSizeMake(width + 10,40);
}



@end
