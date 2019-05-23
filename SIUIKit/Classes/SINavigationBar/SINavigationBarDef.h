//
//  SINavigationBarDef.h
//  SuperId
//
//  Created by Ye Tao on 2017/7/24.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#ifndef SINavigationBarDef_h
#define SINavigationBarDef_h

#pragma mark - Enum

static const NSUInteger kSINavigationItemBuildin = 1000;

static const NSUInteger kSINavigationItemCustom = 2000;

/*!
 *  @brief 自定义按钮的类型
 */
typedef NS_ENUM(NSUInteger, SINavigationItemTypeCustom) {
    /*!
     *  @brief 自定义文本
     */
    SINavigationItemTypeCustomText = kSINavigationItemCustom,
    /*!
     *  @brief 自定义图片
     */
    SINavigationItemTypeCustomImage,
};

typedef NS_ENUM(NSUInteger, SINavigationItemType) {

    //普通UI,读取配置参数
    SINavigationItemTypeReturn = kSINavigationItemBuildin, //返回      1000
    SINavigationItemTypeMore,                              //更多      1001
    SINavigationItemTypeMoreWhite,                         //更多[白色] 1002
    SINavigationItemTypeReturnWhite,                       //返回[白色] 1003

};

typedef NS_ENUM(NSUInteger, SINavigationItemPosition) {
    SINavigationItemPositionLeft = 0,
    SINavigationItemPositionTitle = 1,
    SINavigationItemPositionRight,
    SINavigationItemPositionError,
};

typedef NS_ENUM(NSUInteger, SINavigationItemOperation) {
    SINavigationItemOperationNone = 0,
    SINavigationItemPositionAdd = 1,
};

typedef NS_ENUM(NSUInteger, SINavigationTheme) {
    SINavigationThemeWhite,
    SINavigationThemeClear,
    SINavigationThemeBlack,
};

#pragma mark - Theme

#define kThemeRedWhite [SIColor whiteColor]
#define kThemeClearColor [SIColor clearColor]
#define kThemeBlackColor [SIColor blackColor]

#define kThemeColorDict @{                       \
    @(SINavigationThemeWhite): kThemeRedWhite,   \
    @(SINavigationThemeClear): kThemeClearColor, \
    @(SINavigationThemeBlack): kThemeBlackColor, \
}

#define kThemeFontTitle [SIFont boldSystemFontOfSize:16]
#define kThemeFontDefault [SIFont systemFontOfSize:14]

#define kSINavigationBarBottomLineColor [SIColor whiteColor]

#pragma mark - Block

typedef void (^SINavigationBarActionBlock)(UIButton *sender);

/**
 add some item(s)

 @return `NSArray<UIView *> *` or `UIView *`
 */
typedef id (^SINavigationBarAddItem)(void);

#pragma mark - UI

static const CGFloat kSINavigationItemHeight = 44;

static const CGFloat kSINavigationItemYOffset = 20;

static const CGFloat kSINavigationButtonYOffset = 15;

#pragma mark - Config

static NSString *const kSINavigationConfig = @"SINavigationAdaptor";

static NSString *const kSINavigationConfigKeyTitle = @"title";
static NSString *const kSINavigationConfigKeyImage = @"image";
static NSString *const kSINavigationConfigKeyTag = @"tag";

static NSString *const kSINavigationConfigKeyBackgroundImage = @"background";
static NSString *const kSINavigationConfigKeyParam = @"param";
static NSString *const kSINavigationConfigParamRemove = @"remove";

#endif /* SINavigationBarDef_h */
