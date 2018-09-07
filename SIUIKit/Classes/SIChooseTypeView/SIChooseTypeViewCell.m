//
//  SIChooseTypeViewCell.m
//  SuperId
//
//  Created by Ye Tao on 2018/2/9.
//  Copyright © 2018年 SuperId. All rights reserved.
//

#import "SIChooseTypeViewCell.h"
#import <Masonry/Masonry.h>
#import <SITheme/SIColor.h>
#import <SITheme/SIFont.h>

@interface SIChooseTypeViewCell ()

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UILabel *title;

@end

@implementation SIChooseTypeViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self initUI];
    return self;
}

- (void)initUI {
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.mas_equalTo(self.contentView);
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.contentView.mas_width);
    }];

    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.button.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(22);
    }];
}

- (void)reloadWithData:(id<SIFormItemProtocol>)model {
    [_button setImage:[UIImage imageNamed:model.icon] forState:UIControlStateNormal];
    self.title.text = model.title;
}

- (void)action:(UIButton *)sender {
    if (self.actionBlock) {
        self.actionBlock(@(sender.tag));
    }
}

#pragma mark - Lazy Load

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button];
    }
    return _button;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = [SIColor colorWithHex:0x4a4a4a];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font = [SIFont mediumSystemFontOfSize:16];
        [self.contentView addSubview:_title];
    }
    return _title;
}

@end
