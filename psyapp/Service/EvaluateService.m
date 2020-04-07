//
//  EvaluateService.m
//  app
//
//  Created by linjie on 17/3/11.
//  Copyright © 2017年 jeyie0. All rights reserved.
//

#import "EvaluateService.h"
#import "HttpConfig.h"
#import "UCManager.h"
#import "ConstantConfig.h"
#import "HttpErrorManager.h"

@implementation EvaluateService

+ (NSArray<UIColor *> *) getColorListWithStyle:(NSString *) style {
    return @[[UIColor colorWithHexString:@"#12b2f4"]];
//    NSDictionary<NSString *,NSArray<UIColor *> *> *colorDic= @{@"green":@[[UIColor colorWithHexString:@"#6bcbbe"],[UIColor colorWithHexString:@"#1d9988"]],
//                                                               @"pink":@[[UIColor colorWithHexString:@"#fc8bb3"],[UIColor colorWithHexString:@"#c5406f"]],
//                                                               @"blue":@[[UIColor colorWithHexString:@"#748ce4"],[UIColor colorWithHexString:@"#5267bf"]],
//                                                               @"yellow":@[[UIColor colorWithHexString:@"#ffcf87"],[UIColor colorWithHexString:@"#d39a45"]],
//                                                               @"orange":@[[UIColor colorWithHexString:@"#ffa07b"],[UIColor colorWithHexString:@"#cf5722"]]};;
//    return colorDic[style];
}


+ (void) projectList:(success)success failure:(failure)failure {
    //[QSRequestBase get:URL_PROJECT_LIST success:success failure:failure];
    [QSRequestBase get:URL_PROJECT_LIST success:^(id data) {
        if (success) {
            NSDictionary *respDic = data;
            NSArray *projectArray = respDic[@"data"][@"items"];
            success(projectArray);
        }
    } failure:failure];
}

+ (void) projectListWithChildId:(NSString *)childId success:(success)success failure:(failure) failure {
    NSString *url = URL_PROJECT_ALL;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            NSDictionary *respDic = data;
            NSArray *projectArray = respDic[@"data"][@"items"];
            success(projectArray);
        }
    } failure:failure];
}

+ (void) sceneList:(NSString *)projectId childId:(NSString *) childId success:(success)success failure:(failure) failure {
    NSString *url = URL_SCENE_LIST;
    url = [url stringByReplacingOccurrencesOfString:@"{project_id}" withString:projectId];
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            NSDictionary *respDic = data;
            NSArray *sceneArray = respDic[@"data"][@"items"];
            success(sceneArray);
        }
    } failure:failure];
    
}

+ (void) userSceneLatest:(NSString *)sceneId childId:(NSString *)childId success:(success)success failure:(failure) failure {
    NSString *url = URL_USER_SCENE_LATEST;
    url = [url stringByReplacingOccurrencesOfString:@"{scene_id}" withString:sceneId];
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            NSDictionary *d = data[@"data"];
            BOOL hasReport = d != nil;
            if (d) {
                hasReport = ![d isEqual:[NSNull null]];
            }
            success(@(hasReport));
        }
    } failure:failure];
}

+ (void) sceneDetail:(NSString *)projectId sceneId:(NSString *)sceneId childId:(NSString *) childId success:(success)success failure:(failure) failure {
    
    [self sceneList:projectId childId:childId success:^(id data) {
        if (success) {
            NSArray *sceneArray = data;
            for (NSDictionary *sceneDic in sceneArray) {
                if ([sceneId isEqualToString:sceneDic[@"id"]]) {
                    success(sceneDic);                }
            }
            if (failure) {
                failure(nil);
            }
            //success(projectArray);
        }
    } failure:failure];
}

+ (void) sceneDetail:(NSString *)sceneId childId:(NSString *) childId success:(success)success failure:(failure) failure {
    
    [self projectListWithChildId:childId success:^(id data) {
        for (NSDictionary *projDic in data) {
            for (NSDictionary *sceneDic in projDic[@"items"]) {
                if ([sceneId isEqualToString:sceneDic[@"id"]]) {
                    if (success) {
                        success(sceneDic);
                    }
                }
            }
        }
    } failure:failure];
}

+ (void) recordList:(NSString *) childId sceneId:(NSString *)sceneId success:(success)success failure:(failure) failure {
    NSString *url = URL_RECORD_LIST;
    url = [url stringByReplacingOccurrencesOfString:@"{uid}" withString:[NSString stringWithFormat:@"%li",(long)[UCManager sharedInstance].userInfo.userId.integerValue]];
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    if (sceneId) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&sceneId=%@",sceneId]];
    }
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            NSDictionary *respDic = data;
            NSArray *dataArray = respDic[@"data"][@"items"];
            success(dataArray);
        }
    } failure:failure];
}

//+ (void) topicDetail:(NSString *) topicId success:(success)success failure:(failure) failure {
//    NSString *url = URL_TOPIC_DETAIL;
//    url = [url stringByReplacingOccurrencesOfString:@"{topic_id}" withString:topicId];
//    [QSRequestBase get:url success:^(id data) {
//        if (success) {
//            success(data);
//        }
//    } failure:failure];
//}

+ (void) topicListWithChildId:(NSString *)childId  success:(success)success failure:(failure) failure {
    NSString *url = URL_CHILD_TOPIC_LIST;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}



//-------------------------------------------------------------
//----------------------------begin------------------------------
//---------------------------------------------------------------

//+ (void) initBaseDataWithChildId:(NSString *)childId success:(success)success failure:(failure) failure {
//    //[self topicList:success failure:failure];
//
//    [self topicList:^(id data) {
//        [EvaluateDataManager sharedInstance].topicDic = data;
//        [self topicFollowedWithChildId:childId success:^(id data) {
//            if (success) {
//
//                if (data && [data valueForKey:@"items"] && ((NSArray *)[data valueForKey:@"items"]).count > 0) {
//                    NSArray *selectedTopicArray = (NSArray *)[data valueForKey:@"items"];
//                    NSString *topicId = [selectedTopicArray[0] valueForKey:@"topic_id"];
//                    [EvaluateDataManager sharedInstance].selectedTopicId = topicId;
//                }
//
//                success(data);
//            }
//        } failure:^(NSError *error) {
//            if (failure) {
//                failure(error);
//            }
//        }];
//    } failure:^(NSError *error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
//
//}




//+ (void) topicDetailWithChildId:(NSString *)childId topicId:(NSString *) topicId success:(success)success failure:(failure) failure {
//    NSString *url = URL_TOPIC_DETAIL;
//    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
//    [QSRequestBase get:url success:^(id data) {
//        if (success) {
//            success(data);
//        }
//    } failure:failure];
//}

+ (void) topicFollowedWithChildId:(NSString *) childId success:(success)success failure:(failure) failure {
    NSString *url = URL_TOPIC_FOLLOWED;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+ (void) follwTopicWithChildId:(NSString *)childId topicId:(NSString *) topicId success:(success)success failure:(failure) failure {
    NSString *url = URL_FOLLOW_TOPIC;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{topic_id}" withString:topicId];
    
    //NSDictionary *params = @{@"invite_code":inviteCode,@"username":account,@"password":pwd,@"org_code":orgCode};
    [QSRequestBase post:url parameters:nil success:^(id data) {
        //NSDictionary *respDic = data;
        //NSDictionary *sucDic = respDic[@"data"];
        if (success) {
            success(data);
        }
    } failure:failure];
}

+ (void) beginTopicWithChildId:(NSString *)childId topicId:(NSString *) topicId success:(success)success failure:(failure) failure {
    NSString *url = URL_BEGIN_TOPIC;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{topic_id}" withString:topicId];
    
    [QSRequestBase post:url parameters:nil success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}



+ (void) dimensionListWithChildId:(NSString *) childId topicId:(NSString *)topicId success:(success)success failure:(failure) failure {
    NSString *url = URL_CHILD_TOPIC_DIMENSION_LIST;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    if (topicId) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&topic_id=%@",topicId]];
    }
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+ (void) recommendDimensionListWithChildId:(NSString *) childId topicId:(NSString *)topicId success:(success)success failure:(failure) failure {
    NSString *url = URL_RECOMMEND_DIMENSION_LIST;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{topic_id}" withString:topicId];

    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];

}

+ (void) hotDimensionListWithChildId:(NSString *) childId success:(success)success failure:(failure) failure {
    NSString *url = URL_HOT_DIMENSION_LIST;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+ (void) dimensionRankDataWithChildId:(NSString *) childId topicId:(NSString *)topicId dimensionId:(NSString *)dimensionId factorId:(NSString *)factorId success:(success)success failure:(failure) failure {
    NSString *url = URL_DIMENSION_RANK;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{topic_id}" withString:topicId];
    url = [url stringByReplacingOccurrencesOfString:@"{dimension_id}" withString:dimensionId];
    url = [url stringByReplacingOccurrencesOfString:@"{factor_id}" withString:factorId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+ (void) factorRankReportWithChildId:(NSString *) childId childFactorId:(NSString *)childFactorId success:(success)success failure:(failure) failure {
    NSString *url = URL_FACTOR_RANK_REPORT;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{child_factor_id}" withString:childFactorId];
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];

}

//开始某个分量表
+ (void) startDimensionByDimensionId:(NSString *)dimensionId childId:(NSString *)child_id source:(TCProductType)source childExamId:(NSString *)childExamId success:(success)success failure:(failure)failure {
    NSString *url = TC_URL_POST_DIMENSION_START;
    //课程的childExamId必填
    if (source == TCProductTypeCourse && [NSString isEmptyString:childExamId]) {
        return;
    }
    url = [url stringByReplacingOccurrencesOfString:@"{dimension_id}" withString:dimensionId];
    NSDictionary *param;
    if (source == TCProductTypeUnknown) {
        param = @{
            @"child_id" : child_id
        };
    } else if (source == TCProductTypeCourse) {
        param = @{
            @"child_id" : child_id,
            @"source" : @"2",
            @"child_exam_id" : childExamId
        };
    } else if (source == TCProductTypeTest){
        param = @{
            @"child_id" : child_id,
            @"source" : @"1"
        };
    }
    
    [QSRequestBase post:url parameters:param success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+ (void) factorListWithDimensionId:(NSString *)dimensionId success:(success)success failure:(failure) failure {
    NSString *url = URL_DIMENSION_DETAIL;
    url = [url stringByReplacingOccurrencesOfString:@"{dimension_id}" withString:dimensionId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+ (void) factorListWithChildId:(NSString *) childId dimensionId:(NSString *)dimensionId childDimensionId:(NSString *) childDimensionId success:(success)success failure:(failure) failure {
    NSString *url = URL_CHILD_DIMENSION_FACTOR_LIST;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{dimension_id}" withString:dimensionId];
    url = [url stringByReplacingOccurrencesOfString:@"{child_dimension_id}" withString:childDimensionId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}


//开始因子
+ (void) beginFactorWithChildId:(NSString *) childId examId:(NSString *)examId topicId:(NSString *)topicId dimensionId:(NSString *) dimensionId factorId:(NSString *)factorId success:(success)success failure:(failure) failure {
    NSString *url = URL_START_FACTOR;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{exam_id}" withString:examId];
    url = [url stringByReplacingOccurrencesOfString:@"{topic_id}" withString:topicId];
    url = [url stringByReplacingOccurrencesOfString:@"{dimension_id}" withString:dimensionId];
    url = [url stringByReplacingOccurrencesOfString:@"{factor_id}" withString:factorId];
    [QSRequestBase post:url parameters:nil success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+ (void) questionInfoWithChildId:(NSString *)childId  factorId:(NSString *)factorId childFactorId:(NSString *)childFactorId success:(success)success failure:(failure) failure {
    NSString *url = URL_QUESTION_INFO;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{factor_id}" withString:factorId];
    url = [url stringByReplacingOccurrencesOfString:@"{child_factor_id}" withString:childFactorId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+ (void) saveAnswerWithChildId:(NSString *) childId questionId:(NSString *) questionId answer:(NSDictionary *) answer success:(success)success failure:(failure) failure {
    
    NSString *url = URL_SAVE_QUESTION;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{question_id}" withString:questionId];

    [QSRequestBase post:url parameters:answer success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+ (void) submitExamWithChildId:(NSString *) childId childFactorId:(NSString *)childFactorId costedTime:(NSInteger) timeMils success:(success)success failure:(failure) failure {
    NSString *url = URL_SUBMIT_EXAM;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{child_factor_id}" withString:childFactorId];

    NSDictionary *param = @{@"costed_time":@(timeMils),@"costed_time_token":@"abcdefg"};

    [QSRequestBase post:url parameters:param success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];

}

+ (void) flowerRecordWithSuccess:(success)success failure:(failure) failure {
    [QSRequestBase get:URL_FLOWER_RECORD success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//获取最近测评的量表
+ (void) getDimensionLatest:(NSString *) childId success:(success)success failure:(failure) failure {
    NSString *url = URL_CHILD_DIMENSION_LATEST;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+ (void)topicDimensionsListWithChildId:(NSString *)childId success:(success)success failure:(failure)failure{
    NSString *url = URL_CHILD_TOPIC_LIST_DIMENSION;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+ (void)getReportByRelation:(NSString *)childId examId:(NSString *)examId relationId:(NSString *)relationId relationType:(NSString *)relationType sampleId:(NSString *)sampleId success:(success)success failure:(failure)failure{
    NSString *url = URL_CHILD_TOPIC_REPORT;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{exam_id}" withString:examId];
    url = [url stringByReplacingOccurrencesOfString:@"{relation_id}" withString:relationId];
    url = [url stringByReplacingOccurrencesOfString:@"{relation_type}" withString:relationType];
    url = [url stringByReplacingOccurrencesOfString:@"{sample_id}" withString:sampleId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+ (void)getNoticeInfo:(success)success failure:(failure)failure{
    NSString *url = URL_UPDATE_NOTICE;
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+ (void)getVersionUpdate:(success)success failure:(failure)failure{
    NSString *url = URL_VERSION_UPDATE;
    url = [url stringByReplacingOccurrencesOfString:@"{app_id}" withString:API_APP_ID];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}


/**
 *****************奇思火眼相关*********************
 */

/**
 *获取话题列表带量表
 */
+ (void)getDimensionQuestions:(NSString *)childDimensionId success:(success)success failure:(failure)failure{
    NSString *url = TC_URL_GET_DIMENSION_QUESTIONS;
    url = [url stringByReplacingOccurrencesOfString:@"{child_dimension_id}" withString:childDimensionId];

    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+ (void)getDimensionMergeQuestions:(NSString *)childDimensionId success:(success)success failure:(failure)failure {
    NSString *url = [UGTool replacingStrings:@[@"{child_dimension_id}"] withObj:@[childDimensionId] forURL:TC_URL_GET_DIMENSION_QUESTIONS_MERGE];
    [QSRequestBase get:url success:success failure:failure];
}

/**
 *按状态获取孩子测评的场景列表，包含分量表信息列表（报告界面使用的接口）
 * status 0未完成，1已完成
 */
+(void)getReportByTopicDimensions:(NSString *)childId status:(NSString *)status page:(NSString *)page size:(NSString *)size success:(success)success failure:(failure)failure{
    NSString *url = FE_URL_TOPIC_DIMENSION_REPORTS;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{status}" withString:status];
    url = [url stringByReplacingOccurrencesOfString:@"{page}" withString:page];
    url = [url stringByReplacingOccurrencesOfString:@"{size}" withString:size];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+(void)saveDimensionQuestion:(NSString *)childDimensionId answer:(NSDictionary *)answer success:(success)success failure:(failure)failure{
    
    NSString *url = TC_URL_POST_DIMENSION_SAVE;
    url = [url stringByReplacingOccurrencesOfString:@"{child_dimension_id}" withString:childDimensionId];
    
    [QSRequestBase post:url parameters:answer success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
    
}

+ (void)submitDimensionQuestion:(NSString *)childDimensionId answer:(NSDictionary *)answer success:(success)success failure:(failure)failure{
    
    NSString *url = TC_URL_POST_DIMENSION_SUBMIT;
    url = [url stringByReplacingOccurrencesOfString:@"{child_dimension_id}" withString:childDimensionId];
    
    [QSRequestBase post:url parameters:answer success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//获取文章推荐测评
+ (void)getArticleRecommendEvaluate:(NSString *)childId topicId:(NSString *)topicId dimensionId:(NSString *)dimensionId success:(success)success failure:(failure) failure{
    NSString *url = FE_URL_ARTICLE_EVALUATE;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{topic_id}" withString:topicId];
    url = [url stringByReplacingOccurrencesOfString:@"{dimension_id}" withString:dimensionId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+ (void)getEvaluationsHistoryWithDimensionID:(NSString *)dimensionID childID:(NSString *)childID success:(success)success failure:(failure)failure{
    NSString *url = [UGTool replacingStrings:@[@"{dimension_id}", @"{child_id}"] withObj:@[dimensionID, childID] forURL:FE_URL_GET_EVALUATIONS_HISTORY];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+(void)articleCategories:(success)success failure:(failure)failure{
    NSString *URLString = [UGTool replacingStrings:@[@"period={period}",UCManager.sharedInstance.isVisitorPattern?@"child_id={child_id}": @"{child_id}", @"{client_type}", @"{type}"] withObj:@[@"", UCManager.sharedInstance.isVisitorPattern? @"" : UCManager.sharedInstance.currentChild.childId, @"2", @(1)] forURL:TC_URL_GET_PRODUCT_CATEGORY];
    
    [QSRequestBase get:URLString success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+(void)articleHots:(NSString *)page size:(NSString *)size success:(success)success failure:(failure)failure{
    NSString *url = FE_ARTICLE_HOT_LIST;
    url = [url stringByReplacingOccurrencesOfString:@"{page}" withString:page];
    url = [url stringByReplacingOccurrencesOfString:@"{size}" withString:size];
    if (UCManager.sharedInstance.isVisitorPattern == NO) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&child_id=%@",UCManager.sharedInstance.currentChild.childId]];
    }
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+(void)articleAllList:(NSString *)page size:(NSString *)size filter:(NSString *)filter categoryId:(NSString *)categoryId success:(success)success failure:(failure)failure{
    NSString *url = FE_ARTICLE_ALL_LIST;
    url = [url stringByReplacingOccurrencesOfString:@"{page}" withString:page];
    url = [url stringByReplacingOccurrencesOfString:@"{size}" withString:size];
    url = [url stringByReplacingOccurrencesOfString:@"{filter}" withString:filter];
    url = [url stringByReplacingOccurrencesOfString:@"{category_id}" withString:categoryId];
    if (UCManager.sharedInstance.isVisitorPattern == NO) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&child_id=%@",UCManager.sharedInstance.currentChild.childId]];
    }
    url = [url stringByAppendingString:[NSString stringWithFormat:@"&visitor=%@",(UCManager.sharedInstance.isVisitorPattern ? @"1" : @"0")]];
    url = [url stringByAppendingString:@"&client_type=2"];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+(void)articleListByCategoryId:(NSString *)page size:(NSString *)size categoryId:(NSString *)categoryId success:(success)success failure:(failure)failure{
    
}

+(void)articleDetails:(NSString *)articleId childExamId:(NSString *)childExamId success:(success)success failure:(failure)failure{
    NSString *url = FE_ARTICLE_DETAILS;
    url = [url stringByReplacingOccurrencesOfString:@"{article_id}" withString:articleId];
    if (![NSString isEmptyString:childExamId]) {
        url = [NSString stringWithFormat:@"%@?child_exam_id=%@",url,childExamId];
    }
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}



+(void)articleCollect:(NSString *)articleId success:(success)success failure:(failure)failure{
    NSString *url = FE_ARTICLE_COLLECT;
    url = [url stringByReplacingOccurrencesOfString:@"{article_id}" withString:articleId];
    
    [QSRequestBase post:url parameters:nil success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+(void)articleLike:(NSString *)articleId success:(success)success failure:(failure)failure{
    NSString *url = FE_ARTICLE_LIKE;
    url = [url stringByReplacingOccurrencesOfString:@"{article_id}" withString:articleId];
    
    [QSRequestBase post:url parameters:nil success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+(void)articleCollectList:(NSString *)userId page:(NSInteger)page size:(NSInteger)size success:(success)success failure:(failure)failure{
    NSString *url = FE_ARTICLE_CLOOECT_LIST;
    url = [url stringByReplacingOccurrencesOfString:@"{user_id}" withString:userId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+(void)articleCommentList:(NSString *)articleId type:(NSInteger)type page:(NSInteger)page size:(NSInteger)size success:(success)success failure:(failure)failure{
    NSString *url = FE_ARTICLE_COMMENT_LIST_PAGE;
    url = [url stringByReplacingOccurrencesOfString:@"{article_id}" withString:articleId];
    url = [url stringByReplacingOccurrencesOfString:@"{type}" withString:[NSString stringWithFormat:@"%li",(long)type]];
    url = [url stringByReplacingOccurrencesOfString:@"{page}" withString:[NSString stringWithFormat:@"%li",(long)page]];
    url = [url stringByReplacingOccurrencesOfString:@"{size}" withString:[NSString stringWithFormat:@"%li",(long)size]];
    url = [url stringByAppendingString:@"&comment_from=2"];

    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}



//评论留言-type=0文章 type=1任务
+(void)articleComment:(NSString *)articleId commentInfo:(NSString *)commentInfo type:(NSInteger)type success:(success)success failure:(failure)failure{
    NSString *url = FE_ARTICLE_COMMENT;
    url = [url stringByReplacingOccurrencesOfString:@"{article_id}" withString:articleId];
    NSDictionary *params = @{
                             @"comment_info":commentInfo,
                             @"type":[NSString stringWithFormat:@"%li",(long)type],
                             @"comment_from" : @"2"
                             };
    

    [QSRequestBase post:url parameters:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

/**
 * compareId 对比样本ID( 0-全国，1- 八大区，2-省，3-市，4-区 5-学校，6-年级，7-班级)
 */
+(void)getReportWithRelation:(NSString *)childExamId relationId:(NSString *)relationId relationType:(NSString *)relationType compareId:(NSString *)compareId success:(success)success failure:(failure)failure{
    NSString *url = FE_URL_CHILD_REPORTS;
    url = [url stringByReplacingOccurrencesOfString:@"{child_exam_id}" withString:childExamId];
    url = [url stringByReplacingOccurrencesOfString:@"{relation_id}" withString:relationId];
    url = [url stringByReplacingOccurrencesOfString:@"{relation_type}" withString:relationType];
    url = [url stringByReplacingOccurrencesOfString:@"{compare_id}" withString:compareId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//获取孩子动态报告
+(void)getChildReportWithRelation:(NSString *)childExamId relationId:(NSString *)relationId relationType:(NSString *)relationType sampleId:(NSString *)sampleId success:(success)success failure:(failure)failure{
    NSString *url = FE_URL_CHILD_DYNA_REPORTS;
    url = [url stringByReplacingOccurrencesOfString:@"{child_exam_id}" withString:childExamId];
    url = [url stringByReplacingOccurrencesOfString:@"{relation_id}" withString:relationId];
    url = [url stringByReplacingOccurrencesOfString:@"{relation_type}" withString:relationType];
    url = [url stringByReplacingOccurrencesOfString:@"{sample_id}" withString:sampleId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//获取孩子测评列表【当前有效的测评，并返回测评下的场景列表】
+(void)getEvaluateList:(NSString *)childId success:(success)success failure:(failure)failure{
    NSString *url = FE_ADJECTIVE_EVALUATE;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//历史测评列表
+(void)getEvaluateRecord:(NSString *)childId page:(NSInteger)page size:(NSInteger)size success:(success)success failure:(failure)failure{
    NSString *url = FE_RECORD_EVALUATE;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{page}" withString:[NSString stringWithFormat:@"%li",page]];
    url = [url stringByReplacingOccurrencesOfString:@"{size}" withString:[NSString stringWithFormat:@"%li",size]];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//历史专题列表
+(void)getSeminarRecord:(NSString *)childId page:(NSInteger)page size:(NSInteger)size success:(success)success failure:(failure)failure{
    NSString *url = FE_SEMINAR_EVALUATE;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{page}" withString:[NSString stringWithFormat:@"%li",(long)page]];
    url = [url stringByReplacingOccurrencesOfString:@"{size}" withString:[NSString stringWithFormat:@"%li",(long)size]];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+(void)getEvaluateRecordDetail:(NSString *)childId examId:(NSString *)examId success:(success)success failure:(failure)failure{
    NSString *url = FE_RECORD_DETAIL_EVALUATE;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{exam_id}" withString:examId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//page={page}&size={size}&child_exam_id={child_exam_id}&relation_id={relation_id}&relation_type={relation_type}&compare_id={compare_id}

//获取孩子个人报告的推荐文章
+(void)getTestReportRecommendByDimensionId:(NSString *)dimensionId childExamId:(NSString *)childExamId size:(NSNumber *)size page:(NSNumber *)page success:(success)success failure:(failure)failure {
    NSString *url = TC_URL_GET_TEST_REPORT_RECOMMEND;
    url = [url stringByReplacingOccurrencesOfString:@"{dimension_id}" withString:dimensionId];
//    url = [url stringByReplacingOccurrencesOfString:@"{child_exam_id}" withString:childExamId];
    url = [url stringByReplacingOccurrencesOfString:@"{size}" withString:[NSString stringWithFormat:@"%@", size]];
    url = [url stringByReplacingOccurrencesOfString:@"{page}" withString:[NSString stringWithFormat:@"%@", page]];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+(void)getReportWithPast:(NSString *)childId topicId:(NSString *)topicId success:(success)success failure:(failure)failure{
    NSString *url = FE_URL_REPORTS_PAST;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{topic_id}" withString:topicId];

    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+(void)getVideoPlayerUrlByALi:(NSString *)videoId sign:(NSString *)sign t:(NSString *)t success:(success)success failure:(failure) failure{
    NSString *url = FE_URL_VIDEO_PATH;
    url = [url stringByReplacingOccurrencesOfString:@"{video_id}" withString:videoId];
    url = [url stringByReplacingOccurrencesOfString:@"{sign}" withString:sign];
    url = [url stringByReplacingOccurrencesOfString:@"{t}" withString:t];
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

////获取专题海报接口 [GET] /v2/api/children/{child_id}/seminars
+(void)getSeminars:(NSString *)childId success:(success)success failure:(failure) failure{
    NSString *url = FE_URL_SEMINARS;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+ (void)getDimensionEvaluateTitleListWithSuccess:(success)success failure:(failure) failure {
    [QSRequestBase get:FE_URL_GET_DIMENSION_EVALUATE_TITLE_LIST success:success failure:failure];
}

+ (void)getDimensionEvaluatesWithTitleId:(NSString *)titleId uniqueId:(NSString *)uniqueId success:(success)success failure:(failure)failure {
    NSString *url = [UGTool replacingStrings:@[@"{title_id}", @"{unique_id}"] withObj:@[titleId, uniqueId] forURL:FE_URL_GET_DIMENSION_EVALUATES];
    [QSRequestBase get:url success:success failure:failure];
}

+ (void)requestDimensionDetailDataWithDimensionId:(NSString *)dimensionId childExamId:(NSString *)childExamId childId:(NSString *)childId success:(success)success failure:(failure)failure{
    if ([NSString isEmptyString:dimensionId]) return;
    NSString *url;
    if ([NSString isEmptyString:childId]) {
        url  = [UGTool replacingStrings:@[@"{dimension_id}"] withObj:@[dimensionId] forURL:FE_URL_DIMENSION_DETAIL];
        url = [url stringByReplacingOccurrencesOfString:@"?child_id={child_id}" withString:@""];
    } else {
       url  = [UGTool replacingStrings:@[@"{dimension_id}", @"{child_id}"] withObj:@[dimensionId, childId] forURL:FE_URL_DIMENSION_DETAIL];
    }
    
    if (![NSString isEmptyString:childExamId]) {
        if ([NSString isEmptyString:childId]) {
            url = [UGTool putParams:@{@"child_exam_id" : childExamId} forURL:url];
        } else {
            url = [NSString stringWithFormat:@"%@&child_exam_id=%@", url, childExamId];
        }
    }
    [QSRequestBase get:url success:success failure:failure];
}


+ (void)getSearchResultByFilter:(NSString *)filter type:(NSInteger)type page:(NSInteger)page size:(NSInteger)size onSuccess:(success)success failure:(failure)failure {
    if (filter == nil) return;
    filter = [filter stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'\"();:@&=+$,/?%#[]{}% "].invertedSet];
    NSString *URLString = [UGTool replacingStrings:@[@"{page}", @"{size}", @"{type}", @"{filter}"] withObj:@[@(page), @(size), @(type), filter] forURL:TC_URL_GET_DISCOVERY_SEARCH];
    if (!UCManager.sharedInstance.isVisitorPattern) {
        URLString = [URLString stringByAppendingFormat:@"&child_id=%@", UCManager.sharedInstance.currentChild.childId];
    }
    [QSRequestBase get:URLString success:success failure:failure];
}

+ (void)getTestReportRecommendProductByDimensionId:(NSString *)dimensionId onSuccess:(success)success failure:(failure)failure {
    NSString *URLString = [UGTool replacingStrings:@[@"{dimension_id}"] withObj:@[dimensionId] forURL:TC_URL_GET_TEST_REPORT_RECOMMEND_PRODUCT];
    [QSRequestBase get:URLString success:success failure:failure];
}

//评价管理-用户评价
+(void)commitReportJudge:(NSString *)itemId refId:(NSString *)refId childId:(NSString *)childId success:(success)success failure:(failure) failure{
    if ([NSString isEmptyString:itemId]) {
        mLog(@"评价错误:itemId为空");
        return;
    }
    NSString *url = FE_URL_COMMIT_REPORT_EVALUATE;
    url = [url stringByReplacingOccurrencesOfString:@"{item_id}" withString:itemId];
    url = [url stringByReplacingOccurrencesOfString:@"{ref_id}" withString:refId];
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
 
    [QSRequestBase post:url parameters:nil success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//评价管理-获取评价内容列表
+(void)getReportJudge:(NSString *)refId type:(NSString *)type childId:(NSString *)childId titleId:(NSString *)titleId success:(success)success failure:(failure) failure{
    
    NSString *url = FE_URL_REPORT_EVALUATE;
    
    url = [url stringByReplacingOccurrencesOfString:@"{ref_id}" withString:refId];
    url = [url stringByReplacingOccurrencesOfString:@"{type}" withString:type];
    if ([NSString isEmptyString:childId]) {
        url = [url stringByReplacingOccurrencesOfString:@"&child_id={child_id}" withString:@""];
    } else {
        url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    }
    url = [url stringByReplacingOccurrencesOfString:@"{title_id}" withString:titleId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+(void)getPersonalReport:(NSString *)childExamId  relationId:(NSString *)relationId relationType:(NSString *)relationType compareId:(NSString *)compareId success:(success)success failure:(failure) failure{
    
    NSString *url = FE_URL_CAREER_REPORT;
    
    url = [url stringByReplacingOccurrencesOfString:@"{child_exam_id}" withString:childExamId];
    url = [url stringByReplacingOccurrencesOfString:@"{relation_id}" withString:relationId];
    url = [url stringByReplacingOccurrencesOfString:@"{relation_type}" withString:relationType];
    url = [url stringByReplacingOccurrencesOfString:@"{compare_id}" withString:compareId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+ (void)getDimensionReportByChildDimensionId:(NSString *)childDimensionId success:(success)success failure:(failure)failure {
    NSString *url = TC_URL_GET_DIMENSION_REPORT;
       
   url = [url stringByReplacingOccurrencesOfString:@"{child_dimension_id}" withString:childDimensionId];
  
   [QSRequestBase get:url success:success failure:failure];
}
@end
