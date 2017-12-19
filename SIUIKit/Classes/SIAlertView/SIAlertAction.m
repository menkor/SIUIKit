//
//  SIAlertAction.m
//  SuperId
//
//  Created by Ye Tao on 2017/8/23.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "SIAlertAction.h"

@interface SIAlertAction ()

@property (nonatomic, copy) void (^handler)(SIAlertAction *);

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) SIAlertActionStyle style;

@property (nonatomic, strong) UIColor *tintColor;

/**
 SIAlertActionProtocol
 */
@property (nonatomic, assign) CGFloat menuHeight;

@property (nonatomic, assign) BOOL first;

@property (nonatomic, assign) BOOL last;

@property (nonatomic, assign) BOOL available;

@end

@implementation SIAlertAction

+ (instancetype)actionWithTitle:(NSString *)title
                          style:(SIAlertActionStyle)style
                        handler:(void (^)(SIAlertAction *))handler {
    SIAlertAction *action = [SIAlertAction new];
    action.handler = handler;
    action.title = title;
    action.style = style;
    action.available = YES;
    return action;
}

- (void)dealloc {
}

@end
