//
//  EvaluateService.h
//  app
//
//  Created by linjie on 17/3/11.
//  Copyright © 2017年 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSRequestBase.h"
#import "UIColor+Category.h"

@interface EvaluateService : NSObject

+ (NSArray<UIColor *> *) getColorListWithStyle:(NSString *) style;

+ (void) projectList:(success)success failure:(failure) failure;

+ (void) projectListWithChildId:(NSString *)childId success:(success)success failure:(failure) failure;

+ (void) sceneList:(NSString *)projectId childId:(NSString *) childId success:(success)success failure:(failure) failure;

+ (void) userSceneLatest:(NSString *)sceneId childId:(NSString *)childId success:(success)success failure:(failure) failure;

+ (void) sceneDetail:(NSString *)projectId sceneId:(NSString *)sceneId childId:(NSString *) childId success:(success)success failure:(failure) failure;

+ (void) sceneDetail:(NSString *)sceneId childId:(NSString *) childId success:(success)success failure:(failure) failure;

+ (void) recordList:(NSString *) childId sceneId:(NSString *)sceneId success:(success)success failure:(failure) failure;

+ (void) getNoticeInfo:(success)success failure:(failure) failure;

+ (void) getVersionUpdate:(success)success failure:(failure) failure;

//+ (void) topicDetail:(NSString *) topicId success:(success)success failure:(failure) failure;




//-------------------------------------------------------------
//----------------------------begin------------------------------
//---------------------------------------------------------------

+ (void) initBaseDataWithChildId:(NSString *)childId success:(success)success failure:(failure) failure;

+ (void) topicListWithChildId:(NSString *)childId  success:(success)success failure:(failure) failure;

+ (void) topicList:(success)success failure:(failure) failure;

//+ (void) topicDetailWithChildId:(NSString *)childId topicId:(NSString *) topicId success:(success)success failure:(failure) failure;


+ (void) follwTopicWithChildId:(NSString *)childId topicId:(NSString *) topicId success:(success)success failure:(failure) failure;

+ (void) topicFollowedWithChildId:(NSString *) childId success:(success)success failure:(failure) failure;

+ (void) beginTopicWithChildId:(NSString *)childId topicId:(NSString *) topicId success:(success)success failure:(failure) failure;


+ (void) dimensionListWithChildId:(NSString *) childId topicId:(NSString *)topicId success:(success)success failure:(failure) failure;

+ (void) recommendDimensionListWithChildId:(NSString *) childId topicId:(NSString *)topicId success:(success)success failure:(failure) failure;

+ (void) hotDimensionListWithChildId:(NSString *) childId success:(success)success failure:(failure) failure;

+ (void) dimensionRankDataWithChildId:(NSString *) childId topicId:(NSString *)topicId dimensionId:(NSString *)dimensionId factorId:(NSString *)factorId success:(success)success failure:(failure) failure;

+ (void) factorRankReportWithChildId:(NSString *) childId childFactorId:(NSString *)childFactorId success:(success)success failure:(failure) failure;

//开始某个分量表
+ (void) startDimensionByDimensionId:(NSString *)dimensionId childId:(NSString *)child_id source:(TCProductType)source childExamId:(NSString *)childExamId success:(success)success failure:(failure) failure;

+ (void) factorListWithDimensionId:(NSString *)dimensionId success:(success)success failure:(failure) failure;

+ (void) factorListWithChildId:(NSString *) childId dimensionId:(NSString *)dimensionId childDimensionId:(NSString *) childDimensionId success:(success)success failure:(failure) failure ;

//开始因子
+ (void) beginFactorWithChildId:(NSString *) childId examId:(NSString *)examId topicId:(NSString *)topicId dimensionId:(NSString *) dimensionId factorId:(NSString *)factorId success:(success)success failure:(failure) failure;

+ (void) questionInfoWithChildId:(NSString *)childId  factorId:(NSString *)factorId childFactorId:(NSString *)childFactorId success:(success)success failure:(failure) failure;

+ (void) saveAnswerWithChildId:(NSString *) childId questionId:(NSString *) questionId answer:(NSDictionary *) answer success:(success)success failure:(failure) failure;

+ (void) submitExamWithChildId:(NSString *) childId childFactorId:(NSString *)childFactorId costedTime:(NSInteger) timeMils success:(success)success failure:(failure) failure;


+ (void) flowerRecordWithSuccess:(success)success failure:(failure) failure;

+ (void) getDimensionLatest:(NSString *) childId success:(success)success failure:(failure) failure;
//获取孩子主题列表带量表列表
+ (void) topicDimensionsListWithChildId:(NSString *)childId success:(success)success failure:(failure) failure;

//获取报告
+ (void) getReportByRelation:(NSString *)childId examId:(NSString *)examId relationId:(NSString *)relationId relationType:(NSString *)relationType sampleId:(NSString *)sampleId success:(success)success failure:(failure) failure;

+ (void)getEvaluationsHistoryWithDimensionID:(NSString *)dimensionID childID:(NSString *)childID success:(success)success failure:(failure) failure;;

/**
 *************奇思火眼相关******************
 */

//获取量表下题目列表
+ (void) getDimensionQuestions:(NSString *)childDimensionId  success:(success)success failure:(failure) failure;

//获取合并题目
+ (void)getDimensionMergeQuestions:(NSString *)childDimensionId success:(success)success failure:(failure) failure;

//按状态获取孩子测评的场景列表，包含分量表信息列表（报告界面使用的接口）
+ (void)getReportByTopicDimensions:(NSString *)childId status:(NSString *)status page:(NSString *)page size:(NSString *)size success:(success)success failure:(failure) failure;

//保存孩子分量表下变更新答题信息列表
+ (void)saveDimensionQuestion:(NSString *)childDimensionId answer:(NSDictionary *)answer success:(success)success failure:(failure) failure;

//提交孩子分量表
+ (void)submitDimensionQuestion:(NSString *)childDimensionId answer:(NSDictionary *)answer success:(success)success failure:(failure) failure;

//获取文章推荐测评
+ (void)getArticleRecommendEvaluate:(NSString *)childId topicId:(NSString *)topicId dimensionId:(NSString *)dimensionId success:(success)success failure:(failure) failure;

//文章-分类列表
+ (void)articleCategories:(success)success failure:(failure) failure;

//文章-热门文章列表
+ (void)articleHots:(NSString *)page size:(NSString *)size success:(success)success failure:(failure) failure;

//文章-所有文章列表
+ (void)articleAllList:(NSString *)page size:(NSString *)size filter:(NSString *)filter categoryId:(NSString *)categoryId success:(success)success failure:(failure) failure;

//文章-指定文章列表
+ (void)articleListByCategoryId:(NSString *)page size:(NSString *)size categoryId:(NSString *)categoryId success:(success)success failure:(failure) failure;

//文章-文章详情 (课程文章传childExamId,发现传nil)
+ (void)articleDetails:(NSString *)articleId childExamId:(NSString *)childExamId success:(success)success failure:(failure) failure;

//文章-文章收藏
+ (void)articleCollect:(NSString *)articleId success:(success)success failure:(failure) failure;

//文章-文章点赞
+ (void)articleLike:(NSString *)articleId success:(success)success failure:(failure) failure;

//文章-文章收藏列表
+ (void)articleCollectList:(NSString *)userId page:(NSInteger)page size:(NSInteger)size success:(success)success failure:(failure) failure;

//获取文章评论列表
+ (void)articleCommentList:(NSString *)articleId type:(NSInteger)type page:(NSInteger)page size:(NSInteger)size success:(success)success failure:(failure) failure;

//文章评论
+ (void)articleComment:(NSString *)articleId commentInfo:(NSString *)commentInfo type:(NSInteger)type success:(success)success failure:(failure) failure;


//获取报告
+(void)getReportWithRelation:(NSString *)childExamId relationId:(NSString *)relationId relationType:(NSString *)relationType compareId:(NSString *)compareId success:(success)success failure:(failure) failure;

//获取孩子测评列表【当前有效的测评，并返回测评下的场景列表】
+(void)getEvaluateList:(NSString *)childId success:(success)success failure:(failure) failure;

//【我的智评】历史测评列表
+(void)getEvaluateRecord:(NSString *)childId page:(NSInteger)page size:(NSInteger)size success:(success)success failure:(failure) failure;

//【我的智评】历史专题列表
+(void)getSeminarRecord:(NSString *)childId page:(NSInteger)page size:(NSInteger)size success:(success)success failure:(failure) failure;

//【我的智评】测评历史中，某一个测评下的场景列表
+(void)getEvaluateRecordDetail:(NSString *)childId examId:(NSString *)examId success:(success)success failure:(failure) failure;

//获取孩子个人报告(动态)
+(void)getChildReportWithRelation:(NSString *)childExamId relationId:(NSString *)relationId relationType:(NSString *)relationType sampleId:(NSString *)sampleId success:(success)success failure:(failure) failure;

//获取报告推荐文章
+(void)getTestReportRecommendByDimensionId:(NSString *)dimensionId childExamId:(NSString *)childExamId size:(NSNumber *)size page:(NSNumber *)page success:(success)success failure:(failure) failure;

//获取往期报告
+(void)getReportWithPast:(NSString *)childId topicId:(NSString *)topicId success:(success)success failure:(failure) failure;

+(void)getVideoPlayerUrlByALi:(NSString *)videoId sign:(NSString *)sign t:(NSString *)t success:(success)success failure:(failure) failure;

//获取专题海报接口
+(void)getSeminars:(NSString *)childId success:(success)success failure:(failure) failure;

//获取评分类型列表
+ (void)getDimensionEvaluateTitleListWithSuccess:(success)success failure:(failure) failure;

//获取量表评分
+ (void)getDimensionEvaluatesWithTitleId:(NSString *)titleId uniqueId:(NSString *)uniqueId success:(success)success failure:(failure) failure;

//获取量表详情
+ (void)requestDimensionDetailDataWithDimensionId:(NSString *)dimensionId childExamId:(NSString *)childExamId childId:(NSString *)childId success:(success)success failure:(failure) failure;


+ (void)getSearchResultByFilter:(NSString *)filter type:(NSInteger)type page:(NSInteger)page size:(NSInteger)size onSuccess:(success)success failure:(failure) failure;
+ (void)getTestReportRecommendProductByDimensionId:(NSString *)dimensionId onSuccess:(success)success failure:(failure) failure;

+(void)commitReportJudge:(NSString *)itemId refId:(NSString *)refId childId:(NSString *)childId success:(success)success failure:(failure) failure;

+(void)getReportJudge:(NSString *)refId type:(NSString *)type childId:(NSString *)childId titleId:(NSString *)titleId success:(success)success failure:(failure) failure;

+(void)getPersonalReport:(NSString *)childExamId  relationId:(NSString *)relationId relationType:(NSString *)relationType compareId:(NSString *)compareId success:(success)success failure:(failure) failure;

+ (void)getDimensionReportByChildDimensionId:(NSString *)childDimensionId success:(success)success failure:(failure)failure;
@end
