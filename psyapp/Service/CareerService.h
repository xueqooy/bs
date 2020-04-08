//
//  CareerService.h
//  smartapp
//
//  Created by lafang on 2019/2/20.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QSRequestBase.h"
#import "AdmissionParamModel.h"
#import "SubjectMajorModel.h"


@interface CareerService : NSObject

//获取发展测评模块列表 type = 1 发展测评 type = 2 生涯 不传默认发展测评
+ (void) getDevelopmentEvaluates:(NSString *)childId page:(NSInteger)page size:(NSInteger)size type:(NSInteger)type success:(success)success failure:(failure) failure;

//获取模块下任务列表
+ (void) getModuleTasks:(NSString *)childId page:(NSInteger)page size:(NSInteger)size childModuleId:(NSString *)childModuleId success:(success)success failure:(failure) failure;

//获取任务下的项列表
+ (void) getTaskItems:(NSString *)childId page:(NSInteger)page size:(NSInteger)size childTaskId:(NSString *)childTaskId success:(success)success failure:(failure) failure;

//获取可添加的自定义任务列表
+ (void) getCanAddTasks:(NSString *)childId page:(NSInteger)page size:(NSInteger)size childModuleId:(NSString *)childModuleId success:(success)success failure:(failure) failure;

//添加自定义任务
+ (void)addCustomTask:(NSString *)childId taskIds:(NSArray *)taskIds childModuleId:(NSString *)childModuleId success:(success)success failure:(failure) failure;

//获取生涯规划任务列表
+ (void) getCareerTasks:(NSString *)childId page:(NSInteger)page size:(NSInteger)size success:(success)success failure:(failure) failure;

//完成文章阅读
+ (void)completeArticle:(NSString *)childId childTaskItemId:(NSString *)childTaskItemId itemType:(NSString *)itemType itemId:(NSString *)itemId success:(success)success failure:(failure) failure;

//获取用户已经获取勋章
+ (void)getHadMedals:(success)success failure:(failure) failure;

//获取系统所有勋章列表
+ (void)getAllMedals:(success)success failure:(failure) failure;

//获取个人发展档案
+ (void)getTrackRecord:(NSString *)childId success:(success)success failure:(failure) failure;

//获取推荐学科
+ (void)getRecommendDisciplines:(NSString *)childExamId topicId:(NSString *)topicId success:(success)success failure:(failure) failure;

//添加用户自选学科
+ (void)addDisciplines:(NSString *)childExamId topicId:(NSString *)topicId param:(NSDictionary *) param success:(success)success failure:(failure) failure;



//获取省份列表
+ (void)getProvinceList:(success)success failure:(failure) failure;

//获取学历层级
+ (void)getDegreesList:(success)success failure:(failure) failure;

//获取学校列表
+ (void)getUniversityList:(NSString *)rankingKey chinaDegree:(NSString *)chinaDegree state:(NSString *)state page:(NSInteger)page size:(NSInteger)size success:(success)success failure:(failure) failure;

//获取学校基本信息
+ (void)getUniversityInfo:(NSString *)universityId success:(success)success failure:(failure) failure;

//获取学校概况
+ (void)getUniversitysituation:(NSString *)universityId success:(success)success failure:(failure) failure;

//获取场景下的量表列表
+ (void)getTaskDimensions:(NSString *)childId childExamId:(NSString *)childExamId topicId:(NSString *)topicId success:(success)success failure:(failure) failure;

//获取专业列表
+(void)getProfessionalList:(NSString *)eduLevel majorName:(NSString *)majorName success:(success)success failure:(failure) failure;

//获取专业详情
+(void)getProfessionalDetail:(NSString *)majorCode success:(success)success failure:(failure) failure;

/**
 * 获取专业的开设院校
 * major_code：专业代码
 * state：地区
 * institute_type：学校类别
 */
+(void)getProfessionalUniversitys:(NSString *)majorCode state:(NSString *)state instituteType:(NSString *)instituteType page:(NSInteger)page size:(NSInteger)size success:(success)success failure:(failure) failure;

//获取职业列表
+(void)getOccupationsList:(NSString *)occupationName success:(success)success failure:(failure) failure;

//获取职业分类
+(void)getOccupationsCategory:(NSString *)type success:(success)success failure:(failure) failure;

//获取职业列表按照刷选条件
+(void)getOccupationsByCategory:(NSString *)category areaId:(NSString *)areaId occupationName:(NSString *)occupationName page:(NSInteger)page size:(NSInteger)size success:(success)success failure:(failure) failure;

//获取职业详情
+(void)getOccupationDetail:(NSString *)occupationId success:(success)success failure:(failure) failure;

//获取学校相关专业列表
+(void)getUniversityProfessionals:(NSString *)universityId success:(success)success failure:(failure) failure;

/**
 * 学校相关-专业-重点学科
 * national_key = national_key/double_first_class
 * national_key 国家重点学科
 * double_first_class 双一流建设学科
 */
+(void)getUniversityKeySubjects:(NSString *)universityId nationalKey:(NSString *)nationalKey success:(success)success failure:(failure) failure;

//获取学校招生简章
+(void)getUniversityStudentBrochure:(NSString *)universitiesId success:(success)success failure:(failure) failure;

//学校毕业信息
+(void)getUniversityGraduation:(NSString *)universityId success:(success)success failure:(failure) failure;

//学校相关-招生录取-年份
+(void)getAdmissionStuYear:(success)success failure:(failure) failure;

//学校相关-招生录取-文理分科
+(void)getAdminssionKinds:(NSString *)province year:(NSString *)year success:(success)success failure:(failure) failure;

//学校相关-招生录取-批次
+(void)getAdminssionBatchs:(success)success failure:(failure) failure;

//学校相关-招生录取-院校录取
+(void)getAdminsionUniversities:(AdmissionParamModel *)admissionParamModel success:(success)success failure:(failure) failure;

//学校相关-招生录取-专业录取
+(void)getAdminsionMajors:(AdmissionParamModel *)admissionParamModel success:(success)success failure:(failure) failure;

/**
 * 生涯关注相关-关注
 * "type": 1, 0:学校 1:专业
 * "is_follow": false //是否关注 true 关注 false 取消关注 
 */
+(void)careerFollow:(NSString *)entityId type:(NSString *)type isFollow:(NSNumber *)isFollow tag:(NSString *)tag success:(success)success failure:(failure) failure;


/**
 *  生涯关注相关-关注列表
 *  "type":0:学校 1:专业
 */
+(void)getMyFollows:(NSString *)type page:(NSInteger)page size:(NSInteger)size success:(success)success failure:(failure) failure;


/**
 * 获取场景或量表个人报告 2019.3
 * child_exam_id：学生考试ID
 * relation_id：维度ID（必填）
 * relation_type：维度类型（topic_dimension - 话题下的主题，topic - 话题 ，必填 ）
 * compare_id：对比样本ID( 0-全国，1- 八大区，2-省，3-市，4-区)
 */
+(void)getPersonalReport:(NSString *)childExamId  relationId:(NSString *)relationId relationType:(NSString *)relationType compareId:(NSString *)compareId success:(success)success failure:(failure) failure;

+ (void)getDimensionReportByChildDimensionId:(NSString *)childDimensionId success:(success)success failure:(failure) failure;

//内容推荐 - 个人报告
+(void)getReportRecommend:(NSString *)relationId childExamId:(NSString *)childExamId success:(success)success failure:(failure) failure;

//获取个人生涯发展档案
+(void)getPersonalAchives:(NSString *)childExamId success:(success)success failure:(failure) failure;

//获取能力发展档案
+(void)getAbilityAchives:(NSString *)childId success:(success)success failure:(failure) failure;

//学科助手-获取专业列表(可报考和高要求)
+(void)getSubjectMajors:(NSString *)childId subjectGroup:(NSString *)subjectGroup type:(NSInteger)type page:(NSInteger)page size:(NSInteger)size  success:(success)success failure:(failure) failure;

//选科助手-系统推荐
+(void)getSystemRecommendSubjects:(NSString *)childExamId success:(success)success failure:(failure) failure;

//学科助手-获取专业列表
+(void)getRecommendProfessionals:(NSString *)childId childExamId:(NSString *)childExamId fromTypes:(NSString *)fromTypes page:(NSInteger)page size:(NSInteger)size  success:(success)success failure:(failure) failure;

//获取学科列表
+(void)getSubjectList:(NSString *)childId success:(success)success failure:(failure) failure;

//确认选科
+(void)confirmSubject:(NSString *)childId childExamId:(NSString *)childExamId subjects:(NSArray *)subjects success:(success)success failure:(failure) failure;

//获取意向专业列表
+(void)getIntentionMajors:(NSString *)childId page:(NSInteger)page size:(NSInteger)size  success:(success)success failure:(failure) failure;

//保存意向专业列表
+(void)saveIntentionMajors:(NSString *)childId followMajors:(NSArray<SubjectMajorModel *> *)followMajors success:(success)success failure:(failure) failure;

//根据选科组合获取专业覆盖率
+(void)getCoverageBySubject:(NSString *)childId subjectGroup:(NSString *)subjectGroup success:(success)success failure:(failure) failure;

//获取用户选科组合列表
+(void)getConfirmSubjects:(NSString *)childId childExamId:(NSString *)childExamId success:(success)success failure:(failure) failure;

//内容管理-首页轮播列表
+(void)getHomeDisseminates:(success)success failure:(failure) failure;

//获取用户可选择选科组合列表
+(void)getGroupSubjects:(NSString *)childId childExamId:(NSString *)childExamId success:(success)success failure:(failure) failure;

//评价管理-获取评价内容列表
+(void)getReportJudge:(NSString *)refId type:(NSString *)type childId:(NSString *)childId titleId:(NSString *)titleId success:(success)success failure:(failure) failure;

//评价管理-用户评价
+(void)commitReportJudge:(NSString *)itemId refId:(NSString *)refId childId:(NSString *)childId success:(success)success failure:(failure) failure;



///  ------新课程-----
//获取课程列表
+ (void)getCourseListWithStudentID:(NSString *)stuID page:(NSInteger)page size:(NSInteger)size success:(success)success failure:(failure) failure;


//课程报名
+ (void)registrateCourseWithExamID:(NSString *)examID studentID:(NSString *)stuID success:(success)success failure:(failure) failure;

//课程详情
+ (void)getCourseDetailWithCourseID:(NSString *)courseID examID:(NSString *)examID childExamID:(NSString *)childExamID success:(success)success failure:(failure) failure;

+ (void)completeLessonWithCourseID:(NSString *)couseID
   lessonID:(NSString *)lessonID
childExamID:(NSString *)childExamID
    success:(success)success failure:(failure) failure;

+ (void)getAudioListByCourseID:(NSString *)courseId success:(success)success failure:(failure) failure;

+ (void)getRecommendedReadingWithLessonId:(NSString *)lessonId  success:(success)success failure:(failure) failure;

+ (void)getReferenceWithLessonId:(NSString *)lessonId  success:(success)success failure:(failure) failure ;
/// ------新选科助手-----
+ (void)getElectiveReportWithChildExamID:(NSString *)childExamID success:(success)success failure:(failure) failure;

+ (void)getElectiveMajorCategoryWithSuccess:(success)success failure:(failure) failure;

+ (void)getElectiveMajorListWithChildID:(NSString *)childID childExamID:(NSString *)childExamID page:(NSNumber *)page size:(NSNumber *)size filterWithCodes:(NSArray<NSString *> *)codes name:(NSString *)name Success:(success)success failure:(failure) failure;
+ (void)getElectiveEvaluationDimensionsWithChildExamId:(NSString *)childExamId success:(success)success failure:(failure) failure;

//
+(void)addIntentionalMajorWithChildID:(NSString *)childId MajorsInfo:(NSArray < NSDictionary *> *)majors success:(success)success failure:(failure) failure;

//获取用户选课
+(void)getUserSubjectsWithChildID:(NSString *)childId childExamID:(NSString *)childExamID success:(success)success failure:(failure) failure;

#pragma mark - C端
+ (void)getCourseDetailByCourseId:(NSString *)courseId childId:(NSString *)childId onSuccess:(success)success failure:(failure) failure;

+ (void)putHomeDisseminatesClickById:(NSString *)Id onSuccess:(success)success failure:(failure) failure;

+ (void)getCourseArticleByCourseId:(NSString *)courseId articleId:(NSString *)articleId childExamId:(NSString *)childExamId unneedCount:(BOOL)unneedCount onSuccess:(success)success failure:(failure)failure;
@end




