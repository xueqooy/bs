//
//  CommonScaleTextTableViewCell.m
//  smartapp
//
//  Created by lafang on 2019/4/22.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "CommonScaleTextTableViewCell.h"
#import "UIView+Extension.h"
#import "UIColor+Category.h"
#import "UIImage+Category.h"
#import <Masonry/Masonry.h>
#import "StringUtils.h"

@interface CommonScaleTextTableViewCell ()


@property(nonatomic,strong) UIView *itemView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIButton *btnScale;


@end

@implementation CommonScaleTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        
        self.itemView = [[UIView alloc] init];
        [self.contentView addSubview:self.itemView];
        [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.textLabel.text = @"";
        self.titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.numberOfLines = 5;
        [self.itemView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemView).offset(20);
            make.right.equalTo(self.itemView).offset(-20);
            make.top.equalTo(self.itemView).offset(10);
            
        }];
        
        self.btnScale = [StringUtils createButton:@"展开全部" color:@"ff8b00" font:14];
        [self.btnScale addTarget:self action:@selector(scaleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnScale setImage:[UIImage imageNamed:@"fire_report_desc_show"] forState:UIControlStateNormal];
        
        [self.itemView addSubview:self.btnScale];
        [self.btnScale mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.centerX.equalTo(self.itemView);
            make.size.mas_equalTo(CGSizeMake(90, 24));
            make.bottom.equalTo(self.itemView).offset(-10);
        }];
        [self.btnScale setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.btnScale.imageView.size.width, 0, self.btnScale.imageView.size.width)];
        [self.btnScale setImageEdgeInsets:UIEdgeInsetsMake(0, self.btnScale.titleLabel.bounds.size.width, 0, -self.btnScale.titleLabel.bounds.size.width)];
        
        
    }
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    return self;
}

-(void)scaleBtnClick:(UIButton *)btn{
    if(self.scaleCallback){
        self.scaleCallback(0);
        
    }
}

-(void)updateString:(NSString *)str isScale:(BOOL)isScale{
    
    
    if(isScale){
        self.titleLabel.numberOfLines = 0;
        [self.btnScale setTitle:@"缩起部分" forState:UIControlStateNormal];
        [self.btnScale setImage:[UIImage imageNamed:@"fire_report_desc_show"] forState:UIControlStateNormal];
    }else{
        self.titleLabel.numberOfLines = 5;
        [self.btnScale setTitle:@"展开全部" forState:UIControlStateNormal];
        [self.btnScale setImage:[UIImage imageNamed:@"fire_report_desc_hidden"] forState:UIControlStateNormal];
    }
    [StringUtils setLineSpace:5 withText:str inLabel:self.titleLabel];
    
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
