//
//  SizeMacro.h
//  CheersgeniePlus
//
//  Created by xueqooy on 2019/7/15.
//  Copyright © 2019 Cheersmind. All rights reserved.
//

#ifndef SizeMacro_h
#define SizeMacro_h

//视图卸耦相关
#define BindControllerView(viewclass) \
- (void)loadView { \
    self.view = [[viewclass alloc] initWithFrame:[UIScreen mainScreen].bounds]; \
} \
- (id)forwardingTargetForSelector:(SEL)aSelector { \
    struct objc_method_description omd = protocol_getMethodDescription(@protocol(viewclass), aSelector, NO, YES); \
    if (omd.name != NULL) { \
        return self.view; \
    } \
    return [super forwardingTargetForSelector:aSelector];\
} \


//app名称、版本、构建版本
#define mAppName ([NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleDisplayName"])
#define mAppVersion ([NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleShortVersionString"])
#define mAppBuild ([NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleVersion"])

#define mKeyWindow [UIApplication sharedApplication].keyWindow

//判断是否生产环境
#define mIsProduct [API_HOST isEqualToString:@"https://psytest-server.cheersmind.com"]

/*DEBUG模式下的NSLOG*/
#ifdef DEBUG
//使__FILE__只显示文件名，而不是带有路径
#define __FILENAME__ (strrchr(__FILE__, '/') ? strrchr(__FILE__, '/') + 1 : __FILE__)
#define mLog(fmt, ...) NSLog(@"\n{\n  File : %s\n  func : %s\n  line : %d\n  log  : "fmt"\n}" , __FILENAME__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#define mLogFunc(fmt, ...) NSLog(@"[func:%s]  "fmt"", __FUNCTION__, ##__VA_ARGS__)
#define mLogFile(fmt, ...) NSLog(@"[file:%s]  "fmt"", __FILENAME__, ##__VA_ARGS__)
#define mLogLine(fmt, ...) NSLog(@"[line:%d]  "fmt"", __LINE__, ##__VA_ARGS__)
#else
#define mLog(...)
#define mLogFunc(...)
#define mLogFile(...)
#define mLogLine(...)
#endif

#define mIsIOS13 @available(iOS 13.0, *)

#define mIsiPhoneX ({\
int tmp = 0;\
if (@available(iOS 11.0, *)) {\
if ([UIApplication sharedApplication].delegate.window.safeAreaInsets.top > 20) {\
tmp = 1;\
}else{\
tmp = 0;\
}\
}else{\
tmp = 0;\
}\
tmp;\
})

#define GCD_ASYNC(queue, block) \
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {\
block(); \
} else {\
dispatch_async(queue, block);\
}
#define GCD_ASYNC_MAIN(block) GCD_ASYNC(dispatch_get_main_queue(), block)
#define GCD_ASYNC_GLOBAL(block) GCD_ASYNC(dispatch_get_global_queue(0, 0), block)

#define weakObj(obj) autoreleasepool{} __weak typeof(obj) obj##weak = obj;
#define strongObj(obj) autoreleasepool{} __strong typeof(obj) obj = obj##weak;

/*状态栏高度*/
#define mStatusBarHeight (CGFloat)(mIsiPhoneX?(44.0):(20.0))

/*导航栏高度*/
#define mNavBarHeight (44)

/*状态栏和导航栏总高度*/
#define mNavBarAndStatusBarHeight (CGFloat)(mIsiPhoneX?(88.0):(64.0))

/*TabBar高度*/
#define mTabBarHeight (CGFloat)(mIsiPhoneX?(49.0 + 34.0):(49.0))

/*导航条和Tabbar总高度*/
#define mNavAndTabHeight (mNavBarAndStatusBarHeight + mTabBarHeight)

/*顶部安全区域远离高度*/
#define mTopBarSafeHeight (CGFloat)(mIsiPhoneX?(44.0):(0))

/*底部安全区域远离高度*/
#define mBottomSafeHeight (CGFloat)(mIsiPhoneX?(34.0):(0))

/*iPhoneX的状态栏高度差值*/
#define mTopBarDifHeight (CGFloat)(mIsiPhoneX?(24.0):(0))

#define mScreenWidth             [[UIScreen mainScreen] bounds].size.width
#define mScreenHeight            [[UIScreen mainScreen] bounds].size.height

#define mSelfWidth self.frame.size.width
#define mSelfHeight self.frame.size.height

#define mViewWidth(view) view.frame.size.width
#define mViewHeight(view) view.frame.size.height

/*主题色*/
#define mMainColor  mHexColor(@"306DFE") //主题色，按钮
#define mTextHighLightColor mHexColor(@"306DFE") //文本高亮 按钮文本高亮
#define mButtonNormalColor mHexColor(@"d7d9db") //按钮普通颜色

#define mHexColor(hexString) mHexColorA(hexString, 1.0)
#define mHexColorA(hexString, a) [UIColor colorFromHexString:hexString alpha:a]
#define mRGB(Value) [UIColor colorWithRed:Value/255.0 green:Value/255.0 blue:Value/255.0 alpha:1]
#define mRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define mRGB1(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


/*设置view圆角和边框*/
#define mBorder(view, radius, width, color)\
\
[view.layer setCornerRadius:(radius)];\
[view.layer setMasksToBounds:YES];\
[view.layer setBorderWidth:(width)];\
[view.layer setBorderColor:[color CGColor]]

/*字体设置*/
#define mFontLight(value)             [UIFont systemFontOfSize:value weight:UIFontWeightLight]
#define mFontRegular(value)             [UIFont systemFontOfSize:value weight:UIFontWeightRegular]
#define mFontBold(value)             [UIFont systemFontOfSize:value weight:UIFontWeightBold]
#define mFontThin(value)             [UIFont systemFontOfSize:value weight:UIFontWeightThin]
#define mFontSW(s,w)              [UIFont systemFontOfSize:s weight:w]
#define mFont(value)              [UIFont systemFontOfSize:value]
//字体间距
#define mLabelSpace(label, str, font)\
NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];\
paraStyle.lineBreakMode = NSLineBreakByCharWrapping;\
paraStyle.alignment = NSTextAlignmentLeft;\
paraStyle.lineSpacing = 8;\
paraStyle.hyphenationFactor = 1.0;\
paraStyle.firstLineHeadIndent = 0.0;\
paraStyle.paragraphSpacingBefore = 0.0;\
paraStyle.headIndent = 0;\
paraStyle.tailIndent = 0;\
NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@.1f };\
NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];\
label.attributedText = attributeStr

#endif /* SizeMacro_H */
