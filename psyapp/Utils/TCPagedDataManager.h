//
//  TCPagedDataManager.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/16.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^TCPagedDataSetter)(NSUInteger total, NSArray * _Nullable addedData, BOOL failed);
typedef void(^TCPagedDataGetter)(TCPagedDataSetter _Nonnull setter, NSInteger page, NSInteger count);
NS_ASSUME_NONNULL_BEGIN

@interface TCPagedDataManager <T>: NSObject
@property (nonatomic, assign) NSInteger increment;
@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign, readonly) NSInteger currentCount;
@property (nonatomic, assign, readonly) NSInteger currentPage; //page从1开始，0表示未请求
@property (nonatomic, assign, readonly) BOOL alreadyLoadAll;
@property (nonatomic, assign, readonly) BOOL isEmpty;

@property (nonatomic, strong, readonly) NSMutableArray <T> *data;

@property (nonatomic, copy) TCPagedDataGetter dataGetter;

- (void)resetData;

- (void)resetDataByBackups;

- (void)loadDataOnCompletion:(void (^_Nullable)(TCPagedDataManager *manager, BOOL failed))completion;
@end

NS_ASSUME_NONNULL_END
