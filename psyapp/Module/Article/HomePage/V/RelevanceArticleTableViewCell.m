//
//  RelevanceArticleTableViewCell.m
//  smartapp
//
//  Created by lafang on 2019/2/14.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "RelevanceArticleTableViewCell.h"
#import "UIColor+Category.h"
#import <Masonry/Masonry.h>
#import "UIView+Extension.h"
#import "UIImageView+WebCache.h"
#import "QSLoadingView.h"
#import "QSToast.h"
#import "EvaluateService.h"
#import "EdgeLabel.h"

@interface RelevanceArticleTableViewCell ()

@property(nonatomic,strong) UIView *itemView;
@property (nonatomic,strong) UIImageView *articleImage;
//@property (nonatomic,strong) UIImageView *playImage;
@property (nonatomic,strong) UILabel *titleLabel;
//@property (nonatomic,strong) UIButton *collectBtn;
@property(nonatomic,strong) UILabel *readCountLabel;
//@property(nonatomic,strong) UIImageView *readCountImage;
@property (nonatomic,strong) UILabel *tagBtn;

@property (nonatomic,strong) ArticleDetailsModel *articleModel;

@end

@implementation RelevanceArticleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        
        self.itemView = [[UIView alloc] init];
        self.itemView.backgroundColor = UIColor.fe_contentBackgroundColor;
        self.itemView.layer.shadowColor = UIColor.blackColor.CGColor;
        self.itemView.layer.shadowOpacity = 0.05;
        self.itemView.layer.shadowOffset = CGSizeMake(0, 0.5);
        self.itemView.layer.cornerRadius = STWidth(4);
        [self.contentView addSubview:self.itemView];
        [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(mScreenWidth - STWidth(30));
//            make.edges.mas_equalTo(STEdgeInsetsAll(10));
            make.left.offset(STWidth(5));
            make.right.offset(-STWidth(5));
            make.top.offset(STWidth(2.5));
            make.bottom.offset(STWidth(-2.5));
        }];
        
        self.articleImage = [[UIImageView alloc] init];
        self.articleImage.clipsToBounds = YES;//设置该属性图片不会超过view范围
        self.articleImage.layer.cornerRadius = STWidth(4);
        
        [self.articleImage setImage:[UIImage imageNamed:@"default_32"]];
        self.articleImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.itemView addSubview:self.articleImage];
        [self.articleImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(STWidth(10));
            make.right.bottom.offset(STWidth(-10));
            make.width.equalTo(_articleImage.mas_height).multipliedBy(1.5);
          
        }];
        

        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = @"title";
        self.titleLabel.textColor = UIColor.fe_titleTextColorLighten;
//        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.titleLabel setFont:STFontBold(16)];
        self.titleLabel.numberOfLines = 3;
        self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.titleLabel sizeToFit];
        [self.itemView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.offset(STWidth(10));
            make.right.equalTo(self.articleImage.mas_left).offset(-STWidth(15));
        }];
        
//        self.collectBtn = [[UIButton alloc] init];
//        [self.collectBtn addTarget:self action:@selector(buttonCollectEvent) forControlEvents:UIControlEventTouchUpInside];
//        [self.collectBtn setBackgroundImage:[UIImage imageNamed:@"fire_recommend_cell_collect_select"] forState:UIControlStateNormal];
//        [self.itemView addSubview:self.collectBtn];
//        [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.articleImage.mas_left).offset(-5);
//            make.bottom.equalTo(self.itemView);
//            make.size.mas_equalTo(CGSizeMake(34, 34));
//        }];
        
        self.tagBtn = [[UILabel alloc] init];
        self.tagBtn.textColor = [UIColor fe_dynamicColorWithDefault:mHexColor(@"#A8ABB3") darkColor:mHexColorA(@"ffffff", 0.45)];
        self.tagBtn.font = STFont(11);
        [self.itemView addSubview:self.tagBtn];
        [self.tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(STWidth(10));
            make.bottom.offset(STWidth(STWidth(-10)));
        }];

        self.readCountLabel = [[UILabel alloc] init];
        self.readCountLabel.textColor = [UIColor fe_dynamicColorWithDefault:mHexColor(@"#A8ABB3") darkColor:mHexColorA(@"ffffff", 0.45)];
        self.readCountLabel.font = STFont(11);;
        [self.itemView addSubview:self.readCountLabel];
        [self.readCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.tagBtn);
            make.right.equalTo(self.articleImage.mas_left).offset(-STWidth(15));
        }];
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
    }
  

    if(![NSString isEmptyString:articleModel.category.name]){
        self.tagBtn.text = articleModel.category.name;
        [self.readCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.tagBtn);
           make.right.equalTo(self.articleImage.mas_left).offset(-STWidth(15));
        }];
    }else{
        self.tagBtn.hidden = @"";
        [self.readCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.tagBtn);
            make.right.equalTo(self.articleImage.mas_left).offset(-STWidth(15));
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
