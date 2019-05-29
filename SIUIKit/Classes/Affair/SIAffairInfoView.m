//
//  SIAffairInfoView.m
//  SuperId
//
//  Created by Ye Tao on 2019/5/14.
//  Copyright © 2019 SuperID. All rights reserved.
//

#import "SIAffairInfoView.h"
#import <Masonry/Masonry.h>
#import <SIBase/SIFormItem.h>
#import <SITheme/SIColor.h>
#import <SITheme/SIFont.h>
#import <SIUtils/UIImageView+SIKit.h>

@interface SIAffairInfoView ()

@property (nonatomic, strong) UIImageView *avatar;

@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) UILabel *content;

@end

@implementation SIAffairInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [SIColor clearColor];

    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).inset(0);
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(30);
    }];

    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatar.mas_right).inset(10);
        make.top.mas_equalTo(self.avatar).offset(-2);
        make.height.mas_equalTo(21);
        make.right.mas_equalTo(self.contentView);
    }];

    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatar.mas_right).inset(10);
        make.bottom.mas_equalTo(self.avatar).offset(1);
        make.height.mas_equalTo(14);
        make.right.mas_equalTo(self.contentView);
    }];
}

- (void)reloadWithData:(SIFormItem *)model {
    [self.avatar si_setImageWithURL:model.avatar placeholderImage:[UIImage imageNamed:@"affair_default_avatar"]];
    if (model.title.length == 0) {
        self.title.text = model.content;
        self.content.text = nil;
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30 + 4);
        }];
    } else {
        self.title.text = model.title;
        self.content.text = model.content;
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(21);
        }];
    }
}

#pragma mark - Lazy Load

- (UIView *)contentView {
    return self;
}

- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [UIImageView new];
        _avatar.backgroundColor = [SIColor whiteColor];
        _avatar.layer.cornerRadius = 5;
        _avatar.layer.masksToBounds = YES;
        [self.contentView addSubview:_avatar];
    }
    return _avatar;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = [SIColor colorWithHex:0x030303];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.font = [SIFont systemFontOfSize:15];
        [self.contentView addSubview:_title];
    }
    return _title;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.textColor = [SIColor colorWithHex:0x9b9b9b];
        _content.textAlignment = NSTextAlignmentLeft;
        _content.font = [SIFont systemFontOfSize:10];
        [self.contentView addSubview:_content];
    }
    return _content;
}

@end