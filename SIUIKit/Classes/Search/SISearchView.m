//
//  SISearchView.m
//  SuperId
//
//  Created by wangwei on 2018/3/8.
//  Copyright © 2018年 SuperId. All rights reserved.
//

#import "SISearchView.h"
#import <Masonry/Masonry.h>
#import <SITheme/SIColor.h>
#import <SITheme/SIFont.h>

@interface SISearchView () <UITextFieldDelegate>

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation SISearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [SIColor colorWithHex:0xe9e9e9];
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;

    [self addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.width.equalTo(@(47));
    }];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 38, height);
    [backButton setImage:[UIImage imageNamed:@"ic_back_chevron"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    self.backButton = backButton;
    _hasBackButton = YES;

    self.textField.frame = CGRectMake(CGRectGetMaxX(backButton.frame), 5, width - 47 - CGRectGetMaxX(backButton.frame), height - 10);
    [self addSubview:self.textField];
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:SIColor.primaryColor forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [SIFont systemFontOfSize:14];
        [_cancelButton addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (void)setActive:(BOOL)active {
    _active = active;
    if (!active) {
        self.textField.text = nil;
        self.hideCancelButton = YES;
    }
}

#pragma mark - delegate
#pragma mark textField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.keyText) {
        NSString *keyString = [NSString stringWithFormat:@"%@ ", self.keyText];
        NSRange keyRange = [self.textField.text rangeOfString:keyString];
        if (range.location < keyRange.length) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchViewClearAction:)]) {
        [self.delegate searchViewClearAction:self];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchView:searchActionKeyText:searchString:)]) {
        NSString *searchString = textField.text;
        if (self.keyText) {
            searchString = [searchString substringFromIndex:self.keyText.length + 1];
        }
        [self.delegate searchView:self searchActionKeyText:self.keyText searchString:searchString];
    }
    [self.textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _active = YES;
    if ([self.delegate respondsToSelector:@selector(searchViewDidBeginEditing:)]) {
        [self.delegate searchViewDidBeginEditing:self];
    } else {
        self.hideCancelButton = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchViewDidEndEditing:)]) {
        [self.delegate searchViewDidEndEditing:self];
    }
}

#pragma mark 输入改变通知

- (void)editingChanged:(UITextField *)textField {
    NSString *searchString = self.textField.text;
    if (self.keyText && ![@"" isEqualToString:searchString]) {
        searchString = [searchString substringFromIndex:self.keyText.length + 1];
    }
    if ([self.delegate respondsToSelector:@selector(searchView:keyText:textFielDidChangeText:)]) {
        [self.delegate searchView:self keyText:self.keyText textFielDidChangeText:searchString];
    }
    if (textField.text.length == 0) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    } else {
        textField.clearButtonMode = UITextFieldViewModeAlways;
    }
}

#pragma mark - 事件
#pragma mark 取消

- (void)cancleButtonAction:(UIButton *)sender {
    _active = NO;
    if ([self.delegate respondsToSelector:@selector(searchViewCancelAction:)]) {
        [self.delegate searchViewCancelAction:self];
    } else {
        self.textField.text = @"";
        [self.textField resignFirstResponder];
        self.hideCancelButton = YES;
        [self textFieldDidEndEditing:self.textField];
    }
}

#pragma mark 返回

- (void)backButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(searchViewBackAction:)]) {
        [self.delegate searchViewBackAction:self];
    }
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.backgroundColor = [SIColor whiteColor];
        _textField.layer.cornerRadius = 5;
        _textField.layer.masksToBounds = YES;
        _textField.placeholder = @"搜索";
        _textField.font = [SIFont systemFontOfSize:12];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.returnKeyType = UIReturnKeySearch;
        [_textField addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
        _textField.delegate = self;
        _textField.leftView = ({
            CGFloat imageWidth = 11;
            CGFloat imageLeftSpace = 8.5;
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
            UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageLeftSpace, 0, imageWidth, imageWidth)];
            searchImageView.center = CGPointMake(searchImageView.center.x, view.bounds.size.height * 0.5);
            searchImageView.image = [UIImage imageNamed:@"ic_search"];
            [view addSubview:searchImageView];
            view;
        });
    }
    return _textField;
}

- (void)setKeyText:(NSString *)keyText {
    _keyText = keyText;
    if (!keyText) {
        self.textField.text = @"";
        return;
    }
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self.keyText attributes:@{NSFontAttributeName: [SIFont systemFontOfSize:12], NSForegroundColorAttributeName: SIColor.primaryColor}];
    [attributeString appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName: [SIFont systemFontOfSize:12], NSForegroundColorAttributeName: [SIColor colorWithHex:0x4a4a4a]}]];
    self.textField.attributedText = attributeString;
}

- (void)setHasBackButton:(BOOL)hasBackButton {
    if (_hasBackButton == hasBackButton) {
        return;
    }
    _hasBackButton = hasBackButton;
    if (hasBackButton) {
        CGRect backButtonFrame = self.backButton.frame;
        backButtonFrame.origin.x = 0;
        CGRect textFieldFrame = self.textField.frame;
        textFieldFrame.origin.x = CGRectGetMaxX(backButtonFrame);
        textFieldFrame.size.width = textFieldFrame.size.width - backButtonFrame.size.width + 8;
        self.backButton.alpha = 1;
        [UIView animateWithDuration:0.38
                         animations:^{
                             self.backButton.frame = backButtonFrame;
                             self.textField.frame = textFieldFrame;
                         }];
    } else {
        CGRect backButtonFrame = self.backButton.frame;
        backButtonFrame.origin.x -= backButtonFrame.size.width;
        CGRect textFieldFrame = self.textField.frame;
        textFieldFrame.origin.x = 8;
        textFieldFrame.size.width = textFieldFrame.size.width + backButtonFrame.size.width - textFieldFrame.origin.x;
        [UIView animateWithDuration:0.38
                         animations:^{
                             self.backButton.frame = backButtonFrame;
                             self.backButton.alpha = 0;
                             self.textField.frame = textFieldFrame;
                         }];
    }
}

- (void)setHideCancelButton:(BOOL)hideCancelButton {
    if (_hideCancelButton == hideCancelButton) {
        return;
    }
    _hideCancelButton = hideCancelButton;
    if (hideCancelButton) {
        self.cancelButton.hidden = YES;
        CGRect frame = self.textField.frame;
        frame.size.width += 40;
        [UIView animateWithDuration:0.38
                         animations:^{
                             self.textField.frame = frame;
                         }];
    } else {
        self.cancelButton.hidden = NO;
        CGRect frame = self.textField.frame;
        frame.size.width -= 40;
        [UIView animateWithDuration:0.38
                         animations:^{
                             self.textField.frame = frame;
                         }];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
