//
//  NSString+Utils.m
//  Toos
//
//  Created by xiaoming on 15/1/30.
//  Copyright (c) 2015年 xiaoming. All rights reserved.
//

#import "NSString+Utils.h"
#import <CommonCrypto/CommonDigest.h>
// 解析域名用的
#include <netdb.h>
#include <arpa/inet.h>

@implementation NSString (Utils)



- (BOOL)isNumber {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < self.length) {
        NSString * string = [self substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}


+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

+(NSString *)removeTrimmingBlank:(NSString *)string{
    NSString *temp = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return temp;
    
}

+(NSString *)removeAllBlank:(NSString *)string{
    NSString *resultString = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return resultString;
}

- (NSString*)md5String{
    if (self == nil || [self length] == 0){
        return @"";
    }
    const char *value = [self UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}

- (id)jsonValue{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    if (!data){
        NSLog(@"解析json字符串出错！");
        return nil;
    }
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error){
        NSLog(@"解析json字符串出错！");
    }
    return result;
}

- (BOOL)stringContainsSubString:(NSString *)subString {
    NSRange aRange = [self rangeOfString:subString];
    if (aRange.location == NSNotFound) {
        return NO;
    }
    
    return YES;
}

- (BOOL)matchStringWithRegextes:(NSString*)regString{
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regString];
    BOOL result = [predicate evaluateWithObject:self];
    return result;
}

- (NSData*)hexData{

    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx + 2 <= self.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [self substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}


- (BOOL)isEmpty {
    return [NSString isEmptyString:self];
}

+ (BOOL)isEmptyString:(NSString *)string {
    if (string == nil) {
        return YES;
    }
    
    if ([string isKindOfClass:[[NSNull null] class]]) {
        return YES;
    }
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }
    
    if ([string isEqualToString:@"null"]) {
        return YES;
    }
    
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    
    return NO;
}

+(NSString *)clipZero:(NSString *)string{
    if (!string) {
        return nil;
    }
    if ([string rangeOfString:@"."].location == NSNotFound) {
        return string;
    }
    
    for (int i = 0; i < 2; ++i) {
        if ([string hasSuffix:@"0"]) {
            string = [string substringToIndex:string.length - 1];
        }
    }
    if ([string hasSuffix:@"."]) {
        string = [string substringToIndex:string.length - 1];
    }
    return string;
}

+ (NSString *)getCurrentTimeString {
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}

- (BOOL)isValidEmail {
    NSString *emailPattern =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:emailPattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
    return match != nil;
}

- (BOOL)isChinese
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}


- (CGSize)getSizeForFont:(UIFont *)font {
    CGSize fontSize = [self sizeWithAttributes:@{NSFontAttributeName : font}];
    return fontSize;
}

- (CGSize)getSizeForFont:(UIFont *)font size:(CGSize)size lineSpacing:(NSNumber *)lineSpacing mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            if (lineSpacing != nil) {
                paragraphStyle.lineSpacing = [lineSpacing floatValue];
            }
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

- (CGFloat)getWidthForFont:(UIFont *)font {
    CGSize size = [self getSizeForFont:font size:CGSizeMake(HUGE, HUGE) lineSpacing:nil mode:NSLineBreakByCharWrapping];
    return size.width;
}

- (CGFloat)getHeightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self getSizeForFont:font size:CGSizeMake(width, HUGE) lineSpacing:nil mode:NSLineBreakByCharWrapping];
    return size.height;
}

- (CGFloat)getHeightForFont:(UIFont *)font width:(CGFloat)width lineSpacing:(NSNumber *)lineSpacing {
    CGSize size = [self getSizeForFont:font size:CGSizeMake(width, HUGE) lineSpacing:lineSpacing mode:NSLineBreakByCharWrapping];
      return size.height;
}


- (NSString *)rangeWithStartString:(NSString *)startString withEndString:(NSString *)endString
{
    NSRange startRange = [self rangeOfString:startString];
    NSRange endRange = [self rangeOfString:endString];
    if (startRange.length== 0 || endRange.length == 0)
    {
        return @"";
    }
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    NSString *result = [self substringWithRange:range];
    
    return result;
}

+ (NSString *)textFieldLimitWithMaxLength:(int)maxTextLength resultString:(NSString *)resultString textField:(UITextField *)textField {
    NSString *toBeString = textField.text;
    
    resultString = textField.text;
    //业务逻辑
    NSString *lang = textField.textInputMode.primaryLanguage; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            //业务逻辑
            if (toBeString.length > maxTextLength) {
                textField.text = [toBeString substringToIndex:maxTextLength];
                resultString = [textField.text substringToIndex:maxTextLength];
            } else {
                resultString = textField.text;
            }
        }
        
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else {
        //业务逻辑
        if (toBeString.length > maxTextLength) {
            textField.text = [toBeString substringToIndex:maxTextLength];
            resultString = [textField.text substringToIndex:maxTextLength];
        } else {
            resultString = textField.text;
        }
    }
    
    return resultString;
}


+ (NSString *)textViewLimitWithMaxLength:(int)maxTextLength resultString:(NSString *)resultString textView:(UITextView *)textView {
    NSString *toBeString = textView.text;
    
    //resultString = textView.text;//业务逻辑
    //    NSString *lang = textView.textInputMode.primaryLanguage; // 键盘输入模式
    
    //    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
    //        UITextRange *selectedRange = [textView markedTextRange];
    //        //获取高亮部分
    //        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    //
    //        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    //        if (!position) {
    //            //业务逻辑
    //            if (toBeString.length > maxTextLength) {
    //                textView.text = [toBeString substringToIndex:maxTextLength];
    //                resultString = [textView.text substringToIndex:maxTextLength];
    //            } else {
    //                resultString = textView.text;
    //            }
    //        } else {
    ////            if (toBeString.length > maxTextLength) {
    ////                textView.text = [toBeString substringToIndex:maxTextLength];
    ////                resultString = [textView.text substringToIndex:maxTextLength];
    ////            } else {
    ////                resultString = textView.text;
    ////            }
    //        }
    //
    //        // 有高亮选择的字符串，则暂不对文字进行统计和限制
    //    }
    //    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    //    else {
    //业务逻辑
    if (toBeString.length > maxTextLength) {
        textView.text = [toBeString substringToIndex:maxTextLength];
        resultString = [textView.text substringToIndex:maxTextLength];
    } else {
        resultString = textView.text;
    }
    //    }
    
    return resultString;
}

+ (NSString *)getAsteriskString:(NSString *)oldString
{
    NSString *newString = nil;
    if ([NSString isEmptyString:oldString]) {
        return @"";
    }
    if ([oldString containsString:@"@"]) { // 邮箱
        NSString *leftString = [oldString componentsSeparatedByString:@"@"][0];
        if (leftString.length > 4) { // @符号前长度大于4个字符
            if (leftString.length == 5) {
                newString = [NSString stringWithFormat:@"%@****%@",[leftString substringToIndex:leftString.length - 4],[oldString substringFromIndex:[oldString rangeOfString:@"@"].location]];
            } else { // 大于5的情况
                newString = [NSString stringWithFormat:@"%@****%@",[leftString substringToIndex:(leftString.length - 3)/2],[oldString substringFromIndex:(leftString.length - 3)/2 + 4]];
            }
        } else { // @符号前长度小于4个字符
            NSString *star = @"*";
            if (leftString.length == 2) {
                star = @"**";
            } else if (leftString.length == 3) {
                star = @"***";
            } else if (leftString.length == 4) {
                star = @"****";
            }
            newString = [NSString stringWithFormat:@"%@%@",star,[oldString substringFromIndex:[oldString rangeOfString:@"@"].location]];
        }
    } else { // 手机号
        if (oldString.length > 7) {
            newString = [NSString stringWithFormat:@"%@****%@",[oldString substringToIndex:oldString.length - 8],[oldString substringFromIndex:oldString.length - 4]];
        } else {
            newString = oldString;
        }
    }
    return newString;
}

+ (NSString*)getIPWithHostName:(const NSString*)hostName {
    const char *hostN= [hostName UTF8String];
    struct hostent* phot;
    @try {
        phot = gethostbyname(hostN);
    } @catch (NSException *exception) {
        return nil;
    }
    struct in_addr ip_addr;
    if (phot == NULL) {
        NSLog(@"获取失败");
        return nil;
    }
    memcpy(&ip_addr, phot->h_addr_list[0], 4);
    char ip[20] = {0}; inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
    NSString* strIPAddress = [NSString stringWithUTF8String:ip];
    NSLog(@"ip=====%@",strIPAddress);
    return strIPAddress;
}

/// 获取电话号码
+ (NSString *)getPhoneNumber:(NSString *)phoneNumber {
    NSString *lastStr = @"";
    if ([NSString isEmptyString:phoneNumber]) {
        return lastStr;
    } else {
       // lastStr = [phoneNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
        lastStr = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    return  lastStr;
}

+ (NSString *)getVideoUrlString:(NSString *)videoUrlStr {
    if ([videoUrlStr containsString:@"/offset/1/w/"]) {
//        NSString *lastStr = [videoUrlStr substringToIndex:[videoUrlStr rangeOfString:@"/offset/1/w/"].location + 9];
//        return lastStr;
        NSString *lastStr = [videoUrlStr stringByReplacingOccurrencesOfString:@"/offset/1/w/" withString:@"/offset/0/w/"];
        return lastStr;
    } else {
        return videoUrlStr;
    }
}


+ (BOOL)validateContactNumber:(NSString *)telNum
{
    telNum = [telNum stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([telNum length] != 11) {
        return NO;
    }
    
    /**
     * 中国移动：China Mobile
     *13[4-9],147,148,15[0-2,7-9],165,170[3,5,6],172,178,18[2-4,7-8],19[5,8]
     */
    NSString *CM_NUM = @"^((13[4-9])|(14[7-8])|(15[0-2,7-9])|(165)|(178)|(18[2-4,7-8])|(19[5,8]))\\d{8}|(170[3,5,6])\\d{7}$";
    
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,146,155,156,166,167,170[4,7,8,9],171,175,176,185,186
     */
    NSString *CU_NUM = @"^((13[0-2])|(14[5,6])|(15[5-6])|(16[6-7])|(17[1,5,6])|(18[5,6]))\\d{8}|(170[4,7-9])\\d{7}$";
    
    /**
     * 中国电信：China Telecom
     * 133,149,153,162,170[0,1,2],173,174[0-5],177,180,181,189,19[1,3,9]
     */
    NSString *CT_NUM = @"^((133)|(149)|(153)|(162)|(17[3,7])|(18[0,1,9])|(19[1,3,9]))\\d{8}|((170[0-2])|(174[0-5]))\\d{7}$";
    
    NSPredicate *pred_CM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM_NUM];
    NSPredicate *pred_CU = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU_NUM];
    NSPredicate *pred_CT = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT_NUM];
    BOOL isMatch_CM = [pred_CM evaluateWithObject:telNum];
    BOOL isMatch_CU = [pred_CU evaluateWithObject:telNum];
    BOOL isMatch_CT = [pred_CT evaluateWithObject:telNum];
    if (isMatch_CM || isMatch_CT || isMatch_CU) {
        return YES;
    }
    
    return NO;
}

+ (NSString *)formatFloatNumber:(NSNumber *)floatNumber AfterDecimalPoint:(NSInteger)digit {
    NSString *floatNumberString = [NSString stringWithFormat:@"%@", floatNumber];
    if ([floatNumberString containsString:@"."]){//取消小数点后2位
        NSRange range = [floatNumberString rangeOfString:@"."];
        NSString *behindDotString = [floatNumberString substringFromIndex:range.location];
        if (behindDotString.length > digit + 1) {
            floatNumberString = [floatNumberString substringToIndex:range.location + digit + 1];
        }
    }
    return floatNumberString;
}
@end
