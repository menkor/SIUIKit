//
//  SIMessageBoxDefine.h
//  SuperId
//
//  Created by Ye Tao on 2017/8/15.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#ifndef SIMessageBoxDefine_h
#define SIMessageBoxDefine_h

typedef NS_OPTIONS(NSUInteger, SIMessageBoxType) {
    SIMessageBoxTypeNone = 0x00,
    SIMessageBoxTypeOK = 0x01,
    SIMessageBoxTypeCancel = 0x02,
    SIMessageBoxTypeBoth = 0x03,
    SIMessageBoxTypeMask = 0x0F,
    //status
    SIMessageBoxStatusNone = 0x00,
    SIMessageBoxStatusError = 0x10,
    SIMessageBoxStatusSuccess = 0x20,
    SIMessageBoxStatusWaiting = 0x30,
    SIMessageBoxStatusMask = 0xF0,
};

typedef NS_ENUM(NSUInteger, SIMessageBoxButtonIndex) {
    SIMessageBoxButtonIndexCancel = 0,
    SIMessageBoxButtonIndexOK = 1,
};

typedef void (^SIMessageBoxActionBlock)(NSInteger index);

#define kSIMessageBoxTitleFont [SIFont mediumSystemFontOfSize:16]

#define kSIMessageBoxMessageFont [SIFont systemFontOfSize:14]

#define kSIMessageBoxLastButtonFont [SIFont systemFontOfSize:18]

#define kSIMessageBoxMessageTextColor [SIColor whiteColor]

#define kSIMessageBoxMessageTextBlackColor [SIColor colorWithHex:0x4a4a4a]

#define kSIMessageBoxLastButtonColor [SIColor colorWithHex:0x157EFB]

#define kSIMessageBoxFirstButtonColor [SIColor colorWithHex:0x838383]

#define kSIMessageBoxLineColor [SIColor colorWithHex:0xE0E0E0]

#define kSIMessageErrorIcon [UIImage imageNamed:@"ic_message_error"]

#define kSIMessageSuccessIcon [UIImage imageNamed:@"ic_message_success"]

static const CGFloat kSIMessageBoxRadius = 8.0f;
static const CGFloat kSIMessageBoxWidth = 270.0f;

static const CGFloat kSIMessageBoxTitleYOffset = 16.0f;

static const CGFloat kSIMessageBoxMessageXOffset = 32.0f;
static const CGFloat kSIMessageBoxMessageYOffset = 6.0f;
static const CGFloat kSIMessageBoxMessageBottomOffset = 8.0f;

static const CGFloat kSIMessageBoxLineYOffset = 12.0f;
static const CGFloat kSIMessageBoxLineHeight = 0.5f;

static const CGFloat kSIMessageBoxButtonHeight = 46.0f;

static const CGFloat kSIMessageBoxIconTop = 24.0f;
static const CGFloat kSIMessageBoxIconHeight = 44.0f;

static NSString *const kSIMessageBoxButtonOK = @"确定";
static NSString *const kSIMessageBoxButtonCancel = @"取消";
static NSString *const kSIMessageBoxDefaultTitle = @"系统提示";

#pragma mark - Custom

typedef void (^SIMessageBoxCustomActionBlock)(NSInteger buttonIndex, NSInteger actionIndex);

@protocol SIMessageBoxCustomProtocol <NSObject>

- (NSUInteger)messageBoxActionSelectedIndex;

@end

static const CGFloat kSIMessageBoxMinDuration = 0.3f;

#endif /* SIMessageBoxDefine_h */
