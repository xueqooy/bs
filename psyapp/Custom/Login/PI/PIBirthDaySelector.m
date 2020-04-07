//
//  PIBirthDaySelector.m
//  smartapp
//
//  Created by mac on 2019/11/2.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "PIBirthDaySelector.h"
#import "STPickerDate.h"
@interface PIBirthDaySelector () < STPickerDateDelegate>
@property (nonatomic, strong) STPickerDate *birthDayPickerView;

@property (nonatomic, assign) NSInteger yearLeast;
@property (nonatomic, strong) NSNumber *year;
@property (nonatomic, strong) NSNumber *month;
@property (nonatomic, strong) NSNumber *day;
@property (nonatomic, assign) NSUInteger sum;
@property (nonatomic, assign) NSUInteger yearsAgo;
@end

@implementation PIBirthDaySelector
@synthesize pi_selectedHandler = _pi_selectedHandler;
@synthesize pi_hiddenHandler = _pi_hiddenHandler;

- (instancetype)initWithYearSum:(NSUInteger)sum defaultYearWithYearsAgo:(NSUInteger)yearsAgo{
    self = [super init];
    _sum = sum;
    _yearsAgo = yearsAgo;
    //获取今年年份
    NSDate *  date=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy"];
    NSString *thisYearString = [dateformatter stringFromDate:date];
    if (![NSString isEmptyString:thisYearString]) {
        _yearLeast =  _yearLeast = [thisYearString integerValue  ] - _sum;
    } else {
        _yearLeast = 1920;
    }
    return self;
}

#pragma mark - PISelectBoxProtocal
- (void)pi_showSelector {
    if (_birthDayPickerView == nil) {
         STPickerDate *birthDayPickerView = [[STPickerDate alloc] init];
         _birthDayPickerView = birthDayPickerView;
          birthDayPickerView.yearLeast = _yearLeast;
          birthDayPickerView.yearSum = _sum; //从一百年前至一年前
          birthDayPickerView.font = mFontBold(16);
          birthDayPickerView.heightPicker = mScreenHeight * 0.3;
          birthDayPickerView.heightPickerComponent =  40.f;
          birthDayPickerView.contentView.backgroundColor = UIColor.fe_contentBackgroundColor;
          birthDayPickerView.titleColor = UIColor.fe_titleTextColorLighten;
          birthDayPickerView.lineView.backgroundColor = [UIColor clearColor];
          birthDayPickerView.borderButtonColor = [UIColor clearColor];
          birthDayPickerView.pickerView.backgroundColor = UIColor.fe_contentBackgroundColor;
          birthDayPickerView.buttonLeft.titleLabel.font = mFont(14);
          birthDayPickerView.buttonRight.titleLabel.font = mFont(14);
          birthDayPickerView.lineViewDown.backgroundColor = UIColor.fe_contentBackgroundColor;
          [birthDayPickerView.buttonRight setTitleColor:UIColor.fe_textColorHighlighted forState:UIControlStateNormal];
          [birthDayPickerView.buttonLeft setTitleColor:UIColor.fe_mainTextColor forState:UIControlStateNormal];
          [birthDayPickerView.buttonRight setTitle:@"确认" forState:UIControlStateNormal];
          @weakObj(self);
          birthDayPickerView.dismissHandler = ^{
              @strongObj(self);
              if (self.pi_hiddenHandler) {
                  self.pi_hiddenHandler();
              }
          };
          birthDayPickerView.delegate = self;
          
          NSInteger yearRow = _sum - _yearsAgo;
          NSInteger monthRow = 0;
          NSInteger dayRow = 0;

          if (_year && _month && _day) {
              yearRow = [_year integerValue] - _yearLeast;
              monthRow = [_month integerValue] - 1;
              dayRow = [_day integerValue] - 1;
          }
         
          [birthDayPickerView st_selectRow: yearRow inComponent:0 animated:NO];
          [birthDayPickerView st_selectRow: monthRow inComponent:1 animated:NO];
          [birthDayPickerView st_selectRow: dayRow inComponent:2 animated:NO];
    }
    
     [_birthDayPickerView show];
}
#pragma mark - STPickerDateDelegate

- (void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day  {
    _year = @(year);
    _month = @(month);
    _day = @(day);

    NSString *dateString = [NSString stringWithFormat:@"%ld-%ld-%ld", (long)year, (long)month, (long)day];

    self.pi_selectedHandler(dateString);
}
@end
