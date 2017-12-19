//
//  SIAlertViewDefine.h
//  SuperId
//
//  Created by Ye Tao on 2017/8/23.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#ifndef SIAlertViewDefine_h
#define SIAlertViewDefine_h

typedef NS_ENUM(NSInteger, SIAlertActionStyle) {
    SIAlertActionStyleDefault = 0,
    SIAlertActionStyleCancel,
    SIAlertActionStyleDestructive,
    SIAlertActionStyleTitle = 0xff,
    SIAlertActionStyleMessage,
};

#define kSIAlertViewActionTitleColorDict @{                            \
    @(SIAlertActionStyleDefault): [SIColor colorWithHex:0x0076ff],     \
    @(SIAlertActionStyleCancel): [SIColor colorWithHex:0x0076ff],      \
    @(SIAlertActionStyleDestructive): [SIColor colorWithHex:0xfe3824], \
    @(SIAlertActionStyleTitle): [SIColor colorWithHex:0x4a4a4a],       \
    @(SIAlertActionStyleMessage): [SIColor colorWithHex:0x4a4a4a],     \
}

@protocol SIAlertActionProtocol <NSObject>

/**
 YCPopMenuItemProtocol
 */
@property (nonatomic, assign) CGFloat menuHeight;

@property (nonatomic, assign) BOOL first;

@property (nonatomic, assign) BOOL last;

@property (nonatomic, assign) BOOL available;

@property (nonatomic, strong) UIColor *tintColor;

@end

#endif /* SIAlertViewDefine_h */
