//
//  FEWebViewManager.h
//  smartapp
//
//  Created by mac on 2019/12/13.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface FEWebViewManager : NSObject
@property (nonatomic, strong, readonly) WKWebView *webView;
@property (nonatomic, copy) void (^didFinishNavigationHandler)(CGFloat contentHeight);
@property (nonatomic, copy) void (^linkHandler)(NSString *__nullable url);
@property (nonatomic, assign) BOOL shouldDisableZoom ; //放大缩小
@property (nonatomic, assign) BOOL shouldDisableLongPressAction; //长按操作
@property (nonatomic, assign) BOOL shouldReadjustWebViewWhenJSCallBack;//当js回调时重新调整页面



- (void)loadRequest:(NSURLRequest *)request;
- (void)loadHTMLString:(NSString *)htmlString;
- (void)loadFileURL:(nonnull NSURL *)URL allowingReadAccessToURL:(nonnull NSURL *)readAccessURL;
- (void)setHandler:(void (^)(id))handler forJSCallBackKey:(NSString *)callBackKey;
- (void)removeJSCallBackHandlerForKey:(NSString *)callBackKey;
@end

@interface FEWebViewManager (Dark)
@property (nonatomic, assign) BOOL shouldResponseDarkMode;
@end

NS_ASSUME_NONNULL_END
