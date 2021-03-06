//
//  SIMessageBox.h
//  SuperId
//
//  Created by Ye Tao on 2017/8/15.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "SIMessageBoxDefine.h"
#import <UIKit/UIKit.h>

@interface SIMessageBox : UIView

#pragma mark - Default Builder

/**
 auto dismiss after 1.5s

 @param @message just what you wanna tell users
 */
+ (instancetype)showMessage:(NSString *)message;

/**
 auto dismiss after 1.5s

 @param @error it's an error
 */
+ (instancetype)showError:(NSString *)error;

/**
 auto dismiss after 1.5s

 @param @info it's an info
 */
+ (instancetype)showInfo:(NSString *)info;

/**
 auto dismiss after 1.5s

 @param @warning it's a warning
 */
+ (instancetype)showWarning:(NSString *)warning;

/**
 
 @param @waiting just what you wanna tell users
 */
+ (instancetype)showWaiting:(NSString *)waiting;

+ (instancetype)showWaiting:(NSString *)waiting hideAfterDelay:(CGFloat)delay;

+ (void)hideWaiting;

/*!
 @brief 如果调用此方法,则需要调用 -setAllButtonActionBlock: 设置全部按钮的回调block.
 @sa -setAllButtonActionBlock:
 */
+ (instancetype)boxWithType:(SIMessageBoxType)type
                      title:(NSString *)title
                    message:(NSString *)message;

+ (instancetype)boxWithType:(SIMessageBoxType)type
                      title:(NSString *)title
                    message:(NSString *)message
                     action:(SIMessageBoxActionBlock)actionBlock;

- (void)setAllButtonActionBlock:(SIMessageBoxActionBlock)actionBlock;

#pragma mark - Initialize

+ (instancetype)createWithTitle:(NSString *)title
                        message:(NSString *)message;

/*!
 Button的顺序即是添加的顺序,先添加的在左边.
 @code
 [box addButtonWithTitle:@"确定"];
 [box addButtonWithTitle:@"取消"];
 @endcode
 @remark 这样则是左边是@"确定",右边是@"取消"
 */
- (NSUInteger)addButtonWithTitle:(NSString *)title;

/*!
 @sa -addButtonWithTitle:
 */
- (NSUInteger)addButtonWithTitle:(NSString *)title
                          action:(SIMessageBoxActionBlock)actionBlock;

@property (nonatomic, strong) UIColor *coverColor; //default is `clear`

@property (nonatomic, assign) NSTextAlignment messageAlignment; //default is `Center`

#pragma mark - Visible

@property (nonatomic, assign) BOOL visible;

/*!
 @brief It would dismiss after touch some button.
 */
- (void)show;

/*!
 @brief You will Barely call this method.
 */
- (void)hide;

/*!
 @brief If not visible,It would show.then hide after the delay you set
 */
- (void)hideAfterDelay:(CFTimeInterval)delay;

- (void)showFrom:(UIView *)view;

#pragma mark - Animation

/*!
 @brief Default is YES;
 */
@property (nonatomic, assign) BOOL animated;

#pragma mark - Custom Message View

/*!
 @code
 SIMessageBox *box = [SIMessageBox boxWithType:(SIMessageBoxTypeOK) title:@"提示" message:nil];
 UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
 view.backgroundColor = [UIColor redColor];
 [box setCustomMessageView:view];
 [box show];
 @endcode
 */
- (void)setCustomMessageView:(UIView *)view;

#pragma mark - Event

@property (nonatomic, copy) BOOL (^touchInBackground)(CGPoint point);

@property (nonatomic, copy) void (^onShowup)(UIView *contentView);

@property (nonatomic, assign) BOOL hold;

@property (nonatomic, strong) NSDictionary *theme;

#pragma mark - Chain

@property (nonatomic, readonly) SIMessageBox * (^willHold)(NSTimeInterval duration);

@property (class, nonatomic, readonly) SIMessageBox * (^error)(NSString *error);

@property (class, nonatomic, readonly) SIMessageBox * (^message)(NSString *message);

@property (class, nonatomic, readonly) SIMessageBox * (^info)(NSString *info);

@property (class, nonatomic, readonly) SIMessageBox * (^warning)(NSString *warning);

@property (class, nonatomic, readonly) SIMessageBox * (^waiting)(NSString *waiting);

@property (class, nonatomic, readonly) SIMessageBox * (^builder)(SIMessageBoxType type);

@property (nonatomic, readonly) SIMessageBox * (^addTitle)(NSString *title);

@property (nonatomic, readonly) SIMessageBox * (^addMessage)(NSString *message);

@property (nonatomic, readonly) SIMessageBox * (^pop)(UIView *view);

@end
