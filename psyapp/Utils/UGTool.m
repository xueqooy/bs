//
//  UGTool.m
//  smartapp
//
//  Created by mac on 2019/7/25.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UGTool.h"

@implementation UGTool
+ (NSString *)replacingStrings:(NSArray <NSString *>*)strings withObj:(NSArray *)objs forURL:(NSString *)url{
    if (objs.count > strings.count) return @"count error";
    int i = 0;
    for (id anObj in objs) {
        if ([anObj isKindOfClass:NSString.class]) {
            url = [url stringByReplacingOccurrencesOfString:strings[i] withString:anObj];
        } else if ([anObj isKindOfClass:NSValue.class]) {
            url = [url stringByReplacingOccurrencesOfString:strings[i] withString:[NSString stringWithFormat:@"%@",anObj]];
        } else {
            return  @"obj error" ;
        }
        i++;
    }
    return url;
}

+(NSString *)putParams:(NSDictionary *)params forURL:(NSString *)url {
    if (params == nil) {
        return url;
    }
    NSMutableString *newURL = [NSMutableString stringWithFormat:@"%@?", url];
    
    for (int i = 0; i < params.allKeys.count; i ++) {
        NSString *key = params.allKeys[i];
        if (i != params.allKeys.count - 1) {
            [newURL appendFormat:@"%@=%@&", key, params[key]];
        } else {
            [newURL appendFormat:@"%@=%@", key, params[key]];
        }
    }
    
    return newURL;

}

+ (NSDictionary *)paramsWithURL:(NSString *)url {
    NSMutableDictionary *params = @{}.mutableCopy;
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
    [components.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [params setObject:obj.value forKey:obj.name];
    }];
    return params;
}
@end
