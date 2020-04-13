//
//  QSWebViewBaseController.m
//  app
//
//  Created by linjie on 17/3/25.
//  Copyright © 2017年 jeyie0. All rights reserved.
//

#import "QSWebViewBaseController.h"
#import <Masonry/Masonry.h>
#import "UIImage+Category.h"
#import "FEWebViewManager.h"
@interface QSWebViewBaseController ()
@property (nonatomic, strong) FEWebViewManager *webViewManager;
@end

@implementation QSWebViewBaseController

- (void)loadView {
    [super loadView];
  
    WKWebView *webView = (WKWebView *)self.webViewManager.webView;
    webView.scrollView.scrollEnabled = YES;
    webView.scrollView.showsVerticalScrollIndicator = YES;
    webView.scrollView.showsHorizontalScrollIndicator = YES;
    self.webViewManager.shouldDisableZoom = _shouldDisableZoom;
    self.webViewManager.shouldDisableLongPressAction = _shouldDisableLongPressAction;
    @weakObj(self);
    self.webViewManager.linkHandler = ^(NSString * _Nullable url) {
        QSWebViewBaseController *vc = [[QSWebViewBaseController alloc] init];
        vc.shouldDisableLongPressAction = YES;
        vc.shouldDisableZoom = YES;
        vc.url = url;
        [selfweak.navigationController pushViewController:vc animated:YES];
    };
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.top.offset(0);;
        make.size.equalTo(self.view);
    }];

}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_handlerAfterPoping) {
        @weakObj(self);
        self.fe_navigaitionViewController.barBackButtonAction = ^{
            selfweak.handlerAfterPoping();
            [selfweak.navigationController popViewControllerAnimated:YES];
        };
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_handlerAfterPoping) {
        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if (_handlerAfterPoping) {
        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    }
}


- (void)dealloc {
    self.fe_navigaitionViewController.barBackButtonAction = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (WKWebView *)webView {
    return (WKWebView *)_webViewManager.webView;
}

- (void)setUrl:(NSString *)url {
    _url = url;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [self.webViewManager loadRequest:request];
}

- (void)setFilePathURL:(NSURL *)filePathURL{
    _filePathURL = filePathURL;
    [self.webViewManager loadFileURL:filePathURL allowingReadAccessToURL:NSBundle.mainBundle.bundleURL];
}

- (FEWebViewManager *)webViewManager {
    if (!_webViewManager) {
        _webViewManager = [FEWebViewManager new];
    }
    return _webViewManager;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
