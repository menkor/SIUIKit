//
//  SIAlertViewCell.m
//  SuperId
//
//  Created by Ye Tao on 2017/8/23.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "SIAlertViewCell.h"
#import "SIAlertAction.h"
#import "SIRectCornerLayer.h"
#import "SIColor.h"
#import "SIFont.h"
#import <Masonry/Masonry.h>

@interface SIAlertViewCell ()

@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) SIRectCornerLayer *cornerLayer;

@property (nonatomic, strong) UIView *line;

@end

@implementation SIAlertViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    [self initUI];
    return self;
}

- (void)initUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [SIColor clearColor];
    self.backgroundColor = [SIColor clearColor];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 50, 0, 50));
    }];
}

- (void)reloadWithData:(SIAlertAction<SIAlertActionProtocol> *)model {
    self.title.text = model.title;
    self.title.textColor = model.tintColor;
    [self.cornerLayer removeFromSuperlayer];
    self.cornerLayer = [SIRectCornerLayer layer];
    self.cornerLayer.cornerRadius = 12;
    if (model.style == SIAlertActionStyleCancel) {
        self.cornerLayer.frame = CGRectMake(10, 9, [UIScreen mainScreen].bounds.size.width - 20, model.menuHeight - 18);
    } else {
        self.cornerLayer.frame = CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 20, model.menuHeight);
    }
    if (model.style == SIAlertActionStyleTitle || model.style == SIAlertActionStyleMessage) {
        self.title.font = [SIFont systemFontOfSize:16];
    }
    self.cornerLayer.fillColor = [SIColor whiteColor].CGColor;
    UIRectCorner style = 0;
    if (model.first) {
        style |= UIRectCornerTopLeft | UIRectCornerTopRight;
    }
    _line.hidden = YES;
    if (model.last) {
        style |= UIRectCornerBottomLeft | UIRectCornerBottomRight;
    } else {
        self.line.hidden = NO;
    }
    self.cornerLayer.cornerStyle = style;
    [self.contentView.layer insertSublayer:self.cornerLayer atIndex:0];
}

#pragma mark - Lazy Load

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.backgroundColor = [SIColor clearColor];
        _title.textColor = [SIColor colorWithHex:0x4a4a4a];
        _title.numberOfLines = 0;
        _title.minimumScaleFactor = 0.5;
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font = [SIFont systemFontOfSize:20];
        [self.contentView addSubview:_title];
    }
    return _title;
}

- (UIView *)line {
    if (!_line) {
        _line = [UIView new];
        [self.contentView addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).mas_offset(10);
            make.right.mas_equalTo(self.contentView).mas_offset(-10);
            make.bottom.mas_equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
        _line.backgroundColor = [SIColor colorWithHex:0xcacaca];
    }
    return _line;
}

@end
