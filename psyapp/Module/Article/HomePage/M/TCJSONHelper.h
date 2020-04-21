//
//  TCJSONHelper.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/27.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCJSONHelper : NSObject
+ (NSString *)JSONStringWithDictionary:(NSDictionary *)dictionary;
+ (NSString *)JSONStringWithArray:(NSArray *)array;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
