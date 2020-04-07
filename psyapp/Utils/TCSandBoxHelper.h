//
//  TCSandBoxHelper.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/17.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCSandBoxHelper : NSObject
@property (nonatomic, class, readonly) NSString *documentPath;
@property (nonatomic, class, readonly) NSString *libraryPath;
@property (nonatomic, class, readonly) NSString *tempPath;

@property (nonatomic, class, readonly) NSString *iapReceiptFilePath;
@end

NS_ASSUME_NONNULL_END
