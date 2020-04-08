//
//  FacultyStrengthView.m
//  smartapp
//
//  Created by lafang on 2019/3/14.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FacultyStrengthView.h"
#import "UIView+Extension.h"
#import "UIColor+Category.h"
#import <Masonry/Masonry.h>


@implementation FacultyStrengthView

-(instancetype)initWithTabFrame:(CGRect)frame imageUrl:(NSString *)imageUrl numStr:(NSString *)numStr nameStr:(NSString *)nameStr{
    if (self == [super init]) {
        
        self.frame = frame;
        [self layoutIfNeeded];
        
//        self.headView = [[UIView alloc] init];
//        self.headView.layer.masksToBounds = YES;
//        self.headView.layer.cornerRadius = 25;
//        self.headView.layer.borderWidth = 1;
//        self.headView.layer.borderColor = [UIColor colorWithHexString:@"ff8b00"].CGColor;
//        [self addSubview:self.headView];
//        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self);
//            make.centerX.equalTo(self);
//            make.size.mas_equalTo(CGSizeMake(50, 50));
//        }];
//        
//        self.iconImage = [[UIImageView alloc] init];
//        [self.iconImage setImage:[UIImage imageNamed:@"career_university_bs"]];
//        self.iconImage.contentMode = UIViewContentModeScaleAspectFit;
//        [self.headView addSubview:self.iconImage];
//        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self.headView);
//            make.size.mas_equalTo(CGSizeMake(24, 24));
//        }];
        
        self.numLabel = [[UILabel alloc] init];
        self.numLabel.text = numStr;
        self.numLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.numLabel.font = [UIFont systemFontOfSize:24];
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.numLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.centerX.equalTo(self);
        }];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.text = nameStr;
        self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.nameLabel.font = [UIFont systemFontOfSize:14.0f];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.numLabel.mas_bottom).offset(6);
            make.centerX.equalTo(self);
        }];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick)];
        [self addGestureRecognizer:tap];
        
        
    }
    return self;
}

-(void) itemClick{
    if(self.commonBlock){
        self.commonBlock(self.curTabIndex);
    }
}

-(void)setImage:(UIImage *)image{
//    self.iconImage.image = image;
}

-(void)setName:(NSString *)name{
    self.nameLabel.text = name;
}

@end
