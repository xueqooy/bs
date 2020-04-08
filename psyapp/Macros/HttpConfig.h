//
//  HttpConfig.h
//  app
//
//  Created by linjie on 17/3/8.
//  Copyright © 2017年 jeyie0. All rights reserved.
//

#ifndef HttpConfig_h
#define HttpConfig_h

#if APPTEST_ENVIRONMENT_DEVELOP_ENABLE
//develop
#define API_HOST @"http://psytest-server.test.cheersmind.qst" 

#else
//product
#define API_HOST @"http://psytest-server9528-pre.cheersmind.com" //@"https://psytest-server.cheersmind.com"

#endif

#define VIDEO_KEY @"3deaadbc1e5540539884401ae0abaf0b"

//local-国权
//#define API_HOST @"http://192.168.205.203:8080"
//#define API_HOST @"http://192.168.205.203:8080"
//#define WEB_HOST @"http://psytest-web.test.cheersmind.qst"


/*--------------------------------------------------
 -------------------------用户相关--------------------
 ---------------------------------------------------*/
//用户登录 [POST] /oauth2/tokens/actions/sign_in
//第三方登录 [POST] /oauth2/tokens/actions/third_sign_in【修改URI】
//Token续约 [POST] /oauth2/tokens/actions/{refresh_token}?persist=0【修改URI】
//登录
//#define URL_LOGIN API_HOST@"/v1.0/tokens"
#define URL_LOGIN API_HOST@"/v1/oauth2/tokens/actions/sign_in"
//第三方登录
//#define URL_LOGIN_THIRD API_HOST@"/v1.0/third_sign_up"
#define URL_LOGIN_THIRD API_HOST@"/v1/oauth2/tokens/actions/third_sign_in"

//第三方登录注册
#define URL_REGISTER_THIRD API_HOST@"/v1/api/users/third/sign_in"

#define URL_USER_INFO API_HOST@"/v1/api/users"//用户信息接口
#define URL_CHILD_LIST API_HOST@"/v1/api/children"
//#define URL_CHILD_INFO API_HOST@"/v0.1/child/{child_id}"
#define URL_REGISTER API_HOST@"/v1/api/registers"
#define URL_VALID_INVITE_CODE API_HOST@"/v1/api/registers/actions/check_invite_code"
/*--------------------------------------------------
 -------------------------测评相关--------------------
 ---------------------------------------------------*/
#define URL_TOPIC_LIST API_HOST@"/v1/api/topics?page=1&size=10000"

#define URL_RECOMMEND_DIMENSION_LIST API_HOST@"/v1/api/children/{child_id}/recommend_dimensions?topic_id={topic_id}&page=1&size=100000"

#define URL_CHILD_TOPIC_LIST API_HOST@"/v2/api/children/{child_id}/topics?page=1&size=10000"//获取孩子的主题类表，带量表列表

//#define URL_CHILD_TOPIC_DETAIL API_HOST@"/v1/api/{child_id}/topics?page=1&size=10000"
#define URL_FOLLOW_TOPIC API_HOST@"/v1/api/children/{child_id}/topics/{topic_id}/follow"
//#define URL_TOPIC_DETAIL API_HOST@"/v1/api/children/topics/{topic_id}"//主题详情
#define URL_TOPIC_FOLLOWED API_HOST@"/v1/api/children/{child_id}/topics/followed"
#define URL_BEGIN_TOPIC API_HOST@"/v1/api/children/{child_id}/topics/{topic_id}/start"//开始话题

#define URL_TOPIC_DIMENSION_LIST API_HOST@"/v1/api/dimensions?topic_id={topic_id}&page=1&size=10000"
#define URL_CHILD_TOPIC_DIMENSION_LIST API_HOST@"/v1/api/children/{child_id}/dimensions?page=1&size=10000"//获取孩子的量表列表（某主题下的量表）

#define URL_HOT_DIMENSION_LIST API_HOST@"/v1/api/children/{child_id}/dimensions/hot"//获取孩子的量表列表（某主题下的量表）

#define URL_DIMENSION_RANK API_HOST@"/v1/api/children/{child_id}/topics/{topic_id}/dimensions/{dimension_id}/factors/{factor_id}/rank"//量表排行数据

#define URL_FACTOR_RANK_REPORT API_HOST@"/v1/api/children/{child_id}/child_factors/{child_factor_id}/rank_report"//获取孩子的因子统计报表数据

#define URL_DIMENSION_DETAIL API_HOST@"/v1/api/factors?dimension_id={dimension_id}&page=1&size=10000"//获取量表下的因子列表
//#define URL_START_DIMENSION API_HOST@"/v1/api/children/{child_id}/exams/{exam_id}/topics/{topic_id}/dimensions/{dimension_id}"//开始某个分量表
#define URL_CHILD_DIMENSION_FACTOR_LIST API_HOST@"/v1/api/children/{child_id}/dimensions/{dimension_id}/factors?child_dimension_id={child_dimension_id}&page=1&size=10000"//获取孩子量表下的因子列表
#define URL_START_FACTOR API_HOST@"/v1/api/children/{child_id}/exams/{exam_id}/topics/{topic_id}/dimensions/{dimension_id}/factors/{factor_id}"//开始因子

///v1/api/children/{child_id}/topics/{topic_id}/dimensions/{dimension_id}/factors/{factor_id}

#define URL_QUESTION_INFO API_HOST@"/v1/api/children/{child_id}/factors/{factor_id}/questions?child_factor_id={child_factor_id}"//获取因子下的题目列表

#define URL_SAVE_QUESTION API_HOST@"/v1/api/children/{child_id}/questions/{question_id}/save"//保存单题答案
#define URL_SUBMIT_EXAM API_HOST@"/v1/api/children/{child_id}/factors/{child_factor_id}/submit"//提交试卷


#define URL_FLOWER_RECORD API_HOST@"/v1/api/flowers?page=1&size=10000"//鲜花记录

#define URL_REPORT WEB_HOST@"/report.html?access_token={access_token}&refresh_token={refresh_token}&mac_key={mac_key}&user_id={user_id}&child_id={child_id}&exam_id={exam_id}&type={type}&id={id}"//提交试卷

#define URL_CHILD_DIMENSION_LATEST API_HOST@"/v2/api/children/{child_id}/latest_dimensions"//获取孩子最近的答题量表

#define URL_CHILD_TOPIC_REPORT API_HOST@"/v2/api/exams/{exam_id}/children/{child_id}/reports?relation_id={relation_id}&relation_type={relation_type}&sample_id={sample_id}"//获取孩子主题报告，包括主题下的量表报告

#define URL_CHILD_TOPIC_LIST_DIMENSION API_HOST@"/v2/api/children/{child_id}/topics?page=1&size=10000"//获取孩子主题列表（带主题下所有量表）

#define URL_UPDATE_NOTICE @"http://img.cheersmind.com/notice/fireeyes.json";//消息通知

#define URL_VERSION_UPDATE API_HOST@"/v1/api/apps/{app_id}/versions/actions/get_latest_version?os=2"//获取版本更新信息

#define URL_SERVER_TIME API_HOST@"/v1/oauth2/server/time"//获取服务器时间




/**
 * -----------------奇思火眼相关-----------------
 */

//用户登录
#define FE_URL_USER_LOGIN API_HOST@"/v2/oauth2/tokens/actions/sign_in";

//第三方登录
#define FE_URL_LOGIN_THIRD API_HOST@"/v2/oauth2/tokens/actions/third_sign_in"

//手机短信登录
#define FE_URL_PHONE_SMS_LOGIN API_HOST"/v2/oauth2/sms/sign_in";

//手机短信帐号注册
#define FE_URL_PHONE_SMS_REGISTER API_HOST"/v2/oauth2/mobile/sign_up";

//退出登录 [DELETE]
#define FE_URL_EXIT_LOGIN API_HOST"/v2/oauth2/tokens/{access_token}";

//获取用户详情 [GET]
//#define FE_URL_USER_INFO API_HOST"/v2/oauth2/users";

//获取用户已经绑定第三方平台 [GET]
#define FE_URL_USER_THIRDS API_HOST"/v2/accounts/users/third_party?tenant=CHEERSMIND";

//用户修改密码 [PATCH]
#define FE_URL_CHANGE_PASSWORD API_HOST"/v2/accounts/users/password";

//第三方帐号绑定 [POST]
#define FE_URL_THIRD_BINDING API_HOST"/v2/accounts/actions/third_bind";

//第三方帐号解绑 [DELETE]
#define FE_URL_THIRD_UNBINDING API_HOST"/v2/accounts/actions/third_unbind";

//绑定手机号 [PUT]
#define FE_URL_MOBILE_BINDING API_HOST"/v2/accounts/mobile/actions/bind";

//更换手机号--验证原手机号 [POST]
#define FE_URL_MOBILE_CHANGE API_HOST"/v2/accounts/mobile/actions/check";

//手机找回密码 [PATCH]
#define FE_URL_MOBILE_RESET_PASS API_HOST"/v2/accounts/password/actions/reset";

//下发短信验证码 [POST]
#define FE_URL_SEND_SMS API_HOST"/v2/accounts/sms";

//创建会话 [POST] 会话类型，0：注册(手机)，1：登录(帐号、密码登录)，2：手机找回密码，3：登录(短信登录)，4:下发短信验证码
#define FE_URL_SEND_SESSIONS API_HOST"/v2/accounts/sessions";

//获取图片验证码 [GET]
#define FE_URL_GET_IMAGE API_HOST"/v2/accounts/sessions/{session_id}/verification_code";

//验证图片验证码 [POST] /accounts/sessions/{session_id}/verification_code/actions/valid
#define FE_URL_CHECK_IMAGE API_HOST"/v2/accounts/sessions/{session_id}/verification_code/actions/valid";

//用户日常签到 [POST]
#define FE_URL_SIGN_IN API_HOST"/v2/api/missions/daily/sign_in";

//查看用户当天的签到状态[GET]
#define FE_URL_SIGN_IN_STATE API_HOST"/v2/api/missions/daily/sign_in";

//获取用户的积分列表（分页）[GET]
#define FE_URL_SCORE_NUM_LIST API_HOST"/v2/api/integrals?page={page}&size={size}";

//获取用户积分 [GET]
#define FE_URL_ALL_SCORES API_HOST"/v2/api/integrals/total_score";

//获取用户消息列表 [GET] /v2/api/messages?page={page}&size={size}
#define FE_URL_USER_MESSAGES API_HOST"/v2/api/messages?page={page}&size={size}&child_id={child_id}";

//设置消息为已读 [PUT] /v2/messages/{message_id}/read
#define FE_URL_READ_MESSAGE API_HOST"/v2/api/messages/{message_id}/read?child_id={child_id}";

//删除消息[DELETE] /v2/messages/{message_id}
#define FE_URL_DELETE_MESSAGE API_HOST"/v2/api/messages/{message_id}?child_id={child_id}";
//获取未读消息数
#define FE_URL_UNLOOK_MESSAGES API_HOST"/v2/api/messages/unread_message/count?child_id={child_id}";


//获取用户孩子列表
#define FE_URL_CHILD_LIST API_HOST@"/2c/v1/users/children";

//获取用户信息
#define FE_URL_USER_INFO API_HOST@"/2c/v1/users"

//修改用户信息 [PATCH] /v2/api/users
#define FE_URL_USER_MODIFY API_HOST@"/v2/api/users"

//获取用户手机号（混淆）[GET]
#define FE_URL_USER_MOBILE API_HOST@"/v2/accounts/mobile"

//查看手机号是否已经注册 [GET]
#define FE_URL_MOBILE_IS_REGISTER API_HOST@"/v2/accounts/mobile/{mobile}"

//用户上传头像 [POST]
#define FE_URL_USER_UPLOAD_HEAD API_HOST@"/v2/api/users/avatar/upload"

//根据班级群号获取班级信息 [GET]
#define FE_CLASS_GROUP_INFO API_HOST"/v2/api/classes/groups/{group_no}";

//首次注册完善用户信息 [POST]
#define FE_PERFECT_USER_INFO API_HOST"/v2/api/users/info";

//开始量表
#define URL_START_DIMENSION API_HOST@"/v2/api/children/{child_id}/exams/{exam_id}/topics/{topic_id}/dimensions/{dimension_id}"

//开始量表（new）--------(暂时未使用)------
#define URL_START_DIMENSION_NEW API_HOST@"/v2/child_exams/{child_exam_id}/topics/{topic_id}/dimensions/{dimension_id}"

//获取孩子某个分量表下的题目列表
#define FE_URL_CHILD_DIMENSION_QUESTIONS API_HOST@"/v2/api/child_dimensions/{child_dimension_id}/questions?page={page}&size={size}"

//保存孩子分量表下变更新答题信息列表
#define FE_SAVE_DIMENSION_QUESTION API_HOST@"/v2/api/child_dimensions/{child_dimension_id}/save";

//提交分量表
#define FE_SUBMIT_DIMENSION_QUESTION API_HOST@"/v2/api/child_dimensions/{child_dimension_id}/submit";

//非合并答题
#define FE_URL_DIMENSION_QUESTIONS API_HOST@"/v2/api/child_dimensions/{child_dimension_id}/questions?page={page}&size={size}"

//获取合并答题的题目列表
#define FE_URL_DIMENSION_MERGE_QUESTIONS API_HOST@"/v3/api/child_dimensions/{child_dimension_id}/questions/merge"

//保存孩子分量表下变更新答题信息列表
#define FE_SAVE_DIMENSION_QUESTION API_HOST@"/v2/api/child_dimensions/{child_dimension_id}/save";

//按状态获取孩子测评的场景列表，包含分量表信息列表（报告界面使用的接口）
#define FE_URL_TOPIC_DIMENSION_REPORTS API_HOST@"/v2/api/children/{child_id}/child_exams?status={status}&page={page}&size={size}"

//获取文章中推荐测评
#define FE_URL_ARTICLE_EVALUATE API_HOST@"/v2/api/children/{child_id}/topics/{topic_id}/dimensions/{dimension_id}";

//获取视频在阿里云的授权地址[GET]
#define FE_URL_VIDEO_PATH API_HOST@"/v2/api/videos/{video_id}/actions/get_display_url?sign={sign}&t={t}";


//文章--分类列表
#define FE_ARTICLE_CATEGORIES API_HOST@"/v2/api/categories";

//文章--获取热门文章列表
#define FE_ARTICLE_HOT_LIST API_HOST@"/v2/api/articles/top?page={page}&size={size}";

//文章--获取所有文章列表
#define FE_ARTICLE_ALL_LIST API_HOST@"/v2/api/articles?page={page}&size={size}&filter={filter}&category_id={category_id}";

//文章--获取指定分类文章列表
#define FE_ARTICLE_APPOINT_LIST API_HOST@"/v2/api/categories/{category_id}/articles/?page={page}&size={size}";

//文章--获取文章详情
#define FE_ARTICLE_DETAILS API_HOST@"/v2/api/articles/{article_id}";

//文章--文章收藏
#define FE_ARTICLE_COLLECT API_HOST@"/v2/api/articles/{article_id}/actions/favorite";

//文章--文章点赞
#define FE_ARTICLE_LIKE API_HOST@"/v2/api/articles/{article_id}/actions/like";

//文章--文章收藏列表
#define FE_ARTICLE_CLOOECT_LIST API_HOST@"/v2/api/articles/{user_id}/favorites";

//获取文章的评论列表
#define FE_ARTICLE_COMMENT_LIST API_HOST@"/v2/api/ref_comments/{article_id}/comments/{type}";

//文章评论
#define FE_ARTICLE_COMMENT API_HOST@"/v2/api/ref_comments/{article_id}/actions/comment";

//获取文章的评论列表
#define FE_ARTICLE_COMMENT_LIST_PAGE API_HOST@"/v2/api/ref_comments/{article_id}/comments/{type}?page={page}&size={size}"

//获取孩子测评列表【当前有效的测评，并返回测评下的场景列表】
#define FE_ADJECTIVE_EVALUATE API_HOST@"/v2/api/children/{child_id}/exam_with_topics";

//【我的智评】历史测评列表
#define FE_RECORD_EVALUATE API_HOST@"/v2/api/children/{child_id}/exams/history?page={page}&size={size}";

//【我的智评】历史专题列表
#define FE_SEMINAR_EVALUATE API_HOST@"/v2/api/children/{child_id}/seminars/history?page={page}&size={size}";

//【我的智评】测评历史中，某一个测评下的场景列表
#define FE_RECORD_DETAIL_EVALUATE API_HOST@"/v2/api/children/{child_id}/exams/{exam_id}/topics";


//获取报告
#define FE_URL_CHILD_REPORTS API_HOST@"/v2/api/exams/reports?child_exam_id={child_exam_id}&relation_id={relation_id}&relation_type={relation_type}&compare_id={compare_id}";

//获取孩子个人报告(动态) [GET]
#define FE_URL_CHILD_DYNA_REPORTS API_HOST@"/v2/api/reports/students/{child_exam_id}?relation_id={relation_id}&relation_type={relation_type}&sample_id={sample_id}";

//获取往期测评
#define FE_URL_REPORTS_PAST API_HOST@"/v2/exams/{topic_id}/history?child_id={child_id}";

//获取孩子个人报告的推荐文章 [GET]
#define FE_URL_REPORTS_RECOMMEND API_HOST@"/v2/api/exams/reports/actions/get_recommend_articles?child_exam_id={child_exam_id}&relation_id={relation_id}&relation_type={relation_type}&compare_id={compare_id}";


//积分使用规则说明
#define FE_URL_SCORE_DESCRIPTION @"http://cheersmind.com/about/description/score.html";

//获取专题海报接口 [GET]
#define FE_URL_SEMINARS API_HOST@"/v2/api/children/{child_id}/seminars";


/*
 **************** 发展测评及生涯相关接口  **********************************************
 */
//获取发展测评模块列表
#define FE_URL_DEVELOP_EVALUATE API_HOST@"/v2/api/children/{child_id}/child_modules?page={page}&size={size}&type={type}";

//获取生涯规划任务列表
#define FE_URL_CAREER_TASKS API_HOST@"/v2/api/children/{child_id}/child_career_tasks?page={page}&size={size}";

//获取模块下任务列表
#define FE_URL_DEVELOP_TASKS API_HOST@"/v2/api/children/{child_id}/child_tasks?child_module_id={child_module_id}&page={page}&size={size}";

//获取任务下的项列表
#define FE_URL_TASK_ITEMS API_HOST@"/v2/api/children/{child_id}/child_task_items?child_task_id={child_task_id}&page={page}&size={size}";

//获取可添加的自定义任务列表
#define FE_URL_CAN_ADD_TASKS API_HOST@"/v2/api/children/{child_id}/available_tasks?child_module_id={child_module_id}&page={page}&size={size}";

//添加自定义任务
#define FE_URL_ADD_TASKS API_HOST@"/v2/api/children/{child_id}/custom_tasks";

/*
 *新课程
 *
 */
// 获取课程列表
#define FE_URL_COURSE_LIST API_HOST@"/v2/api/exams/courses/students/{student_id}?page={page}&size={size}"

// 课程报名
#define FE_URL_COURSE_REGISTRATE API_HOST@"/v2/api/exams/{exam_id}/students/{student_id}/apply"
// 课程详情
#define FE_URL_COURSE_DETAIL  API_HOST@"/v2/api/exams/{exam_id}/courses/{course_id}/students"

//完成课时
#define FE_URL_COURSE_COMPLETE_LESSON API_HOST@"/v2/api/exams/lessons/finish"

//课时文章推荐阅读
#define FE_URL_COURSE_ARTICLE_RECOMMEND API_HOST@"/v2/api/articles/{article_id}/external/recommend"
//课时文章参考资料
#define FE_URL_COURSE_ARTICLE_REFERENCE API_HOST@"/v2/api/articles/{article_id}/reference"

/*
*新选科助手
*
*/
#define FE_URL_ELECTIVE_REPORT API_HOST@"/v3/api/assistant/{child_exam_id}/report"

#define FE_URL_ELECTIVE_MAJOR_CATEGORY API_HOST@"/v2/api/major_list"

#define FE_URL_ELECTIVE_MAJOR_LIST API_HOST@"/v2/api/children/{child_id}/recommend_majors?child_exam_id={child_exam_id}&page={page}&size={size}"

#define FE_URL_ELECTIVE_EVALUATION_DIMENSIONS API_HOST@"/v3/api/assistant/overview/{child_exam_id}"


//完成文章阅读,完成观看视频等
#define FE_URL_COMPLETE_ARTICLE API_HOST@"/v2/api/children/{child_id}/complete_item";

//获取用户已经获取勋章
#define FE_URL_HAD_MEDALS API_HOST@"/v2/api/medals/obtained";

//获取系统所有勋章列表
#define FE_URL_ALL_MEDALS API_HOST@"/v2/api/medals";

//获取个人发展档案
#define FE_URL_TRACK_RECORD API_HOST@"/v2/api/growth/{child_id}";

//获取推荐学科
#define FE_URL_RECOMMEND_DISCIPLINE API_HOST@"/v2/api/careers/subjects/{child_exam_id}/{topic_id}/recommend";

//添加用户自选学科
#define FE_URL_ADD_RECOMMEND_DISCIPLINE API_HOST@"/v2/api/careers/subjects/{child_exam_id}/{topic_id}";

//获取场景下的量表列表
#define FE_URL_GET_TOPIC_DISCIPLINES API_HOST@"/v2/api/children/{child_id}/child_dimensions?child_exam_id={child_exam_id}&topic_id={topic_id}";

/**
 * *******学校、专业、职业*************
 */

//获取省份
#define FE_URL_UNIVERSITY_PROVINCE API_HOST@"/v2/api/sy/regions?page=1&size=50";

//学历层级
#define FE_URL_UNIVERSITY_DEGREES API_HOST@"/v2/api/sy/degrees";

//学校大全
#define FE_URL_UNIVERSITYS API_HOST@"/v2/api/sy/universities?ranking_key={ranking_key}&china_degree={china_degree}&state={state}&page={page}&size={size}";

//获取学校基本信息
#define FE_URL_UNIVERSITY_INFO API_HOST@"/v2/api/sy/universities/{university_id}/basic_info";

//获取学校概况
#define FE_URL_UNIVERSITY_SITUATION API_HOST@"/v2/api/sy/universities/{university_id}/general_situation";

//学校相关-招生录取-招生办信息-招生简章
#define FE_URL_UNIVERSITY_STU_RECIUITMENT_BRO API_HOST@"/v2/api/sy/universities/{universities_id}/enrollment_infos";

//学校相关-学校毕业信息
#define FE_URL_UNIVERSITY_GRADUATION API_HOST@"/v2/api/sy/universities/{university_id}/graduation_info";

//学校相关-招生录取-年份
#define FE_URL_UNIVERSITY_RECIUITMENT_YRAR API_HOST@"/v2/api/sy/gaokao/years";

//学校相关-招生录取-文理分科
#define FE_URL_UNIVERSITY_RECIUITMENT_WLFK API_HOST@"/v2/api/sy/gaokao/provinces/{province}/years/{year}/kinds";

//学校相关-招生录取-批次
#define FE_URL_UNIVERSITY_RECIUITMENT_PICI API_HOST@"/v2/api/sy/gaokao/provinces/{province}/years/{year}/bkcc_batchs";

//学校相关-招生录取-院校录取
#define FE_URL_UNIVERSITY_RECIUITMENT_YXLQ API_HOST@"/v2/api/sy/gaokao/score_line_university?province={province}&kind={kind}&school={school}";

//学校相关-开设专业
#define FE_URL_UNIVERSITY_PROFESSIONALS API_HOST@"/v2/api/sy/universities/{university_id}/major_special";

//学校相关-专业-重点学科
#define FE_URL_UNIVERSITY_PROFESSIONALS_KEY API_HOST@"/v2/api/sy/universities/{university_id}/major/national_key/{national_key}";

//学校相关-招生录取-专业录取
#define FE_URL_UNIVERSITY_RECIUITMENT_ZYLQ API_HOST@"/v2/api/sy/gaokao/score_line_majors?province={province}&kind={kind}&year={year}&school={school}";





//获取专业列表
#define FE_URL_PROFESSIONAL_LIST API_HOST@"/v2/api/careers/majors?edu_level={edu_level}&major_name={major_name}";

//获取专业详情
#define FE_URL_PROFESSIONAL_DETAILS API_HOST@"/v2/api/careers/majors/{major_code}";

//获取专业的开设院校
#define FE_URL_PROFESSIONAL_UNIVERSITYS API_HOST@"/v2/api/careers/majors/{major_code}/universities?state={state}&page={page}&size={size}";

//获取职业列表-(不用这种方式展示)
#define FE_URL_OCCUPATION_LIST API_HOST@"/v2/api/careers/occupations?occupation_name={occupation_name}";

//获取职业详情
#define FE_URL_OCCUPATION_DETAILS API_HOST@"/v2/api/careers/occupations/{occupation_id}";

//获取职业分类 [GET]
#define FE_URL_OCCUPATION_TYPE API_HOST@"/v2/api/careers/occupations/category?type={type}";

//获取职业列表-(new)
#define FE_URL_OCCUPATION_LIST_CATEGORY API_HOST@"/v2/api/careers/occupations?category={category}&area_id={area_id}&occupation_name={occupation_name}&page={page}&size={size}";

//生涯关注相关-关注
#define FE_URL_CARMMER_FOLLOWS API_HOST@"/v2/api/sy/follows";

//生涯关注相关-关注列表
#define FE_URL_MY_FOLLOWS API_HOST@"/v2/api/sy/follows/types/{type}";


/**
 * 获取场景或量表个人报告 2019.3
 * child_exam_id：学生考试ID
 * relation_id：维度ID（必填）
 * relation_type：维度类型（topic_dimension - 话题下的主题，topic - 话题 ，必填 ）
 * compare_id：对比样本ID( 0-全国，1- 八大区，2-省，3-市，4-区)
 */

#define FE_URL_CAREER_REPORT API_HOST@"/v2/api/exams/personal/reports?child_exam_id={child_exam_id}&relation_id={relation_id}&relation_type={relation_type}&compare_id={compare_id}";

//内容推荐 - 个人报告
#define FE_URL_REPORT_RECOMMEND API_HOST@"/v2/api/exams/personal/reports/recommend/{relation_id}?child_exam_id={child_exam_id}";

//生涯发展档案
#define FE_URL_PERSONAL_ARCHIVES API_HOST@"/v2/api/archives/growth/{child_exam_id}";

//能力发展档案
#define FE_URL_ABILITY_ARCHIVES API_HOST@"/v2/api/archives/growth/capability/{child_id}";

//选科助手-获取专业列表
#define FE_URL_RECOMMEND_PROFESSIONAL API_HOST@"/v2/api/children/{child_id}/recommend_majors?child_exam_id={child_exam_id}&from_types={from_types}&page={page}&size={size}";

//选科助手-系统推荐
#define FE_URL_SYSTEM_RECOMMEND API_HOST@"/v2/api/assistant/overview/{child_exam_id}";

//获取选科学科列表
#define FE_URL_SUBJECTS_LIST API_HOST@"/v2/api/children/{child_id}/optional_subjects";

//确认选科
#define FE_URL_SURE_SUBJECTS API_HOST@"/v2/api/children/{child_id}/confirm_subjects";

//学科助手-获取专业列表(可报考和高要求)
#define FE_URL_ZSBK_PROFESSIONAL API_HOST@"/v2/api/children/{child_id}/subject_group_majors?subject_group={subject_group}&type={type}&page={page}&size={size}";

//获取意向专业列表
#define FE_URL_INTENTION_MAJORS API_HOST@"/v2/api/children/{child_id}/follow_majors?page={page}&size={size}";

//保存意向专业列表
#define FE_URL_SAVE_INTENTION_MAJORS API_HOST@"/v2/api/children/{child_id}/follow_majors";

//根据选科组合获取专业覆盖率
#define FE_URL_SUBJECT_COVERAGE API_HOST@"/v2/api/children/{child_id}/subject_group_major_rate?subject_group={subject_group}";

//获取用户选科组合列表
#define FE_URL_CONFIRM_SUBJECTS API_HOST@"/v2/api/children/{child_id}/confirm_subjects?child_exam_id={child_exam_id}";

//内容管理-首页轮播列表
#define FE_URL_HOME_DISSEMINATES API_HOST@"/v2/api/home_disseminates";

//获取用户可选择选科组合列表
#define FE_URL_GROUP_SUBJECTS API_HOST@"/v2/api/children/{child_id}/group_subjects?child_exam_id={child_exam_id}";

//评价管理-获取评价内容列表
#define FE_URL_REPORT_EVALUATE API_HOST@"/v2/api/evaluates/{ref_id}/items?type={type}&child_id={child_id}";

//评价管理-用户评价
#define FE_URL_COMMIT_REPORT_EVALUATE API_HOST@"/v2/api/evaluates/{item_id}/{ref_id}?child_id={child_id}";


//-------------------------------七月测评----------------------------------

//获取智评首页数据
#define FE_URL_GET_EVALUATIONS_HOMEPAGE API_HOST@"/v2/api/exams?status={status}&exam_type={exam_type}&child_id={child_id}&page={page}&size={size}&sub_item={sub_item}"
//获取智评项列表数据
#define FE_URL_GET_EVALUATIONS_ITEMLIST API_HOST@"/v2/api/topics?exam_id={exam_id}&child_id={child_id}&page={page}&size={size}"

#define FE_URL_GET_EVALUATIONS_DETAIL API_HOST@"/v2/api/topics/{topic_id}/dimensions?child_exam_id={child_exam_id}"


#define FE_URL_GET_EVALUATIONS_HISTORY API_HOST@"/v2/api/dimensions/{dimension_id}/{child_id}/history"


#define FE_URL_GET_DIMENSION_EVALUATE_TITLE_LIST API_HOST@"/v2/api/evaluates/evaluate_title_list"
#define FE_URL_GET_DIMENSION_EVALUATES API_HOST@"/v2/api/evaluates/users_evaluates/title/{title_id}/object/{unique_id}"

#define FE_URL_GET_AUDIO_LIST API_HOST@"/v2/api/courses/{course_id}/audios"

#define FE_URL_DIMENSION_DETAIL API_HOST@"/2c/v1/dimensions/{dimension_id}?child_id={child_id}"





#define URL_PROJECT_LIST API_HOST@"/v0.1/projects?flag=1"
#define URL_PROJECT_ALL API_HOST@"/v0.1/projects/all?childId={child_id}"
#define URL_SCENE_LIST API_HOST@"/v0.1/scenes?projectId={project_id}&childId={child_id}"
#define URL_USER_SCENE_LATEST API_HOST@"/v0.1/userScenes/latest/report/{scene_id}/{child_id}"

#define URL_RECORD_LIST API_HOST@"/v0.1/userScenes?uid={uid}&childId={child_id}&rows=10000&page=1"
#define URL_PLAYER WEB_HOST@"/player.html?scene={scene_id}&uid={uid}&childId={child_id}"
//#define URL_REPORT WEB_HOST@"/report.html?scene={scene_id}&uid={uid}&childId={child_id}"






#pragma mark - C端接口
//获取商品分类(废弃)
#define TC_URL_GET_PRODUCT_CATEGORY API_HOST@"/v2/api/categories?client_type={client_type}&child_id={child_id}&period={period}&type={type}"
//获取智评商品列表
#define TC_URL_GET_TEST_PRODUCT_LIST API_HOST@"/2c/v1/dimensions?page={page}&size={size}&category_id={category_id}&is_best={is_best}&is_own={is_own}&child_id={child_id}&period={period}"
//创建订单
#define TC_URL_POST_ORDER_CREATE API_HOST@"/2c/v1/orders"

//开始量表
#define TC_URL_POST_DIMENSION_START API_HOST@"/2c/v1/dimensions/{dimension_id}/start"

//获取非合并答题题目
#define TC_URL_GET_DIMENSION_QUESTIONS API_HOST@"/2c/v1/dimensions/{child_dimension_id}/questions"

//获取合并答题题目
#define TC_URL_GET_DIMENSION_QUESTIONS_MERGE API_HOST@"/2c/v1/dimensions/{child_dimension_id}/questions/merge"

//保存答题
#define TC_URL_POST_DIMENSION_SAVE API_HOST@"/2c/v1/dimensions/{child_dimension_id}/save"

//提交答题
#define TC_URL_POST_DIMENSION_SUBMIT API_HOST@"/2c/v1/dimensions/{child_dimension_id}/submit"

//获取报告
#define TC_URL_GET_DIMENSION_REPORT API_HOST@"/2c/v1/dimensions/{child_dimension_id}/reports"

//获取课程商品列表
#define TC_URL_GET_COURSE_PRODUCT_LIST API_HOST@"/2c/v1/courses"

//获取课程详情
#define TC_URL_GET_COURSE_DETAIL API_HOST@"/2c/v1/courses/{course_id}"

//获取课程音频列表
#define TC_URL_GET_AUDIO_LIST API_HOST@"/2c/v1/courses/{course_id}/audios"

//获取课程文章
#define TC_URL_GET_COURSE_ARTICLE API_HOST@"/2c/v1/courses/{course_id}/article/{article_id}"

//完成文章课时
#define TC_URL_POST_COURSE_LESSON_FINISH API_HOST@"/2c/v1/courses/lessons/finish"




//获取生涯助手测评
#define TC_URL_GET_ELECTIVE_DIMENSIONS API_HOST@"/2c/v1/careers/dimensions?child_exam_id={child_exam_id}"

//获取生涯报告
#define TC_URL_GET_ELECTIVE_REPORT API_HOST@"/2c/v1/careers/report?child_exam_id={child_exam_id}"

//确认生涯选科决策
#define TC_URL_POST_ELECTIVE_DECISION_SUBMIT API_HOST@"/2c/v1/careers/subjects/decision"

//获取生涯选科决策
#define TC_URL_GET_ELECTIVE_DECISON API_HOST@"/2c/v1/careers/subjects/decision?child_exam_id={child_exam_id}"

//添加意向专业
#define TC_URL_POST_ELECTIVE_INTENTION_MAJOR_SUBMIT API_HOST@"/2c/v1/careers/majors/{child_id}/intention"

//获取生涯意向专业
#define TC_URL_GET_ELECTIVE_INTENTION_MAJOR API_HOST@"/2c/v1/careers/majors/{child_id}/intention";

//获取测评报告推荐
#define TC_URL_GET_TEST_REPORT_RECOMMEND API_HOST@"/v2/api/articles/{dimension_id}/dimension/recommend?page={page}&size={size}"

//"/v2/api/exams/reports/actions/get_recommend_articles?page={page}&size={size}&relation_id={relation_id}&relation_type=dimension&&child_exam_id={child_exam_id}"

//"/2c/v1/articles/recommend?page={page}&size={size}&dimension_id={dimension_id}&child_id={child_id}";


//获取商品的历史订单
#define TC_URL_GET_ORDER_RECORD API_HOST@"/2c/v1/orders?product_type={product_type}&page={page}&size={size}"

//获取代币的购买记录(订单)
#define TC_URL_GET_EMONEY_ORDER_RECORD API_HOST@"/2c/v1/emoney/my_emoney_buy_his?page={page}&size={size}"

//获取代币的商品列表
#define TC_URL_GET_EMONEY_PRODUCT_LIST  API_HOST@"/2c/v1/emoney/emoney_iap_product"

//获取我的代币余额
#define TC_URL_GET_MY_EMONEY_BALANCE  API_HOST@"/2c/v1/emoney/my_emoney"

//创建代币订单
#define TC_URL_POST_EMONEY_ORDER_CREATION API_HOST@"/2c/v1/orders/emoney"

//验证IAP订单并完成订单
#define TC_URL_POST_IAP_ORDER_VALIDATE API_HOST@"/2c/v1/orders/validate/iap"

//搜索文章、测评、课程
#define TC_URL_GET_DISCOVERY_SEARCH API_HOST@"/2c/v1/search/discover?page={page}&size={size}&type={type}&filter={filter}"

//测评报告推荐商品
#define TC_URL_GET_TEST_REPORT_RECOMMEND_PRODUCT API_HOST@"/2c/v1/dimensions/{dimension_id}/recommand_product_both"

//统计发现页轮播图点击
#define TC_URL_PUT_DISSEMINATES_CLICK API_HOST@"/v2/api/home_disseminates/{id}/click"

//获取UUID加密公钥
#define TC_URL_GET_UUID_RSA_PUBLIC_KEY API_HOST@"/v2/oauth2/server/rsa"

//检查UUID是否注册
#define TC_URL_POST_UUID_REGISTER_CHECK API_HOST@"/v1/accounts/device/check"

//uuid注册并登录（之前检测不存在设备账户时）
#define TC_URL_POST_UUID_REGISTER API_HOST@"/v1/accounts/device/reg"

//完善设备账号信息
#define TC_URL_POST_DEVICE_ACCOUNT_INFO_PERFECTION API_HOST@"/2c/v1/users/children/for_device"

//更新Token
#define TC_URL_POST_TOKEN_REFRESH API_HOST@"/v2/oauth2/tokens/actions/{refresh_token}?persist=0"

//设备登录
#define TC_URL_POST_DEVICE_ACCOUNT_LOGIN API_HOST@"/v2/accounts/device/login"


//分类系统配置
#define TC_URL_GET_CATEGORY_SYSTEM_CONFIG API_HOST@"/v1/system/constants?realm={realm}"

//分类数
#define TC_URL_GET_CATEGORY_TREE API_HOST@"/v1/categories?stage={stage}&type={type}&client_type=2"

//app分享地址
#define TC_URL_GET_APP_RECOMMEND_URL API_HOST@"/v1/share/apps/ios/address"

//获取测评历史记录
#define TC_URL_GET_TEST_HISTORY API_HOST@"/2c/v1/dimensions/{dimension_id}/children/{child_id}/history"

#pragma mark - mjb
#define PA_URL_POST_ACCOUNT_REGISTER API_HOST@"/v2/oauth2/sign_up"
#endif /* HttpConfig_h */
