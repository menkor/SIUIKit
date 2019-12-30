//
//  SISearchView.h
//  SuperId
//
//  Created by wangwei on 2018/3/8.
//  Copyright © 2018年 SuperId. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SIChatRecordSearchViewDelegate;

@interface SISearchView : UIView

@property (nonatomic, weak) id<SIChatRecordSearchViewDelegate> delegate;

@property (nonatomic, assign) BOOL hasBackButton;

@property (nonatomic, assign) BOOL active;

@property (nonatomic, assign) BOOL hideCancelButton;

@property (nonatomic, copy) NSString *keyText;

@property (nonatomic, strong) UITextField *textField;

@end

@protocol SIChatRecordSearchViewDelegate <NSObject>

@optional

- (void)searchViewDidBeginEditing:(SISearchView *)searchView;

- (void)searchViewDidEndEditing:(SISearchView *)searchView;

- (void)searchViewBackAction:(SISearchView *)searchView;

- (void)searchViewCancelAction:(SISearchView *)searchView;

- (void)searchViewClearAction:(SISearchView *)searchView;

- (void)searchView:(SISearchView *)searchView searchActionKeyText:(NSString *)keyText searchString:(NSString *)searchString;

- (void)searchView:(SISearchView *)searchView keyText:(NSString *)keyText textFielDidChangeText:(NSString *)text;

@end
