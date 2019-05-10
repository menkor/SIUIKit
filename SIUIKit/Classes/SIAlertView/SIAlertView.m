//
//  SIAlertView.m
//  SuperId
//
//  Created by Ye Tao on 2017/8/23.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "SIAlertView.h"
#import "SIAlertViewCell.h"
#import <SIDefine/SIDefine.h>
#import <SITheme/SIColor.h>
#import <SITheme/SIFont.h>

@interface SIAlertViewManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *theme;

@property (nonatomic, strong) NSMutableDictionary *onceTheme;

@property (nonatomic, strong) NSMutableSet *instanceSet;

@end

@implementation SIAlertViewManager

+ (instancetype)sharedInstance {
    static dispatch_once_t once = 0;
    static id instance = nil;

    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _instanceSet = [NSMutableSet set];
        _theme = [kSIAlertViewActionTitleColorDict mutableCopy];
        _onceTheme = [NSMutableDictionary dictionary];
        _theme[kSIAlertThemeMessageFont] = [SIFont systemFontOfSize:16];
    }
    return self;
}

@end

@interface SIAlertView ()

@property (nonatomic, strong) NSMutableArray<SIAlertAction<SIAlertActionProtocol> *> *actions;

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, void (^)(SIAlertAction *action)> *handerMap;

@property (nonatomic, assign) BOOL addedCancel;

@property (nonatomic, strong) NSMutableDictionary *theme;

@end

@implementation SIAlertView

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message {
    SIAlertView *alert = [SIAlertView new];
    NSDictionary *defaultTheme = [SIAlertViewManager sharedInstance].theme;
    alert.theme = [defaultTheme mutableCopy];
    [alert.theme setValuesForKeysWithDictionary:[SIAlertViewManager sharedInstance].onceTheme];
    [[SIAlertViewManager sharedInstance].onceTheme removeAllObjects];
    alert.title = title;
    alert.message = message;
    alert.actions = [NSMutableArray array];
    alert.handerMap = [NSMutableDictionary dictionary];
    return alert;
}

- (void)addAction:(SIAlertAction<SIAlertActionProtocol> *)action {
    //action.menuHeight = 50 + 20 * _actions.count;
    if (action.menuHeight <= 0) {
        action.menuHeight = 56;
    }
    if (action.style == SIAlertActionStyleCancel) {
        if (self.addedCancel) {
            NSAssert(NO, @"SIAlertView can only have one action with a style of SIAlertActionStyleCancel");
        }
        action.first = YES;
        action.last = YES;
        self.addedCancel = YES;
        action.menuHeight = 56 + 18;

    } else {
        action.last = YES;
        if (_actions.count == 0) {
            action.first = YES;
        }
        _actions.lastObject.last = NO;
        if (action.handler) {
            _handerMap[@(_actions.count)] = action.handler;
        }
    }
    action.tintColor = action.tintColor ?: self.theme[@(action.style)];
    [_actions addObject:action];
}

- (void)show {
    __block SIAlertAction<SIAlertActionProtocol> *message = nil;
    __block SIAlertAction<SIAlertActionProtocol> *title = nil;
    NSMutableArray *cellIdentifierArrray = [NSMutableArray array];
    NSMutableArray *actions = [self.actions mutableCopy];
    [self.actions enumerateObjectsUsingBlock:^(SIAlertAction<SIAlertActionProtocol> *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj.style == SIAlertActionStyleTitle) {
            title = obj;
            [actions removeObject:obj];
        } else if (obj.style == SIAlertActionStyleMessage) {
            message = obj;
            [actions removeObject:obj];
        }
        if (obj.cellIdentifier) {
            [cellIdentifierArrray addObject:obj.cellIdentifier];
        }
    }];
    self.actions = actions;
    if (!message && self.message) {
        message = (id)[SIAlertAction actionWithTitle:self.message
                                               style:SIAlertActionStyleMessage
                                             handler:nil];
        UIFont *messageFont = message.font ?: self.theme[kSIAlertThemeMessageFont];
        CGSize size = [message.title boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 100, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                               attributes:@{NSFontAttributeName: messageFont}
                                                  context:NULL]
                          .size;
        if (size.height == messageFont.lineHeight) { //超过一行
            message.menuHeight = 56;
        } else {
            message.menuHeight = size.height + 32;
        }
        _actions.firstObject.first = NO;
        message.first = YES;
        message.available = NO;
        message.tintColor = message.tintColor ?: self.theme[@(message.style)];
        message.font = messageFont;
    }
    if (message) {
        [_actions insertObject:message atIndex:0];
    }

    if (!title && self.title) {
        title = (id)[SIAlertAction actionWithTitle:self.title
                                             style:SIAlertActionStyleTitle
                                           handler:nil];
        UIFont *font = title.font ?: [SIFont systemFontOfSize:16];
        CGSize size = [title.title boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 100, CGFLOAT_MAX)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName: font}
                                                context:NULL]
                          .size;
        if (size.height == font.lineHeight) { //超过一行
            title.menuHeight = 56;
        } else {
            title.menuHeight = size.height + 32;
        }
        _actions.firstObject.first = NO;
        title.first = YES;
        title.available = NO;
        title.tintColor = title.tintColor ?: self.theme[@(title.style)];
    }
    if (title) {
        [_actions insertObject:title atIndex:0];
    }
    YCPopMenu *popMenu = [YCPopMenu popMenuWithCellClass:[SIAlertViewCell class]
                                               dataArray:_actions
                                             actionBlock:^(NSUInteger index, SIAlertAction *action) {
                                                 if (index != YCPopMenuNoSelectionIndex) {
                                                     if (action.handler) {
                                                         action.handler(action);
                                                     }
                                                 }
                                             }];
    [popMenu setDirection:YCPopMenuDirectionUp];
    [cellIdentifierArrray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [popMenu.tableView registerClass:NSClassFromString(obj) forCellReuseIdentifier:obj];
    }];
    popMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    popMenu.maxCellCount = 10;
    popMenu.menuSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 56);
    popMenu.coverColor = [SIColor colorWithWhite:0 alpha:0.5];
    popMenu.arrowSize = CGSizeMake(0, 0);
    CGPoint point = CGPointMake(0, [UIScreen mainScreen].bounds.size.height - kBottomHeight);
    [popMenu showFromPoint:point];
}

@end

@implementation SIAlertView (Appearance)

+ (void)setTheme:(NSDictionary *)theme once:(BOOL)once {
    NSMutableDictionary *old = once ? [SIAlertViewManager sharedInstance].onceTheme : [SIAlertViewManager sharedInstance].theme;
    if ([theme isKindOfClass:[NSDictionary class]]) {
        [old setValuesForKeysWithDictionary:theme];
    }
}

@end
