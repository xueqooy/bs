//
//  ZJChooseModel.h
//  smartapp
//
//  Created by lafang on 2019/2/20.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJChooseModel : NSObject

// 名字
@property(nonatomic ,copy) NSString *name;
// id
@property(nonatomic ,copy) NSString *res_id;
// 子数据
@property(nonatomic ,strong) NSArray *child_list;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)chooseWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
