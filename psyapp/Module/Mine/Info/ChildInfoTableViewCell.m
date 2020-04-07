//
//  ChildInfoTableViewCell.m
//  smartapp
//
//  Created by lafang on 2018/10/25.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "ChildInfoTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIView+Extension.h"
#import "UIColor+Category.h"
#import "UIImage+Category.h"
#import "UIImageView+WebCache.h"

@interface ChildInfoTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIImageView *avatarButton;
@end

@implementation ChildInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.fe_contentBackgroundColor;
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = STFontRegular(14);
        self.titleLabel.textColor = UIColor.fe_titleTextColor;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(STWidth(15));
            make.centerY.equalTo(self.contentView);
        }];
        
        self.rightLabel = [[UILabel alloc] init];
        self.rightLabel.font = STFontRegular(14);
        self.rightLabel.text = @"";
        self.rightLabel.textColor = UIColor.fe_mainTextColor;
        [self.contentView addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-STWidth(10));
            make.centerY.equalTo(self.contentView);
        }];
        
        self.avatarButton = [[UIImageView alloc] init];
        [self.contentView addSubview:self.avatarButton];
        [self.avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-STWidth(15));
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(STSize(60, 60));
        }];
        self.avatarButton.hidden = YES;
        self.avatarButton.layer.cornerRadius=STWidth(30);
        self.avatarButton.layer.masksToBounds=YES;
        self.avatarButton.layer.borderWidth = 1.5f;
        self.avatarButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.avatarButton.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alterHeadPortrait)];
        [self.avatarButton addGestureRecognizer:singleTap];
        
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor =UIColor.fe_separatorColor;
        [self addSubview:_bottomLine];
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(STWidth(15));
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-STWidth(15));
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return self;
}

-(void)updateCell:(NSString *)title rightStr:(NSString *)rightStr headImageUrl:(NSString *)headImageUrl{
    self.titleLabel.text = title;
    self.avatarButton.hidden = YES;

    if([title isEqualToString:@"头像:"]){
        self.avatarButton.hidden = NO;
        [self updateUserHeadImage:headImageUrl];
        self.rightLabel.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryNone;
    }else if([title isEqualToString:@"昵称:"] || [title isEqualToString:@"年级:"]){
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(STWidth(-15));
            make.centerY.equalTo(self.contentView);
        }];
    }
    

    self.rightLabel.text = rightStr;
}

-(void)updateUserHeadImage:(NSString *)avatarUrl{
    BOOL isBoy = [UCManager.sharedInstance.currentChild.sex isEqualToNumber:@1] ;
    if(avatarUrl && ![avatarUrl isKindOfClass:[NSNull class]]){
        [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"default_header_%@", isBoy?@"boy":@"girl"]]];
    }else{
        [self.avatarButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"default_header_%@", isBoy?@"boy":@"girl"]]];
    }
}

-(void)alterHeadPortrait{
    if(_commonBlock){
        _commonBlock(0);
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
