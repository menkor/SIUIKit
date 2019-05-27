//
//  SIAffairNaviRightView.m
//  SuperId
//
//  Created by Ye Tao on 2019/5/14.
//  Copyright © 2019 SuperID. All rights reserved.
//

#import "SIAffairNaviRightView.h"
#import <Masonry/Masonry.h>
#import <SIBase/SIFormItem.h>
#import <SIDefine/SIGlobalMacro.h>
#import <SITheme/SIColor.h>

@interface SIAffairNaviRightView ()

@property (nonatomic, strong) UIButton *role;

@property (nonatomic, strong) UIButton *more;

@property (nonatomic, strong) SIFormItem *item;

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
    self.item = [SIFormItem new];
    [self.more mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self);
        make.width.mas_equalTo(44);
    }];

    [self.role mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(44);
        make.right.mas_equalTo(self.more.mas_left);
    }];
    [self reloadData];
}

- (void)reloadData {
    if (self.item.selected) {
        [self.role setImage:[UIImage imageNamed:@"ic_jueseqiehuan_b"] forState:UIControlStateNormal];
        [self.more setImage:[UIImage imageNamed:@"ic_more"] forState:UIControlStateNormal];
    } else {
        [self.role setImage:[UIImage imageNamed:@"ic_jueseqiehuan_w"] forState:UIControlStateNormal];
        [self.more setImage:[UIImage imageNamed:@"ic_more_white"] forState:UIControlStateNormal];
    }
    [self.more mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.item.editEnable ? 44 : 0);
    }];
    if (self.item.icon) {
        [self.more setImage:[UIImage imageNamed:self.item.icon] forState:UIControlStateNormal];
    }
}

- (void)pop {
    SIAffairNaviRightPop(self.delegate, self.item.data, self.role);
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

@end
