//
//  NSObject+Utils.h
//  RunTime
//
//  Created by 吴伟毅 on 18/8/5.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Utils)
/*
 @对系统方法进行替换
 @param originalSelector 想要替换的方法
 @param swizzledSelector 实际替换为的方法
 */
- (void)swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

//字典转模型
+ (instancetype)modelWithDict:(NSDictionary *)dict;
@end
