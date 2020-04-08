//
//  ProfessionalOpenUniTableViewCell.m
//  smartapp
//
//  Created by lafang on 2019/3/14.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "ProfessionalOpenUniTableViewCell.h"
#import "UIView+Extension.h"
#import "UIColor+Category.h"
#import "UIImage+Category.h"
#import <Masonry/Masonry.h>
#import "EdgeLabel.h"
#import "UIImageView+WebCache.h"

@interface ProfessionalOpenUniTableViewCell()

@property(nonatomic,strong) UIView *itemView;
@property(nonatomic,strong) UIImageView *iconImage;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIView *tagsView;
@property(nonatomic,strong) UILabel *indexLabel;
@property(nonatomic,strong) UIImageView *rightImage;

@property(nonatomic,strong) UILabel *specalLabel;
@property(nonatomic,strong) UILabel *subjectRequireLabel;


@property(nonatomic,strong) UniversityModel *universityModel;

@end

@implementation ProfessionalOpenUniTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        self.itemView = [[UIView alloc] init];
        [self.contentView addSubview:self.itemView];
        [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
        
        self.iconImage = [[UIImageView alloc] init];
        [self.itemView addSubview:self.iconImage];
        self.iconImage.image = [UIImage imageNamed:@"fire_login_head_other"];
        self.iconImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemView).offset(10);
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.top.equalTo(self.itemView).offset(10);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        [self.itemView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImage.mas_right).offset(10);
            make.right.equalTo(self.itemView).offset(-10);
            make.top.equalTo(self.iconImage.mas_top).offset(5);
        }];
        self.titleLabel.text = @"清华大学";
        self.titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        
        self.tagsView = [[UIView alloc] init];
        [self.itemView addSubview:self.tagsView];
        [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImage.mas_right).offset(10);
            make.right.equalTo(self.itemView).offset(-10);
            make.bottom.equalTo(self.iconImage.mas_bottom).offset(-5);
        }];
        
        self.indexLabel = [[UILabel alloc] init];
        self.indexLabel.text = @"A";
        self.indexLabel.textColor = [UIColor colorWithHexString:@"ff8b00"];
        self.indexLabel.font = [UIFont systemFontOfSize:16];
        [self.itemView addSubview:self.indexLabel];
        [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.itemView).offset(-20);
            make.centerY.equalTo(self.iconImage);
        }];
        
        self.rightImage = [[UIImageView alloc] init];
        self.rightImage.image = [UIImage imageNamed:@"fire_common_right_next"];
        [self.itemView addSubview:self.rightImage];
        [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.itemView);
            make.centerY.equalTo(self.iconImage);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        self.specalLabel = [[UILabel alloc] init];
        self.specalLabel.text = @"";
        self.specalLabel.textColor = [UIColor colorWithHexString:@"666666"];
        self.specalLabel.font = [UIFont systemFontOfSize:14];
        self.specalLabel.hidden = YES;
        self.specalLabel.numberOfLines = 0;
        [self.itemView addSubview:self.specalLabel];
        [self.specalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemView).offset(10);
            make.right.equalTo(self.itemView).offset(-10);
            make.top.equalTo(self.iconImage.mas_bottom).offset(10);
        }];
        
        self.subjectRequireLabel = [[UILabel alloc] init];
        self.subjectRequireLabel.text = @"";
        self.subjectRequireLabel.textColor = [UIColor colorWithHexString:@"666666"];
        self.subjectRequireLabel.font = [UIFont systemFontOfSize:14];
        self.subjectRequireLabel.hidden = YES;
        self.subjectRequireLabel.numberOfLines = 0;
        [self.itemView addSubview:self.subjectRequireLabel];
        [self.subjectRequireLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemView).offset(10);
            make.right.equalTo(self.itemView).offset(-10);
            make.top.equalTo(self.specalLabel.mas_bottom);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        [self.itemView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemView);
            make.right.equalTo(self.itemView);
            make.bottom.equalTo(self.itemView);
            make.height.mas_equalTo(1);
        }];
        
    }
    return self;
}

-(void)addTagsView{
    
    [self.tagsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableArray<NSString *> *arrTags = [[NSMutableArray alloc] init];
    if(self.universityModel.basicInfo.instituteQuality){
        [arrTags addObjectsFromArray:self.universityModel.basicInfo.instituteQuality];
    }
    
    if(self.universityModel.basicInfo.instituteType){
        [arrTags addObject:self.universityModel.basicInfo.instituteType];
    }
    
    if(self.universityModel.basicInfo.publicOrPrivate && [self.universityModel.basicInfo.publicOrPrivate isEqualToString:@"public"]){
        [arrTags addObject:@"公立"];
    }else{
        [arrTags addObject:@"私立"];
    }
    
    NSMutableArray<EdgeLabel *> *labels = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<arrTags.count; i++) {
        
        EdgeLabel *label = [[EdgeLabel alloc] init];
        [self.tagsView addSubview:label];
        [labels addObject:label];
        label.text = arrTags[i];
        label.textColor = [UIColor colorWithHexString:@"666666"];
        label.font = [UIFont systemFontOfSize:12];
        label.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        
        if(i==0){
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.tagsView);
                make.bottom.equalTo(self.tagsView);
            }];
        }else{
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(labels[i-1].mas_right).offset(5);
                make.bottom.equalTo(self.tagsView);
            }];
        }
    }
}

- (void)updateModel:(UniversityModel *)universityModel{
    
    self.universityModel = universityModel;
    if(!self.universityModel){
        return;
    }
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:universityModel.logoUrl] placeholderImage:[UIImage imageNamed:@"fire_login_head_other"] options:0 progress:nil completed:nil];
    
    self.titleLabel.text = universityModel.cnName;
    
    [self addTagsView];
    
    if(universityModel.majorInfo && universityModel.majorInfo.assessmentLevel){
        self.indexLabel.text = universityModel.majorInfo.assessmentLevel;
    }else{
        self.indexLabel.text = @"";
    }
    
    if(universityModel.majorInfo){
        //专业名称是否与特殊名称相同
        if([universityModel.majorInfo.majorName isEqualToString:universityModel.majorInfo.specialName]){
            self.specalLabel.hidden = YES;
            [self.specalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.itemView).offset(10);
                make.right.equalTo(self.itemView).offset(-10);
                make.top.equalTo(self.iconImage.mas_bottom);
//                make.bottom.equalTo(self.itemView);
            }];
        }else{
            self.specalLabel.hidden = NO;
            self.specalLabel.text = universityModel.majorInfo.specialName;
            [self.specalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.iconImage.mas_right).offset(10);
                make.right.equalTo(self.itemView).offset(-10);
                make.top.equalTo(self.iconImage.mas_bottom).offset(10);
//                make.bottom.equalTo(self.itemView).offset(-10);
            }];
        }
        
        if(universityModel.majorInfo.subjectsRequired){
            self.subjectRequireLabel.hidden = NO;
            [self.subjectRequireLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.itemView).offset(10);
                make.right.equalTo(self.itemView).offset(-10);
                make.top.equalTo(self.specalLabel.mas_bottom).offset(10);
                make.bottom.equalTo(self.itemView).offset(-10);
            }];
        }else{
            self.subjectRequireLabel.hidden = YES;
            [self.subjectRequireLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.itemView).offset(10);
                make.right.equalTo(self.itemView).offset(-10);
                make.top.equalTo(self.specalLabel.mas_bottom);
                make.bottom.equalTo(self.itemView).offset(-10);
            }];
        }
    }else{
        self.specalLabel.hidden = YES;
        self.subjectRequireLabel.hidden = YES;
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
