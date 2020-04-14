//
//  ArticleVideoTableViewCell.m
//  smartapp
//
//  Created by lafang on 2019/4/3.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "ArticleVideoTableViewCell.h"
#import "UIColor+Category.h"
#import <Masonry/Masonry.h>
#import "UIView+Extension.h"
#import "UIImageView+WebCache.h"
#import "QSLoadingView.h"
#import "QSToast.h"
#import "EdgeLabel.h"

@interface ArticleVideoTableViewCell ()

@property(nonatomic,strong) UIView *itemView;
@property (nonatomic,strong) UIImageView *articleImage;
@property (nonatomic,strong) UIImageView *playImage;
@property (nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *readCountLabel;
@property (nonatomic,strong) EdgeLabel *tagBtn;

@property (nonatomic,strong) ArticleDetailsModel *articleModel;

@end

@implementation ArticleVideoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        
        self.itemView = [[UIView alloc] init];
        self.itemView.backgroundColor = UIColor.fe_contentBackgroundColor;

        [self.contentView addSubview:self.itemView];
        [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(STWidth(15));
            make.right.equalTo(self.contentView).offset(-STWidth(15));
            make.top.equalTo(self.contentView).offset(STWidth(15));
            make.bottom.equalTo(self.contentView).offset(STWidth(-15));
        }];
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = UIColor.fe_titleTextColorLighten;
//        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.titleLabel setFont:STFontBold(16)];
        self.titleLabel.numberOfLines = 2;
        [self.titleLabel sizeToFit];
        [self.itemView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemView);
            make.right.equalTo(self.itemView);
            make.top.equalTo(self.itemView);
        }];
        
        self.articleImage = [[UIImageView alloc] init];
        self.articleImage.clipsToBounds = YES;//设置该属性图片不会超过view范围
        [self.articleImage setImage:[UIImage imageNamed:@"default_32"]];
        self.articleImage.contentMode = UIViewContentModeScaleAspectFill;
        self.articleImage.layer.cornerRadius = STWidth(4);
        [self.itemView addSubview:self.articleImage];
        [self.articleImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(STWidth(15));
            make.size.mas_equalTo(CGSizeMake(mScreenWidth-STWidth(30), (mScreenWidth-STWidth(30))*(9.f/16.f)));
            make.centerX.equalTo(self.itemView);
        }];
        
        self.playImage = [[UIImageView alloc] init];
        self.playImage.layer.cornerRadius = STWidth(16);
        self.playImage.layer.shadowColor = UIColor.blackColor.CGColor;
        self.playImage.layer.shadowOpacity = 0.1;
        self.playImage.layer.shadowOffset = CGSizeMake(0, 0);
        self.playImage.backgroundColor = mHexColorA(@"000000", 0.3);
        [self.playImage setImage:[UIImage imageNamed:@"fire_video_play"]];
        [self.itemView addSubview:self.playImage];
        [self.playImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.articleImage);
            make.size.mas_equalTo(STSize(32, 32));
        }];
        
        
        self.tagBtn = [[EdgeLabel alloc] init];
        self.tagBtn.textColor = [UIColor fe_dynamicColorWithDefault:mHexColor(@"#A8ABB3") darkColor:mHexColorA(@"ffffff", 0.45)];;
        self.tagBtn.font = STFont(11);
        [self.itemView addSubview:self.tagBtn];
        [self.tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.articleImage.mas_bottom).offset(STWidth(10));
            make.left.equalTo(self.itemView);
            make.bottom.equalTo(self.itemView);
        }];
        
        self.readCountLabel = [[UILabel alloc] init];
        self.readCountLabel.textColor = [UIColor fe_dynamicColorWithDefault:mHexColor(@"#A8ABB3") darkColor:mHexColorA(@"ffffff", 0.45)];;
        self.readCountLabel.font = STFont(11);
        [self.itemView addSubview:self.readCountLabel];
        [self.readCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.tagBtn);
            make.right.equalTo(_articleImage);
        }];
        
//        UIView *lineView = [[UIView alloc] init];
//        lineView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
//        [self.contentView addSubview:lineView];
//        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView).offset(15);
//            make.right.equalTo(self.contentView).offset(-15);
//            make.top.equalTo(self.itemView.mas_bottom).offset(15);
//            make.bottom.equalTo(self.contentView);
//            make.height.mas_equalTo(0.5);
//        }];
//
        self.backgroundColor = UIColor.fe_backgroundColor;

    }
    
    
    return self;
}

-(void)updateArticleModel:(ArticleDetailsModel *)articleModel{
    self.articleModel = articleModel;
    
    if (articleModel.articleImg && ![articleModel.articleImg isEqualToString:@""]) {
        [self.articleImage sd_setImageWithURL:[NSURL URLWithString:articleModel.articleImg] placeholderImage:[UIImage imageNamed:@"default_32"] options:0 progress:nil completed:nil];
    }else{
        [self.articleImage setImage:[UIImage imageNamed:@"default_32"]];
    }
    
    if(articleModel.articleTitle){
        self.titleLabel.text = articleModel.articleTitle;
    }
    
    if (articleModel.pageView) {
        self.readCountLabel.text = [NSString stringWithFormat:@"%@ 阅读",articleModel.pageView];

    } else {
        self.readCountLabel.text = @"";
    }
    
//    if([articleModel.contentType integerValue] == 2){
//        self.playImage.hidden = NO;
//    }else{
//        self.playImage.hidden = YES;
//    }
    
   
    
    if(articleModel.category && articleModel.category.name && ![articleModel.category.name isEqualToString:@""]){
        self.tagBtn.text = articleModel.category.name;
    
    }else{
        self.tagBtn.text = @"";

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
