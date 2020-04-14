//
//  BSLibCell.h
//  psyapp
//
//  Created by mac on 2020/4/14.
//  Copyright © 2020 cheersmind. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum BSLibCellType{
    BSLibCellTypeUniversity = 0,
    BSLibCellTypeMajor,
    BSLibCellTypeOccupation
} BSLibCellType;
@interface BSLibCell : UIView <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic) BSLibCellType cellType;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSURL *iconImageURL;
@property (nonatomic, copy) NSString *updateAt;
@property (nonatomic) NSInteger includedCount;
@property (nonatomic, copy) NSArray <NSString *>*tags;
@property (nonatomic, assign) BOOL hotTag;
@property (nonatomic, copy) void (^onTap)(void);
@property (nonatomic, copy) void (^onTag)(NSString *tag);
@end

NS_ASSUME_NONNULL_END
