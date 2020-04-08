//
//  FEOuccupationTreeViewCell.m
//  smartapp
//
//  Created by mac on 2019/9/8.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEOuccupationTreeViewCell.h"
@interface FEOuccupationTreeViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIView *separatorLine;

@property (nonatomic, strong) UIImage *expantionImage;
@property (nonatomic, strong) UIImage *collapseImage;
@end
@implementation FEOuccupationTreeViewCell

+ (instancetype)treeViewCellWith:(RATreeView *)treeView
{
    FEOuccupationTreeViewCell *cell = [treeView dequeueReusableCellWithIdentifier:@"FEOuccupationTreeViewCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FEOuccupationTreeViewCell" owner:nil options:nil] firstObject];
        cell.expantionImage = [UIImage imageNamed:@"lib_expand"];
        cell.collapseImage = [UIImage imageNamed:@"lib_collapse"];
    }
    return cell;
}

- (void)setExpantionStatus:(BOOL)expand{
    [_arrowImageView setImage:expand ? _expantionImage : _collapseImage];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)setCellWith:(NSString *)title level:(NSInteger)level children:(NSInteger )children{
    if (level == 2) { 
        self.arrowImageView.hidden = YES;
    }
    else { 
        self.arrowImageView.hidden = NO;
    }
    self.titleLabel.text = title;
    self.arrowImageView.image = _collapseImage;
    CGFloat left;
    if (level < 2) {
        left = STWidth(15) + level * STWidth(30);
    } else {
        left = STWidth(15) + 1 * STWidth(30);
    }
  

    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.size.mas_equalTo(STSize(22, 22));
        make.centerY.mas_equalTo(0);
    }];


    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_arrowImageView.mas_right).offset(STWidth(11));
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(mScreenWidth - left - STWidth(30));
    }];
    

    [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(STWidth(15));
        make.right.mas_equalTo(STWidth(-15));
        make.bottom.mas_equalTo(0);
    }];
}


@end
