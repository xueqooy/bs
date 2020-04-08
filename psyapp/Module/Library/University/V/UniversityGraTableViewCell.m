//
//  UniversityGraTableViewCell.m
//  smartapp
//
//  Created by lafang on 2019/3/18.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UniversityGraTableViewCell.h"
#import "UIView+Extension.h"
#import "UIColor+Category.h"
#import "UIImage+Category.h"
#import <Masonry/Masonry.h>

@interface UniversityGraTableViewCell ()

@property(nonatomic,strong) UIImageView *iconImage;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *numLabel;
@property(nonatomic,strong) UILabel *contentLabel;

@end

@implementation UniversityGraTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.text = @"本科毕业直接工作比例";
        self.titleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(66);
            make.right.equalTo(self.contentView).offset(-20);
            make.top.equalTo(self.contentView).offset(10);
        }];
        
        self.numLabel = [[UILabel alloc] init];
        self.numLabel.textColor = [UIColor colorWithHexString:@"ff8b00"];
        self.numLabel.font = [UIFont systemFontOfSize:18];
        self.numLabel.text = @"1";
        [self.contentView addSubview:self.numLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(66);
            make.right.equalTo(self.contentView).offset(-20);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        }];
        
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.textColor = [UIColor colorWithHexString:@"666666"];
        self.contentLabel.font = [UIFont systemFontOfSize:15];
        self.contentLabel.text = @"本科排名";
        self.contentLabel.numberOfLines = 0;
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(66);
            make.right.equalTo(self.contentView).offset(-20);
            make.top.equalTo(self.numLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        
        self.iconImage = [[UIImageView alloc] init];
        self.iconImage.image = [UIImage imageNamed:@"fire_login_head_other"];
        [self.contentView addSubview:self.iconImage];
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(20);
            make.size.mas_equalTo(CGSizeMake(36, 36));
        }];
        
    }
    
    return self;
}

-(void)updateModel:(NSInteger)type num:(NSNumber *)num{
    //type 0本科直接就业 1毕业5年薪水 2本科读研率
    if(type == 0){
        self.titleLabel.text = @"本科毕业直接工作比例";
        CGFloat nm = [num floatValue] *100;
        if(nm<=0){
            self.numLabel.text = @"--";
        }else{
            self.numLabel.text = [NSString stringWithFormat:@"%0.2f%%",nm];
        }
        self.contentLabel.text = @"*指毕业后直接就业的毕业生占比(包含创业)";
        self.iconImage.image = [UIImage imageNamed:@"career_university_work"];
    }else if(type == 1){
        self.titleLabel.text = @"毕业五年薪水";
        if(num<=0){
            self.numLabel.text = @"--";
        }else{
            self.numLabel.text = [num stringValue];
        }
        self.contentLabel.text = @"";
        self.iconImage.image = [UIImage imageNamed:@"career_university_doller"];
    }else{
        self.titleLabel.text = @"本科读研率";
        CGFloat nm = [num floatValue] *100;
        if(nm<=0){
            self.numLabel.text = @"--";
        }else{
            self.numLabel.text = [NSString stringWithFormat:@"%0.2f%%",nm];
        }
        
        self.contentLabel.text = @"";
        self.iconImage.image = [UIImage imageNamed:@"career_university_dy"];
    }
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
