//
//  FEVersionUpdateAlertView.h
//  smartapp
//
//  Created by mac on 2019/9/11.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseAlertView.h"


typedef void(^AlertResult)(NSInteger index);


@interface FEVersionUpdateAlertView : FEBaseAlertView
- (instancetype)initWithLeftButtonTitle:(NSString *)left
                       rightButtonTitle:(NSString *)right
                            versionName:(NSString *)version
                        contentOfUpdate:(NSAttributedString *)content
                                picture:(UIImage *)picture;

@property (nonatomic,copy) AlertResult resultIndex;

@end


