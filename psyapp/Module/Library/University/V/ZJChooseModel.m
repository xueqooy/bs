//
//  ZJChooseModel.m
//  smartapp
//
//  Created by lafang on 2019/2/20.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "ZJChooseModel.h"

@implementation ZJChooseModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self == [super init]) {
        self.name = dict[@"name"];
        self.res_id = dict[@"res_id"];
        self.child_list = dict[@"child_list"];
    }
    return self;
}

+(instancetype)chooseWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}


@end
