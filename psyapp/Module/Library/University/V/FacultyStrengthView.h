//
//  FacultyStrengthView.h
//  smartapp
//
//  Created by lafang on 2019/3/14.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FEBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^CommonBlock)(NSInteger index);

@interface FacultyStrengthView : UIView

//@property(nonatomic,strong) UIView *headView;
//@property(nonatomic,strong) UIImageView *iconImage;
@property(nonatomic,strong) UILabel *numLabel;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,assign) NSInteger curTabIndex;

-(instancetype)initWithTabFrame:(CGRect)frame imageUrl:(NSString *)imageUrl numStr:(NSString *)numStr nameStr:(NSString *)nameStr;

-(void)setImage:(UIImage *)image;

-(void)setName:(NSString *)name;

@property(nonatomic,strong)CommonBlock commonBlock;

@end

NS_ASSUME_NONNULL_END
