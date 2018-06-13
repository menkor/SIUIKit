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
    SIEmptyViewTypeNoData,
    SIEmptyViewTypeNoNetWork,
    SIEmptyViewTypeNoPermission,
};

static NSString *const kSIEmptyViewThemeIcon = @"icon";

static NSString *const kSIEmptyViewThemeTitle = @"title";

static NSString *const kSIEmptyViewThemeAction = @"action";

static NSString *const kSIEmptyViewNoNetworkingIcon = @"ic_no_network";

static NSString *const kSIEmptyViewNoNetworkingTitle = @"网络连接失败";

static NSString *const kSIEmptyViewNoNetworkingAction = @"刷新";

#define kSIEmptyViewThemeDict @{                     \
    @(SIEmptyViewTypeNoNetWork): @{                  \
        kSIEmptyViewThemeIcon: @"ic_no_network",     \
        kSIEmptyViewThemeTitle: @"网络连接失败",     \
        kSIEmptyViewNoNetworkingAction: @"刷新",     \
    },                                               \
    @(SIEmptyViewTypeNoPermission): @{               \
        kSIEmptyViewThemeIcon: @"ic_no_permissions", \
        kSIEmptyViewThemeTitle: @"您无权限查看",     \
    },                                               \
}

#endif /* SIEmptyViewDefine_h */
