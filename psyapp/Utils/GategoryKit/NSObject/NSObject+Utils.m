//
//  NSObject+Utils.m
//  RunTime
//
//  Created by 吴伟毅 on 18/8/5.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "NSObject+Utils.h"
#import <objc/runtime.h>
@implementation NSObject (Utils)
#pragma mark - 方法交换
- (void)swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    if(!originalMethod) {
        NSLog(@"没有找到交换的初始方法");
    }
    if(!swizzledMethod) {
        NSLog(@"没有找到交换的方法");
    }
    
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark - 字典转模型 根据字典转换模型，避免不必要的转换
+ (instancetype)modelWithDict:(NSDictionary *)dict{
    // 1.创建对应类的对象
    id objc = [[self alloc] init];
    // count:成员属性总数
    unsigned int count = 0;
    // 获得成员属性列表和成员属性数量
    Ivar *ivarList = class_copyIvarList(self, &count);
    for (int i = 0 ; i < count; i++) {
        // 获取成员属性
        Ivar ivar = ivarList[i];
        // 获取成员名
        NSString *propertyName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // 获取key
        NSString *key = [propertyName substringFromIndex:1];
        // 获取字典的value key:属性名 value:字典的值
        id value = dict[key];
        // 获取成员属性类型
        NSString *propertyType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        // 二级转换 适用于模型嵌套模型的转换
        // value值是字典并且成员属性的类型不是字典,才需要转换成模型。即该模型中的这个属性类型为模型切dict中的value为字典，就进行二级转换
        if ([value isKindOfClass:[NSDictionary class]] && ![propertyType containsString:@"NS"]) {
            // 进行二级转换
            // 获取二级模型类型进行字符串截取，转换为类名
            NSRange range = [propertyType rangeOfString:@"\""];
            propertyType = [propertyType substringFromIndex:range.location + range.length];
            range = [propertyType rangeOfString:@"\""];
            propertyType = [propertyType substringToIndex:range.location];
            // 获取需要转换类的类对象
            Class modelClass =  NSClassFromString(propertyType);
            // 如果类名不为空则进行二级转换
            if (modelClass) {
                // 返回二级模型赋值给value
                value =  [modelClass modelWithDict:value];
            }
        }
        if (value) {
            // KVC赋值:不能传空
            [objc setValue:value forKey:key];
        }
    }
    // 说明：由于ARC只适用于Foundation等框架，对于Core Foundation 和 runtime 等并不适用，所以在使用带有copy、retain等字样的函数或方法时需要手动释放free()。
    free(ivarList);
    // 返回模型
    return objc;
}
@end
