//
//  CommonSingTextTableViewCell.m
//  smartapp
//  单个文本的cell
//  Created by lafang on 2019/3/12.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "CommonSingTextTableViewCell.h"
#import "UIView+Extension.h"
#import "UIColor+Category.h"
#import "UIImage+Category.h"
#import <Masonry/Masonry.h>
#import "StringUtils.h"

@interface CommonSingTextTableViewCell ()


@property(nonatomic,strong) UIView *itemView;
@property(nonatomic,strong) UILabel *titleLabel;

@end

@implementation CommonSingTextTableViewCell

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
        self.textLabel.text = @"";
        self.titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.numberOfLines = 0;
        [self.itemView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemView).offset(20);
            make.right.equalTo(self.itemView).offset(-20);
            make.top.equalTo(self.itemView).offset(10);
            make.bottom.equalTo(self.itemView).offset(-10);
        }];
        
        
    }
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    return self;
}

-(void)updateString:(NSString *)str{
    
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    
//    self.titleLabel.attributedText = attributedString;
    
    [StringUtils setLineSpace:5 withText:str inLabel:self.titleLabel];
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
