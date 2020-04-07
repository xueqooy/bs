//
//  BaseTableViewCell.m
//  CheersgeniePlus
//
//  Created by lafang on 2019/7/12.
//  Copyright © 2019 Cheersmind. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.fe_contentBackgroundColor;
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews {
    //set up views
}



@end
