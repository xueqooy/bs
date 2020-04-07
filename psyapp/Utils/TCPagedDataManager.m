//
//  TCPagedDataManager.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/16.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCPagedDataManager.h"
@interface TCPagedDataManager ()
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, assign) BOOL alreadyLoadData; //内部判断是否开始获取数据
@end

@implementation TCPagedDataManager {
    BOOL _alreadyLoadData_b;
    NSInteger _currentPage_b;
    NSInteger _total_b;
//    NSInteger _increment_b;
    NSMutableArray *_data_b;
    BOOL _hasBackups;
}
- (instancetype)init {
    self = [super init];
    [self resetData];
    _increment = 15;
    return self;
}

- (void)resetData {
    _alreadyLoadData = NO;
    _currentPage = 0;
    _total = 0;
    _data = @[].mutableCopy;
}

- (void)resetDataByBackups {
    _alreadyLoadData_b = _alreadyLoadData;
    _currentPage_b = _currentPage;
    _total_b = _total;
//    _increment_b = _increment;
    _data_b = _data;
    _hasBackups = YES;
    [self resetData];
}

- (void)recoveryDataIfNeeded {
    if (_hasBackups) {
        _alreadyLoadData = _alreadyLoadData_b;
        _currentPage = _currentPage_b;
        _total = _total_b;
        //    _increment = _increment_b;
        _data = _data_b;
        [self clearBackups];
    }
}

- (void)clearBackups {
    _alreadyLoadData_b = NO;
    _currentPage_b = 0;
    _total_b = 0;
//    _increment_b = 15;
    _data_b = nil;
    _hasBackups = NO;
}

- (void)loadDataOnCompletion:(void (^)(TCPagedDataManager * _Nonnull manager, BOOL failed))completion {
    @weakObj(self);
    if (self.dataGetter == nil) {
        [self recoveryDataIfNeeded];
        completion(self, YES);
        return;
    };
    
    
    if (self.alreadyLoadAll) {
        completion(self, NO);
        return;
    }
    
    TCPagedDataSetter setter = ^(NSUInteger total, NSArray *addedData, BOOL failed) {
        if (failed) {
            [self recoveryDataIfNeeded];
            completion(selfweak, YES);
            return ;
        }
        selfweak.total = total;
        
        selfweak.alreadyLoadData = YES;
        if (addedData && addedData.count > 0) {
            [selfweak.data addObjectsFromArray:addedData];
            selfweak.currentPage ++;
        }
        
        completion(selfweak, NO);
    };
    
    
    self.dataGetter(setter, _currentPage + 1, _increment);
}

- (NSInteger)currentCount {
    return self.data? self.data.count : 0;
}

- (BOOL)isEmpty {
    return self.currentCount == 0;
}

- (BOOL)alreadyLoadAll {
    if (_alreadyLoadData) {
        return self.currentCount >= self.total;
    } else {
        return NO;
    }
}
@end
