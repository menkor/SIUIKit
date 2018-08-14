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
+ (void)showMessage:(NSString *)message;

/**
 auto dismiss after 1.5s

 @param @error it's an error
 */
+ (void)showError:(NSString *)error;

/**
 
 @param @waiting just what you wanna tell users
 */
+ (void)showWaiting:(NSString *)waiting;

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

@property (nonatomic, strong) UIColor *coverColor; //default is `[UIColor colorWithWhite:0 alpha:0.4]`

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

#pragma mark - Animation

/*!
 @brief Default is YES;
 */
@property (nonatomic, assign) BOOL animated;

#pragma mark - Custom Message View

/*!
 @code
 SIMessageBox *box = [SIMessageBox boxWithType:(HTMessageBoxTypeOK) title:@"提示" message:nil];
 UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
 view.backgroundColor = [UIColor redColor];
 [box setCustomMessageView:view];
 [box show];
 @endcode
 */
- (void)setCustomMessageView:(UIView *)view;

@end
