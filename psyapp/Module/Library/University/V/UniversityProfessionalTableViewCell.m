//
//  UniversityProfessionalTableViewCell.m
//  smartapp
//
//  Created by lafang on 2019/3/22.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UniversityProfessionalTableViewCell.h"
#import "UIView+Extension.h"
#import "UIColor+Category.h"
#import "UIImage+Category.h"
#import <Masonry/Masonry.h>

@interface UniversityProfessionalTableViewCell ()

@property(nonatomic,strong) UIView *itemView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *subLabel;
@property(nonatomic,strong) UILabel *rightLabel;
@property(nonatomic,strong) UIImageView *rightImage;

@property(nonatomic,strong) UniversityMajorModel *universityMajorModel;

@property(nonatomic,strong) UniversityKeySubjectModel *universityKeySubjectModel;

@end

@implementation UniversityProfessionalTableViewCell

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
        self.titleLabel.text = @"专业名称";
        self.titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.numberOfLines = 0;
        [self.itemView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemView).offset(20);
            make.top.equalTo(self.itemView).offset(15);
            make.bottom.equalTo(self.itemView).offset(-15);
        }];
        
        self.subLabel = [[UILabel alloc] init];
        self.subLabel.text = @"A+";
        self.subLabel.textColor = [UIColor redColor];
        self.subLabel.font = [UIFont systemFontOfSize:14];
        self.subLabel.numberOfLines = 0;
        [self.itemView addSubview:self.subLabel];
        [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(5);
//            make.right.equalTo(self.itemView).offset(-20);
            make.centerY.equalTo(self.titleLabel);
        }];
        self.subLabel.hidden = YES;
        
        self.rightLabel = [[UILabel alloc] init];
        self.rightLabel.text = @"国家级特色";
        self.rightLabel.textColor = [UIColor whiteColor];
        self.rightLabel.font = [UIFont systemFontOfSize:12];
        self.rightLabel.numberOfLines = 0;
        self.rightLabel.backgroundColor = [UIColor blueColor];
        [self.itemView addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.right.equalTo(self.itemView).offset(-50);
        }];
        self.rightLabel.hidden = YES;
        
        self.rightImage = [[UIImageView alloc] init];
        self.rightImage.image = [UIImage imageNamed:@"fire_common_right_next"];
        [self.itemView addSubview:self.rightImage];
        [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.itemView).offset(-15);
            make.centerY.equalTo(self.titleLabel);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        [self.itemView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemView).offset(20);
            make.right.equalTo(self.itemView).offset(-20);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(14);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    return self;
}

//开设专业
- (void)updateProfessionalData:(UniversityMajorModel *)universityMajorModel{
    
    self.universityMajorModel = universityMajorModel;
    if(universityMajorModel){
        self.titleLabel.text = universityMajorModel.majorName;
        self.rightImage.hidden = NO;
        
        if(self.universityMajorModel.assessmentLevel){
            self.subLabel.hidden = NO;
            self.subLabel.text = self.universityMajorModel.assessmentLevel;
        }else{
            self.subLabel.hidden = YES;
        }
    }
    
}

//重点学科或者一流学科
- (void)updateKeySubjectData:(UniversityKeySubjectModel *)universityKeySubjectModel index:(NSInteger) index{
    
    self.universityKeySubjectModel = universityKeySubjectModel;
    
    if(universityKeySubjectModel.items[index]){
        self.titleLabel.text = universityKeySubjectModel.items[index];
        self.rightImage.hidden = YES;
        self.subLabel.hidden = YES;
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
