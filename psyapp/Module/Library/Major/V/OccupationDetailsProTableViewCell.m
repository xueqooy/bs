//
//  OccupationDetailsProTableViewCell.m
//  smartapp
//
//  Created by lafang on 2019/3/12.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "OccupationDetailsProTableViewCell.h"
#import "UIView+Extension.h"
#import "UIColor+Category.h"
#import "UIImage+Category.h"
#import <Masonry/Masonry.h>

@interface OccupationDetailsProTableViewCell ()


@property(nonatomic,strong) UIView *itemView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIImageView *rightImage;


//@property(nonatomic,strong) ProfessionalCategoryModel *professionalCategoryModel;

@end

@implementation OccupationDetailsProTableViewCell

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
        self.titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.numberOfLines = 0;
        [self.itemView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemView).offset(20);
            make.right.equalTo(self.itemView).offset(-40);
            make.top.equalTo(self.itemView).offset(10);
            make.bottom.equalTo(self.itemView).offset(-10);
        }];
        
        self.rightImage = [[UIImageView alloc] init];
        self.rightImage.image = [UIImage imageNamed:@"fire_common_right_next"];
        [self.itemView addSubview:self.rightImage];
        [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.itemView).offset(-20);
            make.centerY.equalTo(self.titleLabel);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        [self.itemView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemView).offset(20);
            make.right.equalTo(self.itemView).offset(-20);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(9);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    return self;
}

-(void)updateModel:(ProfessionalCategoryModel *)professionalCategoryModel{
    
//    self.professionalCategoryModel = professionalCategoryModel;
    
    if(!professionalCategoryModel){
        return;
    }
    
    self.titleLabel.text = professionalCategoryModel.majorName;
}

-(void)updateModelPro:(ProfessionalOccupationsModel *)professionalOccupationsModel{
    
    if(!professionalOccupationsModel){
        return;
    }
    
    self.titleLabel.text = professionalOccupationsModel.occupationName;
    
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
