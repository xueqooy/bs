//
//  OccupationDetailsTableViewCell.m
//  smartapp
//
//  Created by lafang on 2019/3/11.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "OccupationDetailsTableViewCell.h"
#import "UIView+Extension.h"
#import "UIColor+Category.h"
#import "UIImage+Category.h"
#import <Masonry/Masonry.h>

@interface OccupationDetailsTableViewCell ()


@property(nonatomic,strong) UIView *itemView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *contentLabel;


@property(nonatomic,strong) ProfessionalIntroducesModel *professionalIntroducesModel;

@end

@implementation OccupationDetailsTableViewCell

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
        self.titleLabel.text = @"测试数据";
        self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
//        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
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
            make.right.equalTo(self.itemView).offset(-20);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.itemView).offset(-10);
        }];
        
        
    }
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    return self;
}

-(void)updateModel:(ProfessionalIntroducesModel *)professionalIntroducesModel{
    
    self.professionalIntroducesModel = professionalIntroducesModel;
    
    if(!self.professionalIntroducesModel){
        return;
    }
    
    self.titleLabel.text = professionalIntroducesModel.title;
    self.contentLabel.text = professionalIntroducesModel.content;

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
