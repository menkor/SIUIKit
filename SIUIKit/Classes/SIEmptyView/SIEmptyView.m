//
//  SIEmptyView.m
//  SuperId
//
//  Created by Ye Tao on 2017/8/14.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "SIEmptyView.h"
#import <Masonry/Masonry.h>
#import <SIDefine/SIGlobalMacro.h>
#import <SITheme/SIColor.h>
#import <SITheme/SIFont.h>
#import <SIUtils/NSString+SIKit.h>

@interface SIEmptyView ()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

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
    self.backgroundColor = [SIColor colorWithHex:0xf7f7f7];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0, 0));
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).offset(-30);
    }];

    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.centerY.mas_equalTo(self.title);
        make.right.mas_equalTo(self.title.mas_left);
    }];

    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(18);
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.icon.mas_bottom).inset(12);
    }];
}

- (void)reloadWithData:(NSNumber *)model {
    NSDictionary *theme = kSIEmptyViewThemeDict[model] ?: self.theme;
    self.indicatorView.hidden = YES;
    self.title.text = theme[kSIEmptyViewThemeTitle];
    if (theme[kSIEmptyViewThemeBackgroundColor]) {
        self.backgroundColor = theme[kSIEmptyViewThemeBackgroundColor];
    } else {
        self.backgroundColor = [SIColor colorWithHex:0xf7f7f7];
    }
    CGSize titleSize = [self.title.text si_sizeFitWidth:ScreenWidth - 120 font:self.title.font];
    CGFloat titleWidth = titleSize.width;
    _button.hidden = YES;
    if (theme[kSIEmptyViewThemeAction]) {
        self.button.hidden = NO;
        [self.button setTitle:theme[kSIEmptyViewThemeAction] forState:UIControlStateNormal];
    }

    if ([theme[kSIEmptyViewThemeLoading] boolValue]) {
        self.indicatorView.hidden = NO;
        [self.indicatorView startAnimating];
        self.icon.image = nil;
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self).offset(22);
            make.width.mas_equalTo(titleWidth);
        }];
    } else {
        [self.indicatorView stopAnimating];
        self.icon.image = [UIImage imageNamed:theme[kSIEmptyViewThemeIcon] ?: @"ic_no_content"];
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.width.mas_equalTo(titleWidth);
            make.height.mas_equalTo(titleSize.height);
        }];
    }

    CGFloat topOffset = [theme[kSIEmptyViewThemeTopOffset] floatValue];
    CGSize size = self.icon.image.size;
    [self.icon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self).offset(topOffset / 2);
        make.size.mas_equalTo(size);
    }];
}

- (void)setTheme:(NSDictionary *)theme {
    _theme = [theme copy];
    if (theme) {
        [self reloadWithData:@(SIEmptyViewTypeNoData)];
    }
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
        _title.numberOfLines = 0;
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

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self addSubview:_indicatorView];
    }
    return _indicatorView;
}

@end

@interface SIAutoRefreshHeader ()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation SIAutoRefreshHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self initUI];
    return self;
}

- (void)initUI {
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(44);
    }];
    [self.indicatorView startAnimating];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action:)];
    [self addGestureRecognizer:tap];
}

- (void)reloadWithData:(NSString *)model {
}

- (void)action:(id)sender {
    if (self.actionBlock) {
        self.actionBlock(nil);
    }
}

#pragma mark - Lazy Load

- (UIView *)contentView {
    return self;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        [self.contentView addSubview:_indicatorView];
    }
    return _indicatorView;
}

@end

@interface SIAutoRefreshFooter ()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) UILabel *content;

@end

@implementation SIAutoRefreshFooter

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self initUI];
    return self;
}

- (void)initUI {
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.right.mas_equalTo(self.content.mas_left).inset(5);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(44);
    }];

    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(44);
        make.centerX.mas_equalTo(self).inset(15);
        make.width.mas_equalTo(80);
    }];
    self.content.text = @"正在加载...";
    [self.indicatorView startAnimating];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action:)];
    [self addGestureRecognizer:tap];
}

- (void)reloadWithData:(NSString *)model {
    self.content.text = model ?: @"正在加载...";
}

- (void)action:(id)sender {
    if (self.actionBlock) {
        self.actionBlock(nil);
    }
}

#pragma mark - Lazy Load

- (UIView *)contentView {
    return self;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        [self.contentView addSubview:_indicatorView];
    }
    return _indicatorView;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.textColor = [SIColor colorWithHex:0x9b9b9b];
        _content.textAlignment = NSTextAlignmentRight;
        _content.font = [SIFont systemFontOfSize:14];
        [self.contentView addSubview:_content];
    }
    return _content;
}

@end
