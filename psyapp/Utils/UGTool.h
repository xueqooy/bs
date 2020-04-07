//
//  UGTool.h
//  smartapp
//
//  Created by mac on 2019/7/25.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGTool : NSObject
+ (NSString *)replacingStrings:(NSArray <NSString *>*)strings withObj:(NSArray *)objs forURL:(NSString *)url;
+ (NSString *)putParams:(NSDictionary *)params forURL:(NSString *)url;
+ (NSDictionary *)paramsWithURL:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
