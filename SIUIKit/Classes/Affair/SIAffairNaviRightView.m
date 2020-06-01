//
//  SIAffairNaviRightView.m
//  SuperId
//
//  Created by Ye Tao on 2019/5/14.
//  Copyright © 2019 SuperID. All rights reserved.
//

#import "SIAffairNaviRightView.h"
#import <Masonry/Masonry.h>
#import <SIDefine/SIGlobalMacro.h>
#import <SITheme/SIColor.h>

@implementation SIAffairNaviRightItem

@end

@interface SIAffairNaviRightView ()

@property (nonatomic, strong) UIButton *role;

@property (nonatomic, strong) UIButton *more;

@property (nonatomic, strong) UIView *extraArea;

@property (nonatomic, strong) SIAffairNaviRightItem *item;

@end

@implementation SIAffairNaviRightView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self initUI];
    return self;
}

- (void)initUI {
    self.item = [SIAffairNaviRightItem new];
    [self.extraArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self);
        make.width.mas_equalTo(0);
    }];

    [self.more mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(44);
        make.right.mas_equalTo(self.extraArea.mas_left);
    }];

    [self.role mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(44);
        make.right.mas_equalTo(self.more.mas_left);
    }];
    [self reloadData];
}

- (void)reloadData {
    if (self.item.white) {
        [self.role setImage:[UIImage imageNamed:@"ic_jueseqiehuan_b"] forState:UIControlStateNormal];
        [self.more setImage:[UIImage imageNamed:@"ic_more"] forState:UIControlStateNormal];
    } else {
        [self.role setImage:[UIImage imageNamed:@"ic_jueseqiehuan_w"] forState:UIControlStateNormal];
        [self.more setImage:[UIImage imageNamed:@"ic_more_white"] forState:UIControlStateNormal];
    }
    [self.more mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.item.showRight ? 44 : 0);
    }];
    if (self.item.rightIcon && self.item.showRight) {
        [self.more setImage:[UIImage imageNamed:self.item.rightIcon] forState:UIControlStateNormal];
    }
    if (self.item.hideRole) {
        self.role.hidden = YES;
    } else {
        self.role.hidden = NO;
    }
    [self.extraArea.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.item.extra.count > 0) {
        __block UIView *pre = nil;
        __block CGFloat totalExtraWidth = 0;
        [self.item.extra enumerateObjectsUsingBlock:^(UIButton *_Nonnull button, NSUInteger idx, BOOL *_Nonnull stop) {
            totalExtraWidth += button.frame.size.width;
            [self.extraArea addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                if (pre) {
                    make.right.mas_equalTo(pre.mas_left);
                } else {
                    make.right.mas_equalTo(self.extraArea);
                }
                make.size.mas_equalTo(button.frame.size);
                make.centerY.mas_equalTo(self.extraArea);
            }];
        }];
        [self.extraArea mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(totalExtraWidth);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(44 * 2 + totalExtraWidth);
        }];
    } else {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(44 * 2);
        }];

        [self.extraArea mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
}

- (void)pop {
    SIAffairNaviRightPop(self.delegate, self.item.affair, self.role);
}

- (void)moreAction {
    if ([self.delegate respondsToSelector:@selector(naviRightView:action:data:)]) {
        [self.delegate naviRightView:self action:SIAffairNaviRightActionTypeMore data:nil];
    }
}

#pragma mark - Lazy Load

- (UIButton *)role {
    if (!_role) {
        _role = [[UIButton alloc] init];
        [_role addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_role];
    }
    return _role;
}

- (UIButton *)more {
    if (!_more) {
        _more = [[UIButton alloc] init];
        [_more addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_more];
    }
    return _more;
}

- (UIView *)extraArea {
    if (!_extraArea) {
        _extraArea = [UIView new];
        [self addSubview:_extraArea];
    }
    return _extraArea;
}

@end
