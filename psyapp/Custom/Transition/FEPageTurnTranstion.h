//
//  FEPageTurnTranstion.h
//  smartapp
//
//  Created by mac on 2020/1/9.
//  Copyright © 2020 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum FEPageTurnTranstionType {
    FEPageTurnTranstionPrevious,
    FEPageTurnTranstionNext
} FEPageTurnTranstionType;


@interface FEPageTurnTranstion : NSObject <UIViewControllerAnimatedTransitioning>
+ (instancetype)transitionWithType:(FEPageTurnTranstionType)type;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) FEPageTurnTranstionType type;
@end



