//
//  FEMineTableViewCell.m
//  smartapp
//
//  Created by lafang on 2018/8/21.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEMineTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIView+Extension.h"
#import "UIColor+Category.h"
#import "UIImage+Category.h"

@interface FEMineTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIButton *newsNumBtn;
@end

@implementation FEMineTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.fe_contentBackgroundColor;
        self.leftImageView = [[UIImageView alloc] init];
        self.leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.leftImageView];
        [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(STWidth(16));
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(STSize(24, 24));
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = UIColor.fe_titleTextColor;
        self.titleLabel.font = STFontRegular(14);
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(STWidth(55));
            make.centerY.equalTo(self.leftImageView);
        }];
        
        self.newsNumBtn = [[UIButton alloc] init];
        [self.newsNumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.newsNumBtn setTitle:@"0" forState:UIControlStateNormal];
        self.newsNumBtn.titleLabel.font = [UIFont systemFontOfSize:8];
        [self.newsNumBtn setBackgroundImage:[UIImage imageNamed:@"fire_news_no_read"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.newsNumBtn];
        [self.newsNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(-3);
            make.top.equalTo(self.titleLabel.mas_top).offset(-7);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        self.newsNumBtn.hidden = YES;
        
        self.rightLabel = [[UILabel alloc] init];
        self.rightLabel.font = [UIFont systemFontOfSize:15];
        self.rightLabel.text = @"";
        self.rightLabel.textColor = UIColor.fe_mainColor;
        self.rightLabel.hidden = YES;
        [self addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-[SizeTool width:50]);
            make.centerY.equalTo(self.leftImageView);
        }];
        
        _bottonLine = [UIView new];
        _bottonLine.backgroundColor = UIColor.fe_separatorColor;
        [self addSubview:_bottonLine];
        [_bottonLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.textLabel setTextColor:[UIColor colorWithHexString:@"#717171"]];//设置cell的字体的颜色
        self.textLabel.highlightedTextColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    self.leftImageView.image = [UIImage imageNamed:imageName];
}

- (void)setText:(NSString *)text {
    _text = text;
    self.titleLabel.text = text;
}

-(void)setRightText:(NSString *)rightText{
    _rightText = rightText;
    if(rightText){
        self.rightLabel.hidden = NO;
        self.rightLabel.text = rightText;
    }else{
        self.rightLabel.hidden = YES;
    }
}

-(void)setNewsNum:(NSInteger)newsNum{
    if(newsNum>0){
        self.newsNumBtn.hidden = NO;
        
        if(newsNum>=10){
            [self.newsNumBtn setBackgroundImage:[UIImage imageNamed:@"fire_news_no_read_max"] forState:UIControlStateNormal];
            [self.newsNumBtn setTitle:@"..." forState:UIControlStateNormal];
            [self.newsNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.titleLabel.mas_right).offset(-3);
                make.top.equalTo(self.titleLabel.mas_top).offset(-7);
                make.size.mas_equalTo(CGSizeMake(20, 15));
            }];
        }else{
            [self.newsNumBtn setBackgroundImage:[UIImage imageNamed:@"fire_news_no_read"] forState:UIControlStateNormal];
            [self.newsNumBtn setTitle:[NSString stringWithFormat:@"%i",newsNum] forState:UIControlStateNormal];
            [self.newsNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.titleLabel.mas_right).offset(-3);
                make.top.equalTo(self.titleLabel.mas_top).offset(-7);
                make.size.mas_equalTo(CGSizeMake(15, 15));
            }];
        }
    }else{
        self.newsNumBtn.hidden = YES;
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
