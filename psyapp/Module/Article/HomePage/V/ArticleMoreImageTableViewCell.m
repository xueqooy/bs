//
//  ArticleMoreImageTableViewCell.m
//  smartapp
//
//  Created by lafang on 2019/4/3.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "ArticleMoreImageTableViewCell.h"
#import "UIColor+Category.h"
#import <Masonry/Masonry.h>
#import "UIView+Extension.h"
#import "UIImageView+WebCache.h"
#import "QSLoadingView.h"
#import "QSToast.h"
#import "EdgeLabel.h"

@interface ArticleMoreImageTableViewCell ()

@property(nonatomic,strong) UIView *itemView;
@property (nonatomic,strong) UIImageView *articleImage0;
@property (nonatomic,strong) UIImageView *articleImage1;
@property (nonatomic,strong) UIImageView *articleImage2;
@property (nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *readCountLabel;
@property (nonatomic,strong) EdgeLabel *tagBtn;

@property (nonatomic,strong) ArticleModel *articleModel;

@end

@implementation ArticleMoreImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        
        CGFloat imageWidth = (mScreenWidth-30-10)/3;
        CGFloat imageHeight = imageWidth * 3/4;
        
        self.itemView = [[UIView alloc] init];
        [self.contentView addSubview:self.itemView];
        [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.contentView).offset(15);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = @"title";
        self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
//        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        self.titleLabel.numberOfLines = 2;
        [self.titleLabel sizeToFit];
        [self.itemView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemView);
            make.right.equalTo(self.itemView);
            make.top.equalTo(self.itemView);
        }];
        
        self.articleImage0 = [[UIImageView alloc] init];
        self.articleImage0.clipsToBounds = YES;//设置该属性图片不会超过view范围
        [self.articleImage0 setImage:[UIImage imageNamed:@"default_32"]];
        self.articleImage0.contentMode = UIViewContentModeScaleAspectFill;
        [self.itemView addSubview:self.articleImage0];
        [self.articleImage0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(imageWidth,imageHeight));
            make.left.equalTo(self.itemView);
        }];
        
        self.articleImage1 = [[UIImageView alloc] init];
        self.articleImage1.clipsToBounds = YES;//设置该属性图片不会超过view范围
        [self.articleImage1 setImage:[UIImage imageNamed:@"default_32"]];
        self.articleImage1.contentMode = UIViewContentModeScaleAspectFill;
        [self.itemView addSubview:self.articleImage1];
        [self.articleImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(imageWidth,imageHeight));
            make.left.equalTo(self.articleImage0.mas_right).offset(5);
        }];
        
        self.articleImage2 = [[UIImageView alloc] init];
        self.articleImage2.clipsToBounds = YES;//设置该属性图片不会超过view范围
        [self.articleImage2 setImage:[UIImage imageNamed:@"default_32"]];
        self.articleImage2.contentMode = UIViewContentModeScaleAspectFill;
        [self.itemView addSubview:self.articleImage2];
        [self.articleImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(imageWidth,imageHeight));
            make.left.equalTo(self.articleImage1.mas_right).offset(5);
        }];
        
        
        self.tagBtn = [[EdgeLabel alloc] init];
        self.tagBtn.textColor = [UIColor colorWithHexString:@"666666"];
        self.tagBtn.font = [UIFont systemFontOfSize:13];
        [self.itemView addSubview:self.tagBtn];
        [self.tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.articleImage0.mas_bottom).offset(10);
            make.left.equalTo(self.itemView);
            make.bottom.equalTo(self.itemView);
        }];
        
        self.readCountLabel = [[UILabel alloc] init];
        self.readCountLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        self.readCountLabel.font = [UIFont systemFontOfSize:13];
        [self.itemView addSubview:self.readCountLabel];
        [self.readCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.tagBtn);
            make.left.equalTo(self.tagBtn.mas_right).offset(10);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.itemView.mas_bottom).offset(15);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
        
        
    }
    
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    return self;
}

-(void)updateArticleModel:(ArticleModel *)articleModel{
    
    self.articleModel = articleModel;
    
    NSArray<NSString *> *images = [articleModel.articleImgs componentsSeparatedByString:@","];
    
    if (images && images.count>=3) {
        
        [self.articleImage0 sd_setImageWithURL:[NSURL URLWithString:images[0]] placeholderImage:[UIImage imageNamed:@"default_32"] options:0 progress:nil completed:nil];
        
        [self.articleImage1 sd_setImageWithURL:[NSURL URLWithString:images[1]] placeholderImage:[UIImage imageNamed:@"default_32"] options:0 progress:nil completed:nil];
        
        [self.articleImage2 sd_setImageWithURL:[NSURL URLWithString:images[2]] placeholderImage:[UIImage imageNamed:@"default_32"] options:0 progress:nil completed:nil];
    }else{
        [self.articleImage0 setImage:[UIImage imageNamed:@"default_32"]];
    }
    
    if(articleModel.articleTitle){
        self.titleLabel.text = articleModel.articleTitle;
    }
    
    self.readCountLabel.text = [NSString stringWithFormat:@"%@人已阅",articleModel.pageView];
    
    //    if([articleModel.contentType integerValue] == 2){
    //        self.playImage.hidden = NO;
    //    }else{
    //        self.playImage.hidden = YES;
    //    }
    
    
    
    if(articleModel.category && articleModel.category.name && ![articleModel.category.name isEqualToString:@""]){
        self.tagBtn.text = articleModel.category.name;
        [self.readCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.tagBtn);
            make.left.equalTo(self.tagBtn.mas_right).offset(10);
        }];
    }else{
        self.tagBtn.text = @"";
        [self.readCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.tagBtn);
            make.left.equalTo(self.itemView);
        }];
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
