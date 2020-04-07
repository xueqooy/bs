//
//  FEReportFlowLayoutCollectionView.m
//  smartapp
//
//  Created by mac on 2019/12/9.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEReportFlowLayoutTagView.h"
#import "KMTagListView.h"
@interface FEReportFlowLayoutTagView() <KMTagListViewDelegate>
@end

@implementation FEReportFlowLayoutTagView {
    NSString *_title;
    NSArray <NSString *> *_itemNames;
    CGFloat _width;
}

- (instancetype)initWithTitle:(NSString *)title itemNames:(NSArray<NSString *> *)itemNames projectedWidth:(CGFloat)width{
    self = [super init];
    _title = title;
    _itemNames = itemNames;
    _width = width;
    [self build];
    return self;
}

- (void)build {
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = _title;
    titleLabel.textColor = UIColor.fe_titleTextColorLighten;
    titleLabel.font =STFontBold(18);
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
    }];
    
    KMTagListView *tagView = [[KMTagListView alloc] initWithFrame:CGRectMake(0, 0, _width, 0)];
    tagView.delegate_ = self;
    [tagView setupSubViewsWithTitles:_itemNames];
    [self addSubview:tagView];

    CGFloat height = tagView.contentSize.height;

    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(height);
        make.left.right.bottom.offset(0);
    }];
    
    
}

-(void)ptl_TagListView:(KMTagListView *)tagListView didSelectTagViewAtIndex:(NSInteger)index selectContent:(NSString *)content{
    if (_tagClickHandler) {
        _tagClickHandler(index);
    }
}
@end
