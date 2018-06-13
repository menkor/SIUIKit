//
//  SIEmptyView.m
//  SuperId
//
//  Created by Ye Tao on 2017/8/14.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "SIEmptyView.h"
#import <Masonry/Masonry.h>
#import <SITheme/SIColor.h>
#import <SITheme/SIFont.h>

@interface SIEmptyView ()

@property (nonatomic, strong) UIImageView *icon;

@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) UIButton *button;

@end

@implementation SIEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0, 0));
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).offset(-30);
    }];

    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 18));
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.icon.mas_bottom).offset(12);
    }];
}

- (void)reloadWithData:(id)model {
    NSDictionary *theme = kSIEmptyViewThemeDict[model] ?: self.theme;
    self.title.text = theme[kSIEmptyViewThemeTitle];
    self.icon.image = [UIImage imageNamed:theme[kSIEmptyViewThemeIcon]];
    _button.hidden = YES;
    if (theme[kSIEmptyViewThemeAction]) {
        self.button.hidden = NO;
        [self.button setTitle:theme[kSIEmptyViewThemeAction] forState:UIControlStateNormal];
    }
    [self.icon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.icon.image.size);
    }];
}

- (void)action:(UIButton *)sender {
    if (self.actionBlock) {
        self.actionBlock(@(sender.tag));
    }
}

#pragma mark - Lazy Load

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = [SIColor colorWithHex:0x9b9b9b];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font = [SIFont lightSystemFontOfSize:12];
        [self addSubview:_title];
    }
    return _title;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        [self addSubview:_icon];
    }
    return _icon;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.layer.borderColor = [SIColor colorWithHex:0x979797].CGColor;
        _button.layer.borderWidth = 0.5;
        _button.layer.cornerRadius = 12;
        _button.layer.masksToBounds = YES;
        _button.titleLabel.font = [SIFont lightSystemFontOfSize:12];
        [_button setTitleColor:[SIColor colorWithHex:0x9b9b9b] forState:UIControlStateNormal];
        [self addSubview:_button];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(84, 24));
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.title.mas_bottom).offset(24);
        }];
        [_button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

@end
