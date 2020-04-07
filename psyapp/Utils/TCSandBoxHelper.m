//
//  TCSandBoxHelper.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/17.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCSandBoxHelper.h"

@implementation TCSandBoxHelper
+ (NSString *)documentPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)libraryPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)tempPath {
    return NSTemporaryDirectory();
}

+ (NSString *)iapReceiptFilePath {
    NSString *filePath = [TCSandBoxHelper.documentPath stringByAppendingPathComponent:@"iapreceipt"];
    [self createFolderWithPath:filePath];
    return filePath;
}

+ (void)createFolderWithPath:(NSString *)path {
    NSFileManager *fileManager = NSFileManager.defaultManager;
    BOOL isDir = NO;

    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];

    if (!(isDir && existed)) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
@end
