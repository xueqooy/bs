//
//  UniversityRankingTableViewCell.m
//  smartapp
//
//  Created by lafang on 2019/3/14.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UniversityRankingTableViewCell.h"
#import "UIView+Extension.h"
#import "UIColor+Category.h"
#import "UIImage+Category.h"
#import <Masonry/Masonry.h>

@interface UniversityRankingTableViewCell ()

@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *numLabel;

@end

@implementation UniversityRankingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.numLabel = [[UILabel alloc] init];
        self.numLabel.textColor = [UIColor whiteColor];
        self.numLabel.font = [UIFont systemFontOfSize:18];
        self.numLabel.text = @"1";
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        self.numLabel.layer.masksToBounds = YES;
        self.numLabel.layer.cornerRadius = 3;
        self.numLabel.backgroundColor = [UIColor colorWithHexString:@"ff8b00"];
        [self.contentView addSubview:self.numLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(5);
            make.left.equalTo(self.contentView).offset(20);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.bottom.equalTo(self.contentView).offset(-5);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.text = @"本科排名";
        self.titleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.numLabel.mas_right).offset(10);
            make.right.equalTo(self.contentView).offset(-20);
            make.centerY.equalTo(self.numLabel);
        }];
        
    }
    
    return self;
}

-(void)updateModel:(UniversityRankingItemModel *)universityRankingItemModel{
    
    self.numLabel.text = [universityRankingItemModel.value stringValue];
    
    self.titleLabel.text = universityRankingItemModel.name;
    
    if([universityRankingItemModel.type isEqualToString:@"world"]){
        //国际排名
        self.numLabel.backgroundColor = [UIColor colorWithHexString:@"ff8b00"];
    }else{
        self.numLabel.backgroundColor = [UIColor colorWithHexString:@"26a59a"];
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
