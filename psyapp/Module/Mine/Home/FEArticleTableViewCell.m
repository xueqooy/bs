//
//  FEArticleTableViewCell.m
//  smartapp
//
//  Created by lafang on 2018/8/21.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEArticleTableViewCell.h"
#import "UIColor+Category.h"
#import <Masonry/Masonry.h>
#import "EvaluateService.h"
#import "QSLoadingView.h"
#import "QSToast.h"
#import "HttpErrorManager.h"
#import "UIImage+Category.h"

@interface FEArticleTableViewCell ()

@property (nonatomic,strong) UIImageView *iconImage;
@property (nonatomic,strong) UIImageView *playImage;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIButton *collectBtn;

@property (nonatomic,strong) ArticleDetailsModel *articleModel;

@end

@implementation FEArticleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        
        self.itemView = [[UIView alloc] init];
        self.itemView.userInteractionEnabled = YES;
//        self.itemView.layer.masksToBounds = YES;
        self.itemView.layer.cornerRadius = STWidth(4);
        self.itemView.layer.shadowColor = UIColor.blackColor.CGColor;
        self.itemView.layer.shadowOpacity = 0.1;
        self.itemView.layer.shadowOffset = CGSizeMake(0, 0);
        self.itemView.backgroundColor = UIColor.fe_contentBackgroundColor;
        [self.contentView addSubview:self.itemView];
        [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
        
        self.iconImage = [[UIImageView alloc] init];
        self.iconImage.layer.cornerRadius = STWidth(4);
        self.iconImage.clipsToBounds = YES;
        [self.iconImage setImage:[UIImage imageNamed:@"default_32"]];
        self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.itemView addSubview:self.iconImage];
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemView);
            make.right.equalTo(self.itemView);
            make.top.equalTo(self.itemView);
            make.height.mas_equalTo(([[UIScreen mainScreen] bounds].size.width - 20 * 2) *9 /16);
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
            make.center.equalTo(self.iconImage);
            make.size.mas_equalTo(STSize(32, 32));
        }];
        
        UIImageView *gradientImageVIew = UIImageView.new;
        UIImage *gradientImage = [UIImage getGradientImageWithColors:@[mHexColorA(@"000000", 0), mHexColorA(@"000000", 0.8)] locations:@[@0, @1] startPoint:CGPointMake(mScreenWidth / 2, 0) endPoint:CGPointMake(mScreenWidth / 2, STWidth(41)) imageSize:CGSizeMake(mScreenWidth, STWidth(40))];
        gradientImageVIew.contentMode = UIViewContentModeScaleAspectFill;
        [gradientImageVIew setImage:gradientImage];
        [self.iconImage addSubview:gradientImageVIew];
        [gradientImageVIew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.offset(0);
            make.height.mas_equalTo(STWidth(40));
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = UIColor.whiteColor;
        self.titleLabel.font = STFontBold(16);
        self.titleLabel.numberOfLines = 1;
        [self.titleLabel sizeToFit];
        [gradientImageVIew addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.offset(STWidth(10));
            make.right.offset(STWidth(-15));
        }];
        
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.textColor = UIColor.fe_auxiliaryTextColor;
        self.contentLabel.font = STFontRegular(12);
        self.contentLabel.numberOfLines = 1;
        [self.itemView addSubview:self.contentLabel];
        
        
        self.collectBtn = [[UIButton alloc] init];
        [self.collectBtn addTarget:self action:@selector(buttonCollectEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.collectBtn setTitleColor:UIColor.fe_auxiliaryTextColor forState:UIControlStateNormal];
        self.collectBtn.titleLabel.font = STFontRegular(14);
        [self.collectBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
        self.collectBtn.layer.cornerRadius = 2;
        self.collectBtn.layer.borderWidth = 1;
        self.collectBtn.layer.borderColor = UIColor.fe_separatorColor.CGColor;
        [self.itemView addSubview:self.collectBtn];
        [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImage.mas_bottom).offset(STWidth(10));
            make.right.equalTo(self.itemView).offset(-STWidth(10));
            make.bottom.equalTo(self.itemView).offset(-STWidth(10));
            make.size.mas_equalTo(STSize(76, 32));
        }];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.collectBtn);
            make.left.equalTo(self.itemView).offset(STWidth(10));
        }];
        
    }
    self.contentView.backgroundColor = UIColor.fe_backgroundColor;
    return self;
}

-(void)setModel:(ArticleDetailsModel *)articleModel{
    _articleModel = articleModel;
    if(!articleModel){
        return;
    }
    
    if (articleModel.articleImg && ![articleModel.articleImg isEqualToString:@""]) {
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:articleModel.articleImg] placeholderImage:[UIImage imageNamed:@"default_32"] options:0 progress:nil completed:nil];
    }else{
        [self.iconImage setImage:[UIImage imageNamed:@"default_32"]];
    }
    
    if([NSString isEmptyString:articleModel.articleVideo] == NO){
        self.playImage.hidden = NO;
    }else{
        self.playImage.hidden = YES;
    }
    
    self.titleLabel.text = articleModel.articleTitle ? articleModel.articleTitle : @"";
    self.contentLabel.text = articleModel.category.name ? articleModel.category.name : @"";


}

-(void)buttonCollectEvent{
    [TCSystemFeedbackHelper impactLight];
//    [TCSyste]
    AVQuery *query = [AVQuery queryWithClassName:@"ArticleCollection"];
    [query whereKey:@"userId" equalTo:BSUser.currentUser.objectId];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        if ((error && error.code != 101) || object == nil) return;
       
        NSArray *articles = [object objectForKey:@"articles"];
        NSMutableArray *mArticles;
        if (!articles) {
            return;
        } else {
            mArticles = articles.mutableCopy;
        }
        for (AVObject *pointer in mArticles) {
            if ([pointer.objectId isEqualToString:self.articleModel.articleId]) {
                [QSToast toastWithMessage:@"取消收藏"];
                self.articleModel.favorite = @0;
                [mArticles removeObject:pointer];
                break;
            }
        }
      
        [object setObject:mArticles.copy forKey:@"articles"];
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                if(self->_resultCollect){
                           self->_resultCollect(self.articleModel);
                        }
            }
        }];
    }];
}


@end
