//
//  PIGenderBox.m
//  smartapp
//
//  Created by mac on 2019/10/30.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "PIGenderBox.h"
@interface PIGenderBox ()
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIButton *boyButton;
@property (weak, nonatomic) IBOutlet UIButton *girlButton;

@property (nonatomic, assign, readwrite) NSInteger selectedIndex;

@end
@implementation PIGenderBox

- (void)awakeFromNib {
    [super awakeFromNib];
    _categoryLabel.textColor = UIColor.fe_titleTextColorLighten;
    _selectedIndex = -1;
    _categoryLabel.text = @"性别";
    
    [_girlButton setTitleColor:UIColor.fe_titleTextColorLighten forState:UIControlStateNormal];
    _girlButton.backgroundColor = UIColor.fe_contentBackgroundColor;
    _girlButton.layer.cornerRadius = STWidth(2);
    _girlButton.layer.borderWidth = 1;
    _girlButton.layer.borderColor = UIColor.fe_separatorColor.CGColor;
    _girlButton.tag = 10000;
    _girlButton.fe_adjustTitleColorAutomatically = YES;
    
    [_boyButton setTitleColor:UIColor.fe_titleTextColorLighten forState:UIControlStateNormal];
    _boyButton.backgroundColor = UIColor.fe_contentBackgroundColor;
    _boyButton.layer.cornerRadius = STWidth(2);
    _boyButton.layer.borderWidth = 1;
    _boyButton.layer.borderColor = UIColor.fe_separatorColor.CGColor;
    _boyButton.tag = 10001;
    _boyButton.fe_adjustTitleColorAutomatically = YES;

}

- (void)setTitle:(NSString *)title {
    _title = title;
    _categoryLabel.text = _title;
}

- (IBAction)touchButton:(UIButton *)sender {
    if (self.stateHandler) {
        if (_selectedIndex < 0) {
            self.stateHandler(YES);
        }
    }
    
    if (sender.tag == 10000) {
        _selectedIndex = 0;
    } else {
        _selectedIndex = 1;
    }
 
    [self setSelectedState];
    
    
}

- (void)setSelectedState {

    _boyButton.backgroundColor = _selectedIndex?UIColor.fe_mainColor : UIColor.fe_contentBackgroundColor;
    _boyButton.layer.borderWidth = _selectedIndex?0:1;
    
    _girlButton.backgroundColor = !_selectedIndex?UIColor.fe_mainColor : UIColor.fe_contentBackgroundColor;
    _girlButton.layer.borderWidth = !_selectedIndex?0:1;

}


@end
