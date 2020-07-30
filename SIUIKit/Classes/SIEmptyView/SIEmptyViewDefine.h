//
//  SIEmptyViewDefine.h
//  SuperId
//
//  Created by Ye Tao on 2017/8/14.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#ifndef SIEmptyViewDefine_h
#define SIEmptyViewDefine_h

typedef NS_ENUM(NSUInteger, SIEmptyViewType) {
    SIEmptyViewTypeNone,
    SIEmptyViewTypeNoData,
    SIEmptyViewTypeNoNetWork,
    SIEmptyViewTypeNoPermission,
};

static NSString *const kSIEmptyViewThemeLoading = @"loading";

static NSString *const kSIEmptyViewThemeNoNetWork = @"noNetWork";

static NSString *const kSIEmptyViewThemeIcon = @"icon";

static NSString *const kSIEmptyViewThemeTitle = @"title";

static NSString *const kSIEmptyViewThemeTopOffset = @"topOffset";

static NSString *const kSIEmptyViewThemeAction = @"action";

static NSString *const kSIEmptyViewThemeBackgroundColor = @"backgroundColor";

static NSString *const kSIEmptyViewNoNetworkingIcon = @"ic_no_network";

static NSString *const kSIEmptyViewNoNetworkingTitle = @"网络连接失败";

static NSString *const kSIEmptyViewNoNetworkingAction = @"刷新";

#define kSIEmptyViewNoNetWorkTheme @{          \
    kSIEmptyViewThemeIcon: @"熊猫星球.gif",    \
    kSIEmptyViewThemeTitle: @"唉？好像没网了", \
    kSIEmptyViewThemeAction: @"点我重试",      \
    kSIEmptyViewThemeNoNetWork: @(YES),        \
}

#define kSIEmptyViewThemeDict @{                             \
    @(SIEmptyViewTypeNoNetWork): kSIEmptyViewNoNetWorkTheme, \
    @(SIEmptyViewTypeNoPermission): @{                       \
        kSIEmptyViewThemeIcon: @"ic_no_permissions",         \
        kSIEmptyViewThemeTitle: @"您无权限查看",             \
    },                                                       \
}

#endif /* SIEmptyViewDefine_h */
