//
//  ArticleDetailsModel.h
//  smartapp
//
//  Created by lafang on 2018/8/25.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "ArticleUser.h"
#import "ArticleTopicInfo.h"
#import "CategoriesModel.h"
@class EvaluationDetailDimensionsModel;
@interface ArticleDetailsModel : FEBaseModel

@property(nonatomic,copy) NSString *articleId;
@property(nonatomic,copy) NSString *articleTitle;
@property(nonatomic,copy) NSString *articleImg;
@property(nonatomic,copy) NSString *articleContent;//内容 富文本
@property(nonatomic,copy) NSString *articleVideo;//文章的视频地址，需要按按算法生成最终可用的地址
@property(nonatomic,copy) NSString *videoId;
@property(nonatomic,strong) NSNumber *sourceType;//文章来源类型：1-原创，2-转载
@property(nonatomic,copy) NSString *sourceName;//文章来源名称，当source_type=2时需要使用
@property(nonatomic,copy) NSString *sourceWebUrl;//文章来源的web地址，当source_type=2时需要使用
@property(nonatomic,copy) NSString *sourceAppUrl;//文章来源的app url scheme，当source_type=2时需要使用
@property(nonatomic,strong) NSNumber *pageView;
@property(nonatomic,strong) NSNumber *pageLike;
@property(nonatomic,strong) NSNumber *pageFavorite;
@property(nonatomic,strong) NSNumber *testCount;
@property(nonatomic,strong) NSNumber *isReferenceTest;
@property(nonatomic,copy) NSString *contentShort;
@property(nonatomic,strong) NSArray *tags;
@property(nonatomic,copy) NSString *source;
@property(nonatomic,copy) NSString *publishDate;
@property(nonatomic,strong) NSNumber *contentType;  //1:文章 2:视频 3：音频
@property(nonatomic,strong) ArticleUser *userData;
@property(nonatomic,strong) NSNumber *favorite;
@property(nonatomic,strong) NSNumber *like;
@property(nonatomic,strong) NSNumber *showComment;
@property(nonatomic,strong) ArticleTopicInfo *topicInfo;
@property(nonatomic,strong) CategoriesModel *category;

@property (nonatomic, copy) NSArray <BSUser *>*thumpUpUsers;
@property (nonatomic, strong) NSNumber *thumpUpNum;
@property (nonatomic, assign) BOOL alreadyThumpUp;

@property (nonatomic, copy) NSArray <EvaluationDetailDimensionsModel *>*dimensions;//文章包含的测评
@property (nonatomic, copy) NSArray <NSDictionary *>*dimension_JSON; //对应dimensions，用于给web传值，由于web端使用的key和服务端定义的相同，不能直接将模型转化为字典
@property (nonatomic, copy) NSString *childExamId; //custom 有childExamId时赋值

//course
@property(nonatomic, strong) NSNumber *mediaTimelong;
@property(nonatomic, strong) NSNumber *hasTest; //是否有测评
@property(nonatomic, strong) NSNumber *inFreeMode;//是否是试读文章

- (instancetype)initWithAVObject:(AVObject *)object;
@end
