//
//  SIRefreshHeaderDef.h
//
//  Created by Ye Tao on 2017/3/3.
//
//

#ifndef SIRefreshHeaderDef_h
#define SIRefreshHeaderDef_h

#pragma mark - Style

typedef NS_ENUM(NSUInteger, SIRefreshHeaderStyle) {
    SIRefreshHeaderStyleDefault,
    SIRefreshHeaderStyleWhite,
    SIRefreshHeaderStyleGray,
};

#define kSIRefreshHeaderIconDict @{                                             \
    @(SIRefreshHeaderStyleDefault): [UIImage imageNamed:@"ic_list_home_crown"], \
    @(SIRefreshHeaderStyleWhite): [UIImage imageNamed:@"ic_list_home_crown"],   \
    @(SIRefreshHeaderStyleGray): [UIImage imageNamed:@"ic_list_home_crown"],    \
}

#define kSIRefreshHeaderColorDict @{                                         \
    @(SIRefreshHeaderStyleDefault): [SIColor colorWithHex:0x4a4a4a],         \
    @(SIRefreshHeaderStyleWhite): [SIColor colorWithHex:0xffffff alpha:0.6], \
    @(SIRefreshHeaderStyleGray): [SIColor colorWithHex:0x96a7b4 alpha:0.6],  \
}

#pragma mark - State

typedef NS_ENUM(NSUInteger, SIRefreshResultState) {
    SIRefreshResultStateOrigin,
    SIRefreshResultStateSuccess,
    SIRefreshResultStateError,
};

#pragma mark - Text

static NSString *const kSIRefreshHeaderTitleIdle = @"下拉刷新";

static NSString *const kSIRefreshHeaderTitlePulling = @"释放立即刷新";

static NSString *const kSIRefreshHeaderTitleRefreshing = @"正在刷新";

static NSString *const kSIRefreshHeaderTitleSuccess = @"刷新完成";

static NSString *const kSIRefreshHeaderTitleError = @"刷新失败";

static NSString *const kSIRefreshHeaderTitleFormat = @" 最后更新 %@";

static NSString *const kSIRefreshHeaderDateFormat = @"HH:mm";

static const BOOL kSIRefreshHeaderTitleAppendDate = NO;

#pragma mark - Min Pulling Time
//最小下拉时间间隔
static const CGFloat kSIRefreshMinPullingTimeInterval = 0.5;
//timer触发间隔
static const CGFloat kSIRefreshTimerFireTimeInterval = 0.05;

#pragma mark - Animation

#define kSIRefreshAnimationStartAngle -15.0 / 360

//#define kSIRefreshAnimationEndAngle M_PI + M_PI_2 + 15.0/360

#endif /* SIRefreshHeaderDef_h */
