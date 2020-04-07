//
//  FEWebViewManager.m
//  smartapp
//
//  Created by mac on 2019/12/13.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEWebViewManager.h"

@interface FEWebViewManager () <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, weak) WKUserContentController *ucController;
@property (nonatomic, strong) NSMutableDictionary *jsCallBackInfo;
@end

@implementation FEWebViewManager

#define TransformPtToPx(pt) pt*96/72

- (void)dealloc {
    [_ucController removeAllUserScripts];
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView =  [[WKWebView alloc] initWithFrame:CGRectZero configuration: self.webViewConfiguration];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.userInteractionEnabled = YES;
        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _webView;
}

- (void)setHandler:(void (^)(id _Nonnull))handler forJSCallBackKey:(NSString *)callBackKey {
    if (!_jsCallBackInfo) {
        _jsCallBackInfo = @{}.mutableCopy;
    }
    [_ucController addScriptMessageHandler:self name:callBackKey];
    [_jsCallBackInfo setObject:handler forKey:callBackKey];
}

- (void)removeJSCallBackHandlerForKey:(NSString *)callBackKey {
    [_jsCallBackInfo removeObjectForKey:callBackKey];
}

- (void)loadRequest:(NSURLRequest *)request {
    [self.webView loadRequest:request];
}

- (void)loadHTMLString:(NSString *)htmlString {
    //[self.webView loadHTMLString:htmlString baseURL:nil];
    //通过css媒体查询，完成web的s暗黑模式适配
    NSString *cssPath = [NSBundle.mainBundle pathForResource:@"theme" ofType:@".css"];
    NSString *localcss = [NSString stringWithFormat:@"<head><link rel=\"stylesheet\" type=\"text/css\" href=\"%@\"></head>",cssPath];
    NSString * htmlcontent = [NSString stringWithFormat:@"%@%@",localcss, htmlString];
    [self.webView loadHTMLString:htmlcontent baseURL:[NSURL fileURLWithPath:cssPath]];
}

- (void)loadFileURL:(NSURL *)URL allowingReadAccessToURL:(NSURL *)readAccessURL {
    WKWebView *webView = (WKWebView *)self.webView;
    [webView loadFileURL:URL allowingReadAccessToURL:readAccessURL];
}

- (WKWebViewConfiguration *)webViewConfiguration {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *uCCtroller = [[WKUserContentController alloc] init];
    
    NSString *viewportFitString = getViewportFitString();
    NSString *imgFitString = getImgFitString();
    NSString *pFontSizeString = getFontSizeStringBy("body", TransformPtToPx(14));
    NSString *textAlignJustifyString = getTextAlignJistifyString();
    NSString *textLineSpacingString = getLineSpacingString(TransformPtToPx(25));
    
    
    WKUserScript *viewportFitScript = [[WKUserScript alloc] initWithSource:viewportFitString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [uCCtroller addUserScript:viewportFitScript];
    
    WKUserScript *imgFitScript = [[WKUserScript alloc] initWithSource:imgFitString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                                     forMainFrameOnly:YES];
    [uCCtroller addUserScript:imgFitScript];
    
    WKUserScript *textLineSpacingScript = [[WKUserScript alloc] initWithSource:textLineSpacingString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [uCCtroller addUserScript:textLineSpacingScript];
    
    WKUserScript *pFontSizeScript = [[WKUserScript alloc] initWithSource:pFontSizeString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [uCCtroller addUserScript:pFontSizeScript];
    
    WKUserScript *textJustifyScript = [[WKUserScript alloc] initWithSource:textAlignJustifyString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [uCCtroller addUserScript:textJustifyScript];
    
    
    config.userContentController = uCCtroller;
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences.javaScriptEnabled = YES;
    _ucController = uCCtroller;

    return config;
}




- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
     //适配写在这个delegate方法里，或添加到config中
   //    NSString *viewportFitScript = getViewportFitString();
   //      NSString *imgFitScript = getImgFitString();
   //    NSString *h1FontSizeScript = getFontSizeStringBy("h1", 24);
   //      NSString *pFontSizeScript = getFontSizeStringBy("p", 14);
   //    [webView evaluateJavaScript:viewportFitScript completionHandler:nil];
   //     [webView evaluateJavaScript:imgFitScript completionHandler:nil];
   //    [webView evaluateJavaScript:h1FontSizeScript completionHandler:nil];
   //    [webView evaluateJavaScript:pFontSizeScript completionHandler:nil];
    @weakObj(self);
    //调整高度
    __block CGFloat contentHeight = 0;
    //获取内容实际高度（像素）@"document.getElementById(\"content\").offsetHeight;"
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result,NSError * _Nullable error) {
        @strongObj(self);
        //获取页面高度，并重置webview的frame
       
        contentHeight = [result doubleValue];
        //   NSLog(@"%f",webViewHeight);
       // mLogFunc(@"webfinish_kk%@", [NSThread currentThread]);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.didFinishNavigationHandler) {
                self.didFinishNavigationHandler(contentHeight);
            }
        });
    }];
    
    if (_shouldDisableZoom) {
        NSString *injectionJSString = @"var script = document.createElement('meta');"
            "script.name = 'viewport';"
            "script.content=\"width=device-width, user-scalable=no\";"
            "document.getElementsByTagName('head')[0].appendChild(script);";
        [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    }
    
    if (_shouldDisableLongPressAction) {
        [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
        [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    }
    
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //获取URL
    NSURL *url = navigationAction.request.URL ;
    //跳转浏览器
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        if (self.linkHandler) {
            self.linkHandler(url.absoluteString);
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    return;
}

//处理js回调
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if (_shouldReadjustWebViewWhenJSCallBack) {
        NSString *viewportFitString = getViewportFitString();
        NSString *imgFitString = getImgFitString();
        NSString *pFontSizeString = getFontSizeStringBy("body", TransformPtToPx(14));
        NSString *textAlignJustifyString = getTextAlignJistifyString();
        NSString *textLineSpacingString = getLineSpacingString(TransformPtToPx(25));
           
        [_webView evaluateJavaScript:viewportFitString completionHandler:nil];
        [_webView evaluateJavaScript:imgFitString completionHandler:nil];
        [_webView evaluateJavaScript:pFontSizeString completionHandler:nil];
        [_webView evaluateJavaScript:textAlignJustifyString completionHandler:nil];
        [_webView evaluateJavaScript:textLineSpacingString completionHandler:nil];
    }

    NSDictionary *info = message.body;
         
    void (^ handler)(id) = [_jsCallBackInfo objectForKey:message.name];
    if (handler) {
        handler(info);
    }

}




//用户可视区适配
static inline NSString *getViewportFitString() {
    return
    @"var meta = document.createElement('meta');"
    "meta.setAttribute('name','viewport');"
    "meta.setAttribute('content','width=device-width');"
    "document.getElementsByTagName('head')[0].appendChild(meta);"
    ;
  
    
}
//图片大小缩放至宽度与webView一致
static inline NSString * getImgFitString() {
    return
    @"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var img;"
    "var maxwidth = document.body.clientWidth;"
    "for(i=0;i <document.images.length;i++){"
    "img = document.images[i];"
    "img.style.width = '100%';"
    "img.style.height = 'auto';"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);ResizeImages();";
//    NSString *js = @"var script = document.createElement('script');"
//    "script.type = 'text/javascript';"
//    "script.text = \"function ResizeImages() { "
//    "var img;"
//    "var maxwidth = document.body.clientWidth;"
//    "for(i=0;i <document.images.length;i++){"
//    "img = document.images[i];"
//    "img.style.maxWidth = %f ;"
//    "}"
//    "}\";"
//    "document.getElementsByTagName('head')[0].appendChild(script);ResizeImages();";
//    CGFloat maxWidth = mScreenWidth - STWidth(30);
//    js = [NSString stringWithFormat:js, maxWidth];
//    return js;
}
//修改标签字体大小
static inline NSString *getFontSizeStringBy(char *tag ,NSInteger size) {
    return [NSString stringWithFormat:
            @"var tags = document.getElementsByTagName('%s');"
            "var tagCount =  tags.length;"
            "for(i=0;i <tagCount;i++){"
            "tags[i].style.fontSize = '%ldpx';"
            "}",tag , (long)size];
}

//文字两端对齐
static inline NSString *getTextAlignJistifyString() {
    return  @"var tags = document.getElementsByTagName('p');"
    "var tagCount =  tags.length;"
    "for(i=0;i <tagCount;i++){"
    "tags[i].style.textAlign = 'justify';"
    "tags[i].style.textJustify = 'inter-ideograph'"
    "}";
}

static inline NSString *getLineSpacingString(NSInteger spacing) {
    return [NSString stringWithFormat: @"var tag = document.getElementsByTagName('body');"
            "tag[0].style.lineHeight = '%ldpx';", (long)spacing];
    
    ;
}

@end

@implementation FEWebViewManager (FETheme)
static char kAssociatedObjectKey_shouldResponseDarkMode;
- (void)setShouldResponseDarkMode:(BOOL)shouldResponseDarkMode {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_shouldResponseDarkMode, [NSNumber numberWithBool:shouldResponseDarkMode], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (shouldResponseDarkMode) {
        @weakObj(self);
        _webView.qmui_themeDidChangeBlock = ^{
            [selfweak handleTraitChange];
        };
    } else {
        _webView.qmui_themeDidChangeBlock = nil;
    }
}

- (BOOL)shouldResponseDarkMode {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_shouldResponseDarkMode)) boolValue];
}

- (void)handleTraitChange {
    if ([[FEThemeManager currentTheme].themeName isEqualToString:FEThemeConfigureDarkIdentifier]) {
        [self switchToDarkMode];
    } else {
        [self switchToDefaultMode];
    }
}

- (void)switchToDarkMode {
    //字体
    [_webView evaluateJavaScript:@"document.getElementsByTagName(‘body‘)[0].style.webkitTextFillColor='FFFFFF'" completionHandler:nil];
    [_webView evaluateJavaScript:[NSString stringWithFormat:@"document.body.style.backgroundColor='#1A1513'"] completionHandler:nil];

}

- (void)switchToDefaultMode {
    [_webView evaluateJavaScript:@"document.getElementsByTagName(‘body‘)[0].style.webkitTextFillColor='000000'" completionHandler:nil];
    [_webView evaluateJavaScript:[NSString stringWithFormat:@"document.body.style.backgroundColor='#FFFFFF'"] completionHandler:nil];

}
@end
