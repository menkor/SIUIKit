//
//  SIAlertAction.h
//  SuperId
//
//  Created by Ye Tao on 2017/8/23.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "SIAlertViewDefine.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface SIAlertAction : NSObject
+ (instancetype)actionWithTitle:(NSString *)title
                          style:(SIAlertActionStyle)style
                        handler:(void (^__nullable)(SIAlertAction *action))handler;

@property (nonatomic, readonly) NSString *title;

@property (nonatomic, readonly) SIAlertActionStyle style;

@property (nonatomic, copy, readonly, nullable) void (^handler)(SIAlertAction *action);

@property (nonatomic, getter=isEnabled) BOOL enabled;

@end
NS_ASSUME_NONNULL_END
