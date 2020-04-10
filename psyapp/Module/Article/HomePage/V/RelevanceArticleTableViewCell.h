//
//  RelevanceArticleTableViewCell.h
//  smartapp
//
//  Created by lafang on 2019/2/14.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RelevanceArticleTableViewCell : UITableViewCell

-(void)updateArticleModel:(ArticleDetailsModel *)articleModel;


@end

NS_ASSUME_NONNULL_END
