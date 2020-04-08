//
//  OccupationTableViewCell.m
//  smartapp
//
//  Created by lafang on 2019/3/11.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "OccupationTableViewCell.h"
#import "UIColor+Category.h"
#import <Masonry/Masonry.h>
#import "UIView+Extension.h"
#import "UIImageView+WebCache.h"

@interface OccupationTableViewCell()

//@property (strong, nonatomic)  UIImageView *iconView;//图标

@property (strong, nonatomic)  UILabel *titleLable;//标题

@end

@implementation OccupationTableViewCell {
    UIView *line;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        
        
//        self.iconView = [[UIImageView alloc] init];
//        [self.iconView setImage:[UIImage imageNamed:@"fire_login_head_other"]];
//        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
//        [self.contentView addSubview:self.iconView];
//        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView).offset(20);
//            make.top.equalTo(self.contentView).offset(10);
//            make.size.mas_equalTo(CGSizeMake(20, 20));
//        }];
        
        
        
        self.titleLable = [[UILabel alloc] init];
        self.titleLable.textColor = [UIColor colorWithHexString:@"#333333"];
        self.titleLable.font = [UIFont systemFontOfSize:16];
        self.titleLable.text = @"职业名称";
        self.titleLable.numberOfLines = 2;
        [self.contentView addSubview:self.titleLable];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset([SizeTool width:15]);
            make.right.equalTo(self.contentView).offset(-[SizeTool width:35]);
            make.centerY.mas_equalTo(0);
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
        
        UIImageView *rightImage = [[UIImageView alloc] init];
        rightImage.image = [UIImage imageNamed:@"fire_common_right_next"];
        [self.contentView addSubview:rightImage];
        [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-[SizeTool width:15]);
            make.centerY.equalTo(self.titleLable);
            make.size.mas_equalTo(STSize(12, 12));
        }];
        
    }
    
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    return self;
}

-(void)updateModel:(ProfessionalOccupationsModel *)occupationModel isLastRow:(BOOL)ilr{
    
    self.titleLable.text = occupationModel.occupationName;
    if (ilr) {
        line.hidden = YES;
    } else {
        line.hidden = NO;
    }
}

-(void)updateWithName:(NSString *)name {
    
    self.titleLable.text = name;
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
