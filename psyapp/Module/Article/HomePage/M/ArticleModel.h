//
//  ArticleModel.h
//  smartapp
//
//  Created by lafang on 2018/8/25.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "CategoriesModel.h"
#import "TagsModel.h"

@interface ArticleModel : FEBaseModel
//https://www.tapd.cn/22217601/markdown_wikis/view/#1122217601001001937@toc7
@property(nonatomic,strong) NSString *articleTitle;
@property(nonatomic,strong) NSString *articleImg;
@property(nonatomic,strong) NSNumber *pageView;


@property(nonatomic,strong) NSString *articleId;
@property(nonatomic,strong) NSNumber *pageFavorite;
@property(nonatomic,strong) NSNumber *testCount;
@property(nonatomic,strong) NSNumber *isReferenceTest;
@property(nonatomic,strong) NSString *summary;
@property(nonatomic,strong) NSArray *tags;
@property(nonatomic,strong) NSString *source;
@property(nonatomic,strong) NSNumber *sourceType;//文章来源类型：1-原创，2-转载
@property(nonatomic,strong) NSString *publishDate;
@property(nonatomic,strong) NSNumber *contentType;
@property(nonatomic, strong) NSNumber *type;
@property(nonatomic,strong) CategoriesModel *category;
@property(nonatomic, copy) NSString *categoryName;
@property(nonatomic,strong) NSNumber *favorite;
@property(nonatomic,strong) NSNumber *like;
@property(nonatomic,strong) NSString *articleImgs;
@property (nonatomic, strong) NSNumber *pageLike;
@end
