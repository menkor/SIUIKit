//
//  SIGlobalMacro.h
//  SuperId
//
//  Created by Ye Tao on 2017/3/31.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#ifndef SIGlobalMacro_h
#define SIGlobalMacro_h

#pragma mark - weakfy & strongfy

#ifndef weakfy
#define weakfy(object) __weak __typeof__(object) weak##_##object = object;
#endif
#ifndef strongfy
#define strongfy(object) __typeof__(object) object = weak##_##object;
#endif

#pragma mark - debug log

#import <CocoaLumberjack/CocoaLumberjack.h>

#ifdef DEBUG
static const unsigned long ddLogLevel = DDLogLevelAll;
#else
static const unsigned long ddLogLevel = DDLogLevelInfo;
#endif

#ifdef DEBUG
#define SIDLog(fmt, ...) DDLogDebug(@"< %@:(%d) > %@%c", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(fmt), ##__VA_ARGS__], NSAttachmentCharacter)
#else
#define SIDLog(...)
#endif

#pragma mark - Screen

//定义屏幕的宽-高
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTopHeight (kStatusBarHeight + kNavBarHeight)
#define IS_IPHONE_X ((fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)812) < DBL_EPSILON) || (fabs((double)[[UIScreen mainScreen] bounds].size.width - (double)812) < DBL_EPSILON))
#define kBottomHeight (IS_IPHONE_X ? 34 : 0)
#endif /* SIGlobalMacro_h */
