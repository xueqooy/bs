//
//  CareerService.m
//  smartapp
//
//  Created by lafang on 2019/2/20.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "CareerService.h"
#import "YTKKeyValueStore.h"
#import "ConstantConfig.h"
#import "UCManager.h"
#import "HttpErrorManager.h"

@implementation CareerService

//获取发展测评模块列表
+ (void)getDevelopmentEvaluates:(NSString *)childId page:(NSInteger)page size:(NSInteger)size type:(NSInteger)type success:(success)success failure:(failure)failure{
    NSString *url = FE_URL_DEVELOP_EVALUATE;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{page}" withString:[NSString stringWithFormat:@"%ld",(long)page]];
    url = [url stringByReplacingOccurrencesOfString:@"{size}" withString:[NSString stringWithFormat:@"%ld",(long)size]];
    url = [url stringByReplacingOccurrencesOfString:@"{type}" withString:[NSString stringWithFormat:@"%ld",(long)type]];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//获取生涯规划任务列表
+(void)getCareerTasks:(NSString *)childId page:(NSInteger)page size:(NSInteger)size success:(success)success failure:(failure)failure{
    NSString *url = FE_URL_CAREER_TASKS;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{page}" withString:[NSString stringWithFormat:@"%ld",page]];
    url = [url stringByReplacingOccurrencesOfString:@"{size}" withString:[NSString stringWithFormat:@"%ld",size]];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}


//获取模块下任务列表
+(void)getModuleTasks:(NSString *)childId page:(NSInteger)page size:(NSInteger)size childModuleId:(NSString *)childModuleId success:(success)success failure:(failure)failure{
    NSString *url = FE_URL_DEVELOP_TASKS;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{child_module_id}" withString:childModuleId];
    url = [url stringByReplacingOccurrencesOfString:@"{page}" withString:[NSString stringWithFormat:@"%ld",page]];
    url = [url stringByReplacingOccurrencesOfString:@"{size}" withString:[NSString stringWithFormat:@"%ld",size]];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//获取任务下的项列表
+(void)getTaskItems:(NSString *)childId page:(NSInteger)page size:(NSInteger)size childTaskId:(NSString *)childTaskId success:(success)success failure:(failure)failure{
    NSString *url = FE_URL_TASK_ITEMS;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{child_task_id}" withString:childTaskId];
    url = [url stringByReplacingOccurrencesOfString:@"{page}" withString:[NSString stringWithFormat:@"%ld",page]];
    url = [url stringByReplacingOccurrencesOfString:@"{size}" withString:[NSString stringWithFormat:@"%ld",size]];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//获取可添加的自定义任务列表
+ (void)getCanAddTasks:(NSString *)childId page:(NSInteger)page size:(NSInteger)size childModuleId:(NSString *)childModuleId success:(success)success failure:(failure)failure{
    NSString *url = FE_URL_CAN_ADD_TASKS;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{child_module_id}" withString:childModuleId];
    url = [url stringByReplacingOccurrencesOfString:@"{page}" withString:[NSString stringWithFormat:@"%ld",page]];
    url = [url stringByReplacingOccurrencesOfString:@"{size}" withString:[NSString stringWithFormat:@"%ld",size]];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//添加自定义任务
+ (void)addCustomTask:(NSString *)childId taskIds:(NSArray *)taskIds childModuleId:(NSString *)childModuleId success:(success)success failure:(failure) failure{
    NSString *url = FE_URL_ADD_TASKS;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    
    NSDictionary *param = @{
                            @"child_module_id":childModuleId,
                            @"task_ids":taskIds
                            };
    
    [QSRequestBase post:url parameters:param success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}


/**
 * 完成文章阅读,完成视频观看等
 * "child_task_item_id":"", //可选，不传代表不是通过具体任务的方式进入的
 * "item_type":1,//1场景，2量表，3文章，4视频，5高考三加三 ，6实践
 * "item_id":"" //文章id，场景id，量表id等等
 */
+(void)completeArticle:(NSString *)childId childTaskItemId:(NSString *)childTaskItemId itemType:(NSString *)itemType itemId:(NSString *)itemId success:(success)success failure:(failure)failure{
    NSString *url = FE_URL_COMPLETE_ARTICLE;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    
    NSDictionary *param = @{
                                 @"child_task_item_id":childTaskItemId,
                                 @"item_type":itemType,
                                 @"item_id":itemId
                                 };
    
    [QSRequestBase post:url parameters:param success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}


//获取用户已经获取勋章
+ (void)getHadMedals:(success)success failure:(failure)failure{
    NSString *url = FE_URL_HAD_MEDALS;

    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//获取系统所有勋章列表
+ (void)getAllMedals:(success)success failure:(failure)failure{
    NSString *url = FE_URL_ALL_MEDALS;
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//获取个人发展档案
+ (void)getTrackRecord:(NSString *)childId success:(success)success failure:(failure)failure{
    NSString *url = FE_URL_TRACK_RECORD;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//获取推荐学科
+ (void)getRecommendDisciplines:(NSString *)childExamId topicId:(NSString *)topicId success:(success)success failure:(failure)failure{
    NSString *url = FE_URL_RECOMMEND_DISCIPLINE;
    url = [url stringByReplacingOccurrencesOfString:@"{child_exam_id}" withString:childExamId];
    url = [url stringByReplacingOccurrencesOfString:@"{topic_d}" withString:topicId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//添加用户自选学科
+ (void)addDisciplines:(NSString *)childExamId topicId:(NSString *)topicId param:(NSDictionary *) param success:(success)success failure:(failure)failure{
    
    NSString *url = FE_URL_ADD_RECOMMEND_DISCIPLINE;
    url = [url stringByReplacingOccurrencesOfString:@"{child_exam_id}" withString:childExamId];
    url = [url stringByReplacingOccurrencesOfString:@"{topic_d}" withString:topicId];
    
    [QSRequestBase post:url parameters:param success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}


//获取省份列表
+ (void)getProvinceList:(success)success failure:(failure)failure{
    
    NSString *url = FE_URL_UNIVERSITY_PROVINCE;
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            //缓存数据
            YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:YTK_DB_NAME];
            NSDictionary *dict = [store getObjectById:YTK_PROVINCE_KEY fromTable:YTK_TABLE_UNIVERSITY];
            [store close];

            if(!dict){
                [store putObject:data withId:YTK_PROVINCE_KEY intoTable:YTK_TABLE_UNIVERSITY];
            }
            success(data);
        }
    } failure:failure];
}

//获取学历列表
+ (void)getDegreesList:(success)success failure:(failure)failure{
    
    NSString *url = FE_URL_UNIVERSITY_DEGREES;
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            //缓存数据
            YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:YTK_DB_NAME];
            NSDictionary *dict = [store getObjectById:YTK_DEGREE_KEY fromTable:YTK_TABLE_UNIVERSITY];
            [store close];

            if(!dict){
                [store putObject:data withId:YTK_DEGREE_KEY intoTable:YTK_TABLE_UNIVERSITY];
            }
            success(data);
        }
    } failure:failure];
}

//获取学校列表
+ (void)getUniversityList:(NSString *)rankingKey chinaDegree:(NSString *)chinaDegree state:(NSString *)state page:(NSInteger)page size:(NSInteger)size success:(success)success failure:(failure)failure{
    NSString *url = FE_URL_UNIVERSITYS;

    url = [url stringByReplacingOccurrencesOfString:@"{ranking_key}" withString:rankingKey];
    url = [url stringByReplacingOccurrencesOfString:@"{china_degree}" withString:[chinaDegree stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    url = [url stringByReplacingOccurrencesOfString:@"{state}" withString:[state stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    url = [url stringByReplacingOccurrencesOfString:@"{page}" withString:[NSString stringWithFormat:@"%ld",page]];
    url = [url stringByReplacingOccurrencesOfString:@"{size}" withString:[NSString stringWithFormat:@"%ld",size]];
   
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//获取学校基本信息
+ (void)getUniversityInfo:(NSString *)universityId success:(success)success failure:(failure)failure{
    
    NSString *url = FE_URL_UNIVERSITY_INFO;
    url = [url stringByReplacingOccurrencesOfString:@"{university_id}" withString:universityId];
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//获取学校概况
+ (void)getUniversitysituation:(NSString *)universityId success:(success)success failure:(failure)failure{
    
    NSString *url = FE_URL_UNIVERSITY_SITUATION;
    url = [url stringByReplacingOccurrencesOfString:@"{university_id}" withString:universityId];
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//学校毕业信息
+ (void)getUniversityGraduation:(NSString *)universityId success:(success)success failure:(failure)failure{
    
    NSString *url = FE_URL_UNIVERSITY_GRADUATION;
    url = [url stringByReplacingOccurrencesOfString:@"{university_id}" withString:universityId];
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//获取场景下的量表列表  topicid就是task里面的item_id
+ (void)getTaskDimensions:(NSString *)childId childExamId:(NSString *)childExamId topicId:(NSString *)topicId success:(success)success failure:(failure) failure{
    
    NSString *url = FE_URL_GET_TOPIC_DISCIPLINES;
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{child_exam_id}" withString:childExamId];
    url = [url stringByReplacingOccurrencesOfString:@"{topic_id}" withString:topicId];
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//专业列表 edu_level: 1-专科，2-本科
+(void)getProfessionalList:(NSString *)eduLevel majorName:(NSString *)majorName success:(success)success failure:(failure)failure{
    
    NSString *url = FE_URL_PROFESSIONAL_LIST;
    url = [url stringByReplacingOccurrencesOfString:@"{edu_level}" withString:eduLevel];
    url = [url stringByReplacingOccurrencesOfString:@"{major_name}" withString:majorName];
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//专业详情
+ (void)getProfessionalDetail:(NSString *)majorCode success:(success)success failure:(failure)failure{
    
    NSString *url = FE_URL_PROFESSIONAL_DETAILS;
    if(!majorCode){
        majorCode = @"";
    }
    url = [url stringByReplacingOccurrencesOfString:@"{major_code}" withString:majorCode];
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
    
}

//获取专业的开设院校
+(void)getProfessionalUniversitys:(NSString *)majorCode state:(NSString *)state instituteType:(NSString *)instituteType page:(NSInteger)page size:(NSInteger)size success:(success)success failure:(failure) failure{
    
    NSString *url = FE_URL_PROFESSIONAL_UNIVERSITYS;
    url = [url stringByReplacingOccurrencesOfString:@"{major_code}" withString:majorCode];
    url = [url stringByReplacingOccurrencesOfString:@"{state}" withString:[state stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    url = [url stringByReplacingOccurrencesOfString:@"{institute_type}" withString:instituteType];
    url = [url stringByReplacingOccurrencesOfString:@"{page}" withString:[NSString stringWithFormat:@"%ld",(long)page]];
    url = [url stringByReplacingOccurrencesOfString:@"{size}" withString:[NSString stringWithFormat:@"%ld",(long)size]];
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//职业列表
+ (void)getOccupationsList:(NSString *)occupationName success:(success)success failure:(failure)failure{
    
    NSString *url = FE_URL_OCCUPATION_LIST;
    url = [url stringByReplacingOccurrencesOfString:@"{occupation_name}" withString:occupationName];
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
    
}

//获取职业分类 type 1 - 职业分类(ACT), 2 - 行业分类
+ (void)getOccupationsCategory:(NSString *)type success:(success)success failure:(failure)failure{
    NSString *url = FE_URL_OCCUPATION_TYPE;
    url = [url stringByReplacingOccurrencesOfString:@"{type}" withString:type];
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//获取职业列表按照刷选条件
+ (void)getOccupationsByCategory:(NSString *)category areaId:(NSString *)areaId occupationName:(NSString *)occupationName page:(NSInteger)page size:(NSInteger)size success:(success)success failure:(failure)failure{
    
    NSString *url = FE_URL_OCCUPATION_LIST_CATEGORY
    if([category isEqualToString:@""]){
        url = [url stringByReplacingOccurrencesOfString:@"category={category}&" withString:@""];
        url = [url stringByReplacingOccurrencesOfString:@"{area_id}" withString:areaId];
    }else{
        url = [url stringByReplacingOccurrencesOfString:@"{category}" withString:[category stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        url = [url stringByReplacingOccurrencesOfString:@"area_id={area_id}&" withString:@""];
    }
    url = [url stringByReplacingOccurrencesOfString:@"{occupation_name}" withString:[occupationName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    url = [url stringByReplacingOccurrencesOfString:@"{page}" withString:[NSString stringWithFormat:@"%ld",(long)page]];
    url = [url stringByReplacingOccurrencesOfString:@"{size}" withString:[NSString stringWithFormat:@"%ld",(long)size]];
    NSLog(@"%@",url);
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//职业详情
+ (void)getOccupationDetail:(NSString *)occupationId success:(success)success failure:(failure)failure{
    
    NSString *url = FE_URL_OCCUPATION_DETAILS;
    url = [url stringByReplacingOccurrencesOfString:@"{occupation_id}" withString:occupationId];
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
    
}

//获取学校相关专业列表
+(void)getUniversityProfessionals:(NSString *)universityId success:(success)success failure:(failure) failure{
    
    NSString *url = FE_URL_UNIVERSITY_PROFESSIONALS;
    url = [url stringByReplacingOccurrencesOfString:@"{university_id}" withString:universityId];
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

/**
 * 学校相关-专业-重点学科
 * national_key = national_key/double_first_class
 * national_key 国家重点学科
 * double_first_class 双一流建设学科
 */
+(void)getUniversityKeySubjects:(NSString *)universityId nationalKey:(NSString *)nationalKey success:(success)success failure:(failure) failure{
    NSString *url = FE_URL_UNIVERSITY_PROFESSIONALS_KEY;
    url = [url stringByReplacingOccurrencesOfString:@"{university_id}" withString:universityId];
    url = [url stringByReplacingOccurrencesOfString:@"{national_key}" withString:nationalKey];
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}


//学校相关-招生录取-招生办信息-招生简章
+ (void)getUniversityStudentBrochure:(NSString *)universitiesId success:(success)success failure:(failure)failure{
    
    NSString *url = FE_URL_UNIVERSITY_STU_RECIUITMENT_BRO;
    url = [url stringByReplacingOccurrencesOfString:@"{universities_id}" withString:universitiesId];
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//学校相关-招生录取-年份
+(void)getAdmissionStuYear:(success)success failure:(failure) failure{
    NSString *url = FE_URL_UNIVERSITY_RECIUITMENT_YRAR;
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//学校相关-招生录取-文理分科
+(void)getAdminssionKinds:(NSString *)province year:(NSString *)year success:(success)success failure:(failure) failure{
    NSString *url = FE_URL_UNIVERSITY_RECIUITMENT_WLFK;
    url = [url stringByReplacingOccurrencesOfString:@"{province}" withString:![NSString isEmptyString:province]? [province stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] : @""];
    if(year && ![year isEqualToString:@""]){
        url = [url stringByReplacingOccurrencesOfString:@"{year}" withString:![NSString isEmptyString:year]?year:@""];
    }else{
        url = [url stringByReplacingOccurrencesOfString:@"/years/{year}" withString:@""];
    }
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
    
}

//学校相关-招生录取-批次
+(void)getAdminssionBatchs:(success)success failure:(failure) failure{
    NSString *url = FE_URL_UNIVERSITY_RECIUITMENT_PICI;
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
    
}

//学校相关-招生录取-院校录取
+(void)getAdminsionUniversities:(AdmissionParamModel *)admissionParamModel success:(success)success failure:(failure) failure{
    NSString *url = FE_URL_UNIVERSITY_RECIUITMENT_YXLQ;
    url = [url stringByReplacingOccurrencesOfString:@"{province}" withString:[admissionParamModel.province stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    url = [url stringByReplacingOccurrencesOfString:@"{kind}" withString:[admissionParamModel.kind stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    url = [url stringByReplacingOccurrencesOfString:@"{school}" withString:[admissionParamModel.school stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//学校相关-招生录取-专业录取
+(void)getAdminsionMajors:(AdmissionParamModel *)admissionParamModel success:(success)success failure:(failure) failure{
    NSString *url = FE_URL_UNIVERSITY_RECIUITMENT_ZYLQ;
    url = [url stringByReplacingOccurrencesOfString:@"{province}" withString:[admissionParamModel.province stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    url = [url stringByReplacingOccurrencesOfString:@"{kind}" withString:[admissionParamModel.kind stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    url = [url stringByReplacingOccurrencesOfString:@"{year}" withString:admissionParamModel.year];
    url = [url stringByReplacingOccurrencesOfString:@"{school}" withString:[admissionParamModel.school stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
    
}

/**
 * 生涯关注相关-关注
 * "type": 1, 0:学校 1:专业
 * "is_follow": false //是否关注 true 关注 false 取消关注
 */
+(void)careerFollow:(NSString *)entityId type:(NSString *)type isFollow:(NSNumber *)isFollow tag:(NSString *)tag success:(success)success failure:(failure) failure{
    
    NSString *url = FE_URL_CARMMER_FOLLOWS;
    
    NSDictionary *param = @{
                            @"entity_id":entityId,
                            @"type":type,
                            @"is_follow":isFollow,
                            @"tag":tag
                            };
    
    [QSRequestBase post:url parameters:param success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

/**
 *  生涯关注相关-关注列表
 *  "type":0:学校 1:专业
 */
+(void)getMyFollows:(NSString *)type page:(NSInteger)page size:(NSInteger)size success:(success)success failure:(failure) failure{
    
    NSString *url = FE_URL_MY_FOLLOWS;
    url = [url stringByReplacingOccurrencesOfString:@"{type}" withString:type];
    
    //?page={page}&size={size}
    url = [NSString stringWithFormat:@"%@?page=%li&size=%li",url, page, size];
    
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}



/**
 * 获取场景或量表个人报告 2019.3
 * child_exam_id：学生考试ID
 * relation_id：维度ID（必填）
 * relation_type：维度类型（topic_dimension - 话题下的主题，topic - 话题 ，必填 ）
 * compare_id：对比样本ID( 0-全国，1- 八大区，2-省，3-市，4-区)
 */
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

//内容推荐 - 个人报告
+(void)getReportRecommend:(NSString *)relationId childExamId:(NSString *)childExamId success:(success)success failure:(failure) failure{
    
    NSString *url = FE_URL_REPORT_RECOMMEND;
    
    url = [url stringByReplacingOccurrencesOfString:@"{relation_id}" withString:relationId];
    url = [url stringByReplacingOccurrencesOfString:@"{child_exam_id}" withString:childExamId];
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
    
}


//获取个人发展档案
+(void)getPersonalAchives:(NSString *)childExamId success:(success)success failure:(failure) failure{
    
    NSString *url = FE_URL_PERSONAL_ARCHIVES;
    
    url = [url stringByReplacingOccurrencesOfString:@"{child_exam_id}" withString:childExamId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//获取能力发展档案
+(void)getAbilityAchives:(NSString *)childId success:(success)success failure:(failure) failure{
    
    NSString *url = FE_URL_ABILITY_ARCHIVES;
    
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//学科助手-获取专业列表(可报考和高要求)
+(void)getSubjectMajors:(NSString *)childId subjectGroup:(NSString *)subjectGroup type:(NSInteger)type page:(NSInteger)page size:(NSInteger)size  success:(success)success failure:(failure) failure{
    
    NSString *url = FE_URL_ZSBK_PROFESSIONAL;
    
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{subject_group}" withString:subjectGroup];
    url = [url stringByReplacingOccurrencesOfString:@"{type}" withString:[NSString stringWithFormat:@"%ld",(long)type]];
    url = [url stringByReplacingOccurrencesOfString:@"{page}" withString:[NSString stringWithFormat:@"%ld",(long)page]];
    url = [url stringByReplacingOccurrencesOfString:@"{size}" withString:[NSString stringWithFormat:@"%ld",(long)size]];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
    
}

//选科助手-系统推荐
+(void)getSystemRecommendSubjects:(NSString *)childExamId success:(success)success failure:(failure) failure{
    
    NSString *url = FE_URL_SYSTEM_RECOMMEND;
    
    url = [url stringByReplacingOccurrencesOfString:@"{child_exam_id}" withString:childExamId];

    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//学科助手-获取专业列表  from_type：可选，过滤条件：1 高考学科推荐 2 MBTI性格测试 3 职业价值观
+(void)getRecommendProfessionals:(NSString *)childId childExamId:(NSString *)childExamId fromTypes:(NSString *)fromTypes page:(NSInteger)page size:(NSInteger)size  success:(success)success failure:(failure) failure{
    
    NSString *url = FE_URL_RECOMMEND_PROFESSIONAL;
    
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{child_exam_id}" withString:childExamId];
    url = [url stringByReplacingOccurrencesOfString:@"{from_types}" withString:fromTypes];
    url = [url stringByReplacingOccurrencesOfString:@"{page}" withString:[NSString stringWithFormat:@"%ld",page]];
    url = [url stringByReplacingOccurrencesOfString:@"{size}" withString:[NSString stringWithFormat:@"%ld",size]];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
    
}

//获取学科列表
+(void)getSubjectList:(NSString *)childId success:(success)success failure:(failure) failure{
    
    NSString *url = FE_URL_SUBJECTS_LIST;
    
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
 
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//确认选课
+(void)confirmSubject:(NSString *)childId childExamId:(NSString *)childExamId subjects:(NSArray *)subjects success:(success)success failure:(failure) failure{
    
    NSString *url = TC_URL_POST_ELECTIVE_DECISION_SUBMIT;
    
    NSDictionary *param = @{
                            @"child_exam_id":childExamId,
                            @"subject_groups":subjects
                            };
    
    [QSRequestBase post:url parameters:param success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
    
}

//获取用户选课
+(void)getUserSubjectsWithChildID:(NSString *)childId childExamID:(NSString *)childExamID success:(success)success failure:(failure) failure{
    
    NSString *url = FE_URL_SURE_SUBJECTS;
    
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    
    url = [UGTool putParams:@{@"child_exam_id" : childExamID} forURL:url];
    
   [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
    
}

//获取意向专业列表
+(void)getIntentionMajors:(NSString *)childId page:(NSInteger)page size:(NSInteger)size  success:(success)success failure:(failure) failure{
    
    NSString *url = TC_URL_GET_ELECTIVE_INTENTION_MAJOR;
    
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//保存意向专业列表 (弃用)
+(void)saveIntentionMajors:(NSString *)childId followMajors:(NSArray<SubjectMajorModel *> *)followMajors success:(success)success failure:(failure) failure{
    
    NSString *url = FE_URL_SAVE_INTENTION_MAJORS;
    
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    
    NSMutableArray<NSDictionary *> *arrayParams = [[NSMutableArray alloc] init];
    
    for(int i=0;i<followMajors.count;i++){
        SubjectMajorModel *model = followMajors[i];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:model.majorName forKey:@"major_name"];
        [dic setValue:model.majorCode forKey:@"major_code"];
        [dic setValue:model.fromTypes forKey:@"from_types"];
        [dic setValue:model.requireSubjects forKey:@"require_subjects"];
        [dic setValue:model.requireUniversityNum forKey:@"require_university_num"];
        [arrayParams addObject:dic];
    }
    
    NSDictionary *param = @{
                            @"follow_majors":arrayParams
                            };
    
    [QSRequestBase post:url parameters:param success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}
//（新）添加意向专业
+(void)addIntentionalMajorWithChildID:(NSString *)childId MajorsInfo:(NSArray < NSDictionary *> *)majors success:(success)success failure:(failure) failure{
    
    NSString *url = TC_URL_POST_ELECTIVE_INTENTION_MAJOR_SUBMIT;
    
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
        
    NSDictionary *param = @{
                            @"follow_majors":majors
                            };
    
    [QSRequestBase post:url parameters:param success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//根据选科组合获取专业覆盖率
+(void)getCoverageBySubject:(NSString *)childId subjectGroup:(NSString *)subjectGroup success:(success)success failure:(failure) failure{
    
    NSString *url = FE_URL_SUBJECT_COVERAGE;
    
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{subject_group}" withString:subjectGroup];
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//获取用户选科组合列表
+(void)getConfirmSubjects:(NSString *)childId childExamId:(NSString *)childExamId success:(success)success failure:(failure) failure{
    NSString *url = TC_URL_GET_ELECTIVE_DECISON;
    
    url = [url stringByReplacingOccurrencesOfString:@"{child_exam_id}" withString:childExamId];
    
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

//内容管理-首页轮播列表
+(void)getHomeDisseminates:(success)success failure:(failure) failure{
    NSString *url = FE_URL_HOME_DISSEMINATES;
    url = [url stringByAppendingString:[NSString stringWithFormat:@"?child_id=%@",UCManager.sharedInstance.currentChild.childId]];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"&visitor=%@",(UCManager.sharedInstance.isVisitorPattern ? @"1" : @"0")]];
    url = [url stringByAppendingString:@"&client_type=2"];
    [QSRequestBase get:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}

+ (void)putHomeDisseminatesClickById:(NSString *)Id onSuccess:(success)success failure:(failure) failure {
    NSString *URLString = [UGTool replacingStrings:@[@"{id}"] withObj:@[Id] forURL:TC_URL_PUT_DISSEMINATES_CLICK];
    [QSRequestBase put:URLString parameters:nil success:success failure:failure];
}

//获取用户可选择选科组合列表
+(void)getGroupSubjects:(NSString *)childId childExamId:(NSString *)childExamId success:(success)success failure:(failure) failure{
    
    NSString *url = FE_URL_GROUP_SUBJECTS;
    
    url = [url stringByReplacingOccurrencesOfString:@"{child_id}" withString:childId];
    url = [url stringByReplacingOccurrencesOfString:@"{child_exam_id}" withString:childExamId];
    
    [QSRequestBase get:url success:^(id data) {
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

//评价管理-用户评价
+(void)commitReportJudge:(NSString *)itemId refId:(NSString *)refId childId:(NSString *)childId success:(success)success failure:(failure) failure{
    if ([NSString isEmptyString:itemId] || [NSString isEmptyString:childId]) {
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

+ (void)getCourseListWithStudentID:(NSString *)stuID page:(NSInteger)page size:(NSInteger)size success:(nonnull success)success failure:(nonnull failure)failure{
    NSString *url = [UGTool replacingStrings:@[@"{student_id}", @"{page}", @"{size}"] withObj:@[stuID, @(page), @(size)] forURL:FE_URL_COURSE_LIST];
    [QSRequestBase get:url success:success failure:failure];
}


+ (void)registrateCourseWithExamID:(NSString *)examID studentID:(NSString *)stuID success:(success)success failure:(failure)failure {
    NSString *url = [UGTool replacingStrings:@[@"{exam_id}", @"{student_id}"] withObj:@[examID, stuID] forURL:FE_URL_COURSE_REGISTRATE];
    [QSRequestBase post:url parameters:nil success:success failure:failure];
}

+ (void)getCourseDetailWithCourseID:(NSString *)courseID examID:(NSString *)examID childExamID:(NSString *)childExamID success:(success)success failure:(failure)failure {
    NSString *url = [UGTool replacingStrings:@[@"{exam_id}", @"{course_id}"] withObj:@[ examID, courseID] forURL:FE_URL_COURSE_DETAIL];
    if (![NSString isEmptyString:childExamID]) {
        url = [UGTool putParams:@{@"child_exam_id" : childExamID} forURL:url];
    }
    [QSRequestBase get:url success:success failure:failure];
}

+ (void)completeLessonWithCourseID:(NSString *)couseID lessonID:(NSString *)lessonID childExamID:(NSString *)childExamID success:(success)success failure:(failure)failure {
    if ([NSString isEmptyString:childExamID]) return;
    if ([NSString isEmptyString:couseID]) return;
    if ([NSString isEmptyString:lessonID]) return;

    NSString *url = TC_URL_POST_COURSE_LESSON_FINISH;
    NSDictionary *params =  @{
        @"child_exam_id" : childExamID,
        @"course_id" : couseID,
        @"lesson_id" : lessonID
    };
    [QSRequestBase post:url parameters:params success:success failure:failure];
}

+ (void)getRecommendedReadingWithLessonId:(NSString *)lessonId  success:(success)success failure:(failure) failure {
    NSString *url = [UGTool replacingStrings:@[@"{article_id}"] withObj:@[lessonId] forURL:FE_URL_COURSE_ARTICLE_RECOMMEND];
    [QSRequestBase get:url success:success failure:failure];
}

+ (void)getReferenceWithLessonId:(NSString *)lessonId  success:(success)success failure:(failure) failure {
    NSString *url = [UGTool replacingStrings:@[@"{article_id}"] withObj:@[lessonId] forURL:FE_URL_COURSE_ARTICLE_REFERENCE];
    [QSRequestBase get:url success:success failure:failure];
}

+ (void)getElectiveReportWithChildExamID:(NSString *)childExamID success:(success)success failure:(failure)failure {
    NSString *url = [UGTool replacingStrings:@[@"{child_exam_id}"] withObj:@[childExamID] forURL:TC_URL_GET_ELECTIVE_REPORT];
    [QSRequestBase get:url success:success failure:failure];

}

+ (void)getElectiveMajorCategoryWithSuccess:(success)success failure:(failure)failure {
    [QSRequestBase get:FE_URL_ELECTIVE_MAJOR_CATEGORY success:success failure:failure];
}

+(void)getElectiveMajorListWithChildID:(NSString *)childID childExamID:(NSString *)childExamID page:(NSNumber *)page size:(NSNumber *)size filterWithCodes:(NSArray<NSString *> *)codes name:(NSString *)name Success:(success)success failure:(failure)failure {
    NSString *url = [UGTool replacingStrings:@[@"{child_id}", @"{child_exam_id}", @"{page}", @"{size}"] withObj:@[childID, childExamID, page, size] forURL:FE_URL_ELECTIVE_MAJOR_LIST];
    for (NSString *code in codes) {
        url = [url stringByAppendingFormat:@"&major_codes=%@",code];
    }
    if (![NSString isEmptyString:name]) {
        url = [url stringByAppendingFormat:@"&major_name=%@", [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    [QSRequestBase get:url success:success failure:failure];

}

+ (void)getAudioListByCourseID:(NSString *)courseId success:(success)success failure:(failure) failure {
    if ([NSString isEmptyString:courseId]) return;
    NSString *url = [UGTool replacingStrings:@[@"{course_id}"] withObj:@[courseId] forURL:TC_URL_GET_AUDIO_LIST];
    [QSRequestBase get:url success:success failure:failure];
}


+ (void)getElectiveEvaluationDimensionsWithChildExamId:(NSString *)childExamId success:(success)success failure:(failure)failure {
    if ([NSString isEmptyString:childExamId]) return;
    NSString *URL = [UGTool replacingStrings:@[@"{child_exam_id}"] withObj:@[childExamId] forURL:TC_URL_GET_ELECTIVE_DIMENSIONS];
    [QSRequestBase get:URL success:success failure:failure];
}

+ (void)getCourseDetailByCourseId:(NSString *)courseId childId:(NSString *)childId onSuccess:(success)success failure:(failure)failure {
    NSString *URLString = [UGTool replacingStrings:@[@"{course_id}"] withObj:@[courseId] forURL:TC_URL_GET_COURSE_DETAIL];
    if (![NSString isEmptyString:childId]) {
        URLString = [UGTool putParams:@{
            @"child_id" : childId
        } forURL:URLString];
    }
    
    [QSRequestBase get:URLString success:success failure:failure];
}

+ (void)getCourseArticleByCourseId:(NSString *)courseId articleId:(NSString *)articleId childExamId:(NSString *)childExamId unneedCount:(BOOL)unneedCount onSuccess:(success)success failure:(failure)failure {
    
    NSString *URLString = [UGTool replacingStrings:@[@"{course_id}", @"{article_id}"] withObj:@[courseId, articleId] forURL:TC_URL_GET_COURSE_ARTICLE];
    BOOL added = NO;
    if (![NSString isEmptyString:childExamId]) {
        URLString = [NSString stringWithFormat:@"%@?child_exam_id=%@",URLString,childExamId];
        added = YES;
    }
    if (!UCManager.sharedInstance.isVisitorPattern) {
        NSString *format = [NSString isEmptyString:childExamId]? @"%@?child_id=%@" : @"%@&child_id=%@";
        URLString = [NSString stringWithFormat:format, URLString, UCManager.sharedInstance.currentChild.childId];
        added = YES;
    }
   
//    if (unneedCount) {
//        URLString = [NSString stringWithFormat:@"%@%@is_simple=true",URLString, added? @"&": @"?"];
//    }
    
    
    [QSRequestBase get:URLString success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:failure];
}
@end
