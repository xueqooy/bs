//
//  ZJChooseViewOneLeftCell.m
//  smartapp
//
//  Created by lafang on 2019/2/21.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "ZJChooseViewOneLeftCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+Category.h"

@implementation ZJChooseViewOneLeftCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpAllView];
    }
    return self;
}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (isSelected) {
        self.arrowImgV.hidden = YES;
        self.titleLab.font = [UIFont systemFontOfSize:16];
        self.titleLab.textColor = [UIColor colorWithHexString:@"fc674f"];
    }else{
        self.arrowImgV.hidden = YES;
        self.titleLab.font = [UIFont systemFontOfSize:16];
        self.titleLab.textColor = [UIColor grayColor];
    }
}

-(void)setThreeIsSelected:(BOOL)threeIsSelected{
    _threeIsSelected = threeIsSelected;
    if (threeIsSelected) {
        self.titleLab.font = [UIFont systemFontOfSize:16];
        self.titleLab.textColor = [UIColor colorWithHexString:@"fc674f"];
    }else{
        self.titleLab.font = [UIFont systemFontOfSize:16];
        self.titleLab.textColor = [UIColor grayColor];
    }
}
// 添加所子控件
-(void)setUpAllView{
    self.titleLab = [[UILabel alloc]init];
    _titleLab.font = [UIFont systemFontOfSize:14];
    _titleLab.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.titleLab];
    
    
    self.arrowImgV = [[UIImageView alloc]init];
    _arrowImgV.contentMode = UIViewContentModeCenter;
    _arrowImgV.image = [UIImage imageNamed:@"new_selected_jt"];
    [self.contentView addSubview:self.arrowImgV];
    self.arrowImgV.hidden = YES;
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_lessThanOrEqualTo(-30);
    }];
    
    [self.arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLab.mas_centerY);
        make.left.equalTo(_titleLab.mas_right).offset(4);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(9);
    }];
    
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ZJChooseViewOneLeftCell";
    id cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
