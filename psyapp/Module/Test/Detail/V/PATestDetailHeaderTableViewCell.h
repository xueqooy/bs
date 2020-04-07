//
//  PATestDetailHeaderTableViewCell.h
//  psyapp
//
//  Created by mac on 2020/3/16.
//  Copyright © 2020 cheersmind. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PATestDetailHeaderTableViewCell : UITableViewCell
@property (nonatomic, assign) CGFloat presentPrice;
@property (nonatomic, assign) CGFloat originPrice;
@property (nonatomic, assign) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) CGFloat recommendIndex;

@end

NS_ASSUME_NONNULL_END
