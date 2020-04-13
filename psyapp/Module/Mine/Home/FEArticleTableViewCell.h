//
//  FEArticleTableViewCell.h
//  smartapp
//
//  Created by lafang on 2018/8/21.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleDetailsModel.h"
typedef void(^ArticleCollectResult)(ArticleDetailsModel *articleModel);

@interface FEArticleTableViewCell : UITableViewCell

@property (nonatomic,strong) UIView *itemView;

- (void)setModel:(ArticleDetailsModel *)articleModel;

@property (nonatomic,copy) ArticleCollectResult resultCollect;


@end
