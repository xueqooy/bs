//
//  EnrollmentNavigationTableViewCell.m
//  smartapp
//
//  Created by lafang on 2019/3/13.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "EnrollmentNavigationTableViewCell.h"
#import "UIView+Extension.h"
#import "UIColor+Category.h"
#import "UIImage+Category.h"
#import <Masonry/Masonry.h>

@interface EnrollmentNavigationTableViewCell ()


@property(nonatomic,strong) UIView *itemView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *contentLabel;
@property(nonatomic,strong) UIImageView *rightImage;

@end

@implementation EnrollmentNavigationTableViewCell

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
        self.titleLabel.text = @"";
        self.titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.numberOfLines = 0;
        [self.itemView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemView).offset(20);
            make.right.equalTo(self.itemView).offset(-20);
            make.top.equalTo(self.itemView).offset(10);
        }];
        
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.textColor = [UIColor colorWithHexString:@"666666"];
        self.contentLabel.font = [UIFont systemFontOfSize:15];
        self.contentLabel.numberOfLines = 0;
        [self.itemView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemView).offset(20);
            make.right.equalTo(self.itemView).offset(-40);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.itemView).offset(-10);
        }];
        
        self.rightImage = [[UIImageView alloc] init];
        self.rightImage.image = [UIImage imageNamed:@"fire_common_right_next"];
        [self.itemView addSubview:self.rightImage];
        [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.itemView).offset(-20);
            make.centerY.equalTo(self.contentLabel);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        [self.itemView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemView).offset(20);
            make.right.equalTo(self.itemView).offset(-20);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(9);
            make.height.mas_equalTo(0.5);
        }];
        
        
    }
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    return self;
}

- (void)updateModel:(EnrollmentNavigationItemModel *)enrollmentNavigationItemModel{
    self.titleLabel.text = enrollmentNavigationItemModel.fatherName;
    self.contentLabel.text = enrollmentNavigationItemModel.name;
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
