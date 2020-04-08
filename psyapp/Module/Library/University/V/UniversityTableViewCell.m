//
//  UniversityTableViewCell.m
//  smartapp
//
//  Created by lafang on 2019/3/5.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UniversityTableViewCell.h"
#import "UIView+Extension.h"
#import "UIColor+Category.h"
#import "UIImage+Category.h"
#import <Masonry/Masonry.h>
#import "EdgeLabel.h"
#import "UIImageView+WebCache.h"

@interface UniversityTableViewCell()

@property(nonatomic,strong) UIView *itemView;
@property(nonatomic,strong) UIImageView *iconImage;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIView *tagsView;
@property(nonatomic,strong) UILabel *indexLabel;

@property(nonatomic,strong) UniversityModel *universityModel;

@end

@implementation UniversityTableViewCell {
    UIView *line;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        self.itemView = [[UIView alloc] init];
        [self addSubview:self.itemView];
        [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(self).offset(10);
            make.bottom.equalTo(self).offset(-10);
        }];
        
        self.iconImage = [[UIImageView alloc] init];
        [self.itemView addSubview:self.iconImage];
        self.iconImage.image = [UIImage imageNamed:@"fire_login_head_other"];
        self.iconImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemView).offset(10);
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.centerY.equalTo(self.itemView);
        }];
        
        self.indexLabel = [[UILabel alloc] init];
        [self.itemView addSubview:self.indexLabel];
        [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.itemView).offset(-10);
            make.centerY.equalTo(self.itemView);
        }];
        self.indexLabel.text = @"1";
        self.indexLabel.textColor = [UIColor colorWithHexString:@"666666"];
        self.indexLabel.font = [UIFont systemFontOfSize:20];
        
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
        
        line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset([SizeTool width:15]);
            make.right.equalTo(self.contentView).offset(-[SizeTool width:15]);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
//        [self addTagsView];
        
    }
    return self;
}

-(void)addTagsView{
    
    [self.tagsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
//    NSArray *arrTags = [[NSArray alloc] initWithObjects:@"985",@"211",@"双一流",@"综合",@"本科", nil];
    
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

-(void)updateModel:(UniversityModel *)universityModel rankFilter:(NSString *)rankFilter isLastRow:(BOOL)ilr{
    if (ilr) {
        line.hidden = YES;
    } else {
        line.hidden = NO;
    }
    
    self.universityModel = universityModel;
    if(!self.universityModel){
        return;
    }
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:universityModel.logoUrl] placeholderImage:[UIImage imageNamed:@"fire_login_head_other"] options:0 progress:nil completed:nil];
    
    self.titleLabel.text = universityModel.cnName;
    
    NSDictionary *rankDic = universityModel.ranking;
    NSNumber *rank = rankDic[rankFilter];
    self.indexLabel.text = [rank stringValue];
    
    
    [self addTagsView];
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
