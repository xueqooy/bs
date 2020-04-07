//
//  NSString+Utils.m
//  Toos
//
//  Created by xiaoming on 15/1/30.
//  Copyright (c) 2015年 xiaoming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Utils)


+ (BOOL)stringContainsEmoji:(NSString *)string;       // 判断字符串是否含表情

+(NSString *)removeTrimmingBlank:(NSString *)string;  // 去除两端空格

+(NSString *)removeAllBlank:(NSString *)string;       // 去除所有空格

- (NSString*)md5String;                               // 进行16位小写MD5加密.

- (id)jsonValue;                                      // 把 JSON 字符串转为 NSDictionary 或者 NSArray(需强制转换)

+ (BOOL)isEmptyString:(NSString *)string;             // 判断一个字符串是否为空字符串

- (BOOL)stringContainsSubString:(NSString *)subString;// 判断是否包含另一个字符串

- (BOOL)matchStringWithRegextes:(NSString*)regString; // 判断是否匹配正则表达式regString为正则表达式

- (NSData*)hexData;                                   // 将16进制字符串转换为NSData
+(NSString *)clipZero:(NSString *)string;             // 去掉float类型数据后面的无效的0(必须是有两个小数的时候才能用)

+(NSString *)getCurrentTimeString;                    // 获取当前时间的时间戳。

- (BOOL)isValidEmail;                                 // 判断邮箱是否可用

- (BOOL)isChinese;                                    // 判断中文

- (BOOL)isNumber;                                      //判断数字

- (BOOL)isEmpty;

- (CGSize)getSizeForFont:(UIFont *)font;              // 获取字符串的size

- (CGSize)getSizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

- (CGFloat)getWidthForFont:(UIFont *)font;

- (CGFloat)getHeightForFont:(UIFont *)font width:(CGFloat)width;

- (CGFloat)getHeightForFont:(UIFont *)font width:(CGFloat)width lineSpacing:(NSNumber *)lineSpacing;


+ (NSString *)getAsteriskString:(NSString *)oldString;// 给手机号或者邮箱加*

+ (NSString*)getIPWithHostName:(const NSString*)hostName;//根据域名获取ip地址 - 可以用于控制APP的开关某一个入口，比接口方式速度快的多
+ (NSString *)getPhoneNumber:(NSString *)phoneNumber; // 获取电话号码

+ (NSString *)getVideoUrlString:(NSString *)videoUrlStr;//返回需要的视频图片

- (NSString *)rangeWithStartString:(NSString *)startString withEndString:(NSString *)endString;// 截取两个特殊字符串中间的字符串。
/**
 *  textFild 限制字数的方法
 *
 *  @param maxTextLength 最大长度
 *  @param resultString  返回的textField.text 的值 可以传空
 *  @param textField     textField 对象
 *
 *  @return 输入后的结果字符串
 */
// 使用self.textField rac_signalForControlEvents:UIControlEventEditingChanged
+ (NSString *)textFieldLimitWithMaxLength:(int)maxTextLength resultString:(NSString *)resultString textField:(UITextField *)textField;

/**
 *  textView 限制字数的方法
 *
 *  @param maxTextLength 最大长度
 *  @param resultString  返回的textView.text 的值 可以传空
 *  @param textView     textView 对象
 *
 *  @return 输入后的结果字符串
 */
//使用self.textView rac_textSignal
+ (NSString *)textViewLimitWithMaxLength:(int)maxTextLength resultString:(NSString *)resultString textView:(UITextView *)textView;

/*
 邮箱隐藏规则，
 1. 字符>5 位就隐藏@符中间的4位字符 例如：zhaoweiyu@speedx.com 隐藏后 zha****yu@speedx.com
 2. 字符=5位隐藏@后前4位     例如：weiyu@speedx.com 隐藏后 w****@speedx.com
 3. 字符<=4位就隐藏@符号前的全部字符 例如：eiyu@speedx.com  隐藏后 ****@speedx.com
 */



//验证手机号
+ (BOOL)validateContactNumber:(NSString *)mobileNum;

+ (NSString *)formatFloatNumber:(NSNumber *)floatNumber AfterDecimalPoint:(NSInteger)digit ;

@end
