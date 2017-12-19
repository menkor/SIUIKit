//
//  SIAlertView.h
//  SuperId
//
//  Created by Ye Tao on 2017/8/23.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "SIAlertAction.h"
#import "SIAlertViewDefine.h"
#import <UIKit/UIKit.h>

@interface SIAlertView : UIView

@property (nonatomic, readonly) NSArray<SIAlertAction *> *actions;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

+ (instancetype)alertControllerWithTitle:(NSString *)title
                                 message:(NSString *)message;

- (void)addAction:(SIAlertAction *)action;

- (void)show;

+ (void)setTintColor:(UIColor *)tintColor once:(BOOL)once;

@end
