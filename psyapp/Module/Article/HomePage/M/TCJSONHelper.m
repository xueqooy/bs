//
//  TCJSONHelper.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/27.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCJSONHelper.h"

@implementation TCJSONHelper
+ (NSString *)JSONStringWithDictionary:(NSDictionary *)dictionary {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonString = trim(jsonString);
    
    return jsonString;
}


+ (NSString *)JSONStringWithArray:(NSArray *)array

 {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     jsonString = trim(jsonString);
    return jsonString;
}

NSString *trim(NSString *string) {
   NSString *result = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return  result;
}
@end
