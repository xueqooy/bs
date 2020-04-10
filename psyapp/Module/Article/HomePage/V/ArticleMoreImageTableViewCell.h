//
//  ArticleMoreImageTableViewCell.h
//  smartapp
//
//  Created by lafang on 2019/4/3.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArticleMoreImageTableViewCell : UITableViewCell

-(void)updateArticleModel:(ArticleModel *)articleModel;

@end

NS_ASSUME_NONNULL_END
