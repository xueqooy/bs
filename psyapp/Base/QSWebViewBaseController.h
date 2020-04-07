//
//  QSWebViewBaseController.h
//  app
//
//  Created by linjie on 17/3/25.
//  Copyright © 2017年 jeyie0. All rights reserved.
//

#import "FEBaseViewController.h"
#import <WebKit/WebKit.h>

@interface QSWebViewBaseController : FEBaseViewController

@property (nonatomic, assign) BOOL shouldDisableZoom ;

@property (nonatomic, assign) BOOL shouldDisableLongPressAction;


@property (nonatomic,strong) WKWebView *webView;

@property (nonatomic,copy) NSString *url;

@property (nonatomic, copy) void (^handlerAfterPoping)(void);

@end
