//
//  ReportArticleView.m
//  smartapp
//
//  Created by lafang on 2018/10/22.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEReportRecommendedArticleView.h"


@implementation FEReportRecommendedArticleView {
    NSString *_imageName;
    NSString *_title;
    NSString *_count;
    NSNumber *_type;
}

- (instancetype)initWithImageNamed:(NSString *)imageName title:(NSString *)title readCount:(NSString *)count contentType:(NSNumber *)type {
    self = [super init];
    _imageName = imageName;
    _title = title;
    _count = count;
    _type = type;
    [self build];
    return self;
}

- (void)build {
    UIImageView *articleImageView = [[UIImageView alloc] init];
    articleImageView.layer.cornerRadius = 4;
    articleImageView.clipsToBounds = YES;//设置该属性图片不会超过view范围
    [articleImageView sd_setImageWithURL:[NSURL URLWithString:_imageName] placeholderImage:[UIImage imageNamed:@"fire_default_article_pic"] options:0 progress:nil completed:nil];
    articleImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:articleImageView];
    [articleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.offset(0);
        make.size.mas_equalTo(STSize(120, 80));
    }];
        
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = _title;
    titleLabel.textColor = UIColor.fe_titleTextColorLighten;
    titleLabel.font = STFontBold(16);
    titleLabel.numberOfLines = 3;
    [titleLabel sizeToFit];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.equalTo(articleImageView.mas_left).offset(- [SizeTool width:15]);
        make.top.equalTo(articleImageView);
    }];
    
    if (![NSString isEmptyString:_count]) {
        UILabel *readCountLabel = [[UILabel alloc] init];
           readCountLabel.textColor = UIColor.fe_auxiliaryTextColor;
           readCountLabel.font = [UIFont systemFontOfSize:11];
           readCountLabel.text = [NSString stringWithFormat:@"%@人阅读",_count];
           [self addSubview:readCountLabel];
           [readCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
               make.right.equalTo(titleLabel);
               make.bottom.equalTo(articleImageView);
           }];
    }
    
    if ([_type isEqualToNumber:@2]) {
        UIImageView *videoPlayImageView = [UIImageView new];
        [videoPlayImageView setImage:[UIImage imageNamed:@"fire_video_play"]];
        [articleImageView addSubview:videoPlayImageView];
        [videoPlayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(STSize(25, 25));
            make.center.mas_equalTo(0);
        }];
    }
    
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(articleClick)];
    [self addGestureRecognizer:tapGesturRecognizer];
  
}


-(void)articleClick{
    if(self.reportIndex){
        self.reportIndex(0);
    }

}

@end
