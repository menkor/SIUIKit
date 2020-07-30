//
//  SINavigationBar.m
//  SuperId
//
//  Created by Ye Tao on 2017/7/24.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "SINavigationBar.h"
#import <Masonry/Masonry.h>
#import <SIDefine/SIGlobalMacro.h>
#import <SITheme/SIColor.h>
#import <SITheme/SIFont.h>

@interface SINavigationBar ()

//lazy load property
@property (nonatomic, strong) NSMutableDictionary *itemDict;
//lazy load property
@property (nonatomic, strong) NSMutableDictionary *actionBlockDict;
//lazy load property
@property (nonatomic, strong) NSMutableDictionary *itemParamDict;

@property (nonatomic, assign) SINavigationItemPosition position;

@property (nonatomic, assign) SINavigationItemOperation operation;

@property (nonatomic, assign) SINavigationTheme navigationTheme;

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIColor *themeColor;

@property (nonatomic, strong) UIColor *textColor;

@end

@implementation SINavigationBar

#pragma mark - Life Cycle

+ (instancetype)create {
    SINavigationBar *bar = [[self alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTopHeight)];
    return bar;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _visible = YES;
        [self setTheme:SINavigationThemeWhite];
        self.hideNavigationBarLine = NO;
        [self sendSubviewToBack:self.contentView];
    }
    return self;
}

- (void)setHideNavigationBarLine:(BOOL)hideNavigationBarLine {
    _hideNavigationBarLine = hideNavigationBarLine;
    self.bottomLine.hidden = hideNavigationBarLine;
}

#pragma mark - Lazy Load

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.height.mas_equalTo(kSINavigationItemHeight);
        }];
    }
    return _contentView;
}

- (NSMutableDictionary *)itemDict {
    if (!_itemDict) {
        _itemDict = [NSMutableDictionary dictionary];
    }
    return _itemDict;
}

- (NSMutableDictionary *)actionBlockDict {
    if (!_actionBlockDict) {
        _actionBlockDict = [NSMutableDictionary dictionary];
    }
    return _actionBlockDict;
}

- (NSMutableDictionary *)itemParamDict {
    if (!_itemParamDict) {
        _itemParamDict = [NSMutableDictionary dictionary];
    }
    return _itemParamDict;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        [self addSubview:_bottomLine];
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        _bottomLine.backgroundColor = [SIColor colorWithWhite:0 alpha:0.3];
    }
    return _bottomLine;
}

- (void)dealloc {
}

#pragma mark - Theme

- (void)setTheme:(SINavigationTheme)theme {
    self.navigationTheme = theme;
    UIColor *color = kThemeColorDict[@(theme)];
    [self setThemeColor:color];
}

- (void)setThemeColor:(UIColor *)themeColor {
    _themeColor = themeColor;
    self.backgroundColor = themeColor;
}

#pragma mark - Convenient

- (UIView *)item {
    if (self.position != SINavigationItemPositionError) {
        NSArray *itemArray = self.itemDict[@(self.position)];
        return itemArray.firstObject;
    }
    return nil;
}

- (NSArray<UIView *> *)itemArray {
    if (self.position != SINavigationItemPositionError) {
        NSArray *itemArray = self.itemDict[@(self.position)];
        return itemArray;
    }
    return nil;
}

- (UIButton *)button {
    UIView *someView = [self item];
    if ([someView isKindOfClass:[UIButton class]]) {
        return (UIButton *)someView;
    }
    return nil;
}

#pragma mark - Action

- (void)action:(UIButton *)sender {
    NSString *key = [NSString stringWithFormat:@"%p", sender];
    SINavigationBarActionBlock block = self.actionBlockDict[key];
    if (block) {
        block(sender);
    } else {
        if (self.itemParamDict[key]) {
            return;
        }
    }
}

#pragma mark - Position

- (SINavigationBar *)left {
    self.position = SINavigationItemPositionLeft;
    return self;
}

- (SINavigationBar *)title {
    self.position = SINavigationItemPositionTitle;
    return self;
}

- (SINavigationBar *)right {
    self.position = SINavigationItemPositionRight;
    return self;
}

- (SINavigationBar *)add {
    self.operation = SINavigationItemOperationAdd;
    return self;
}

#pragma mark - Buildin UI

- (id)itemWithType:(SINavigationItemType)type {
    return [self itemWithType:type action:nil];
}

- (id)itemWithParam:(NSDictionary *)param selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSelector:selector toButton:button];
    [self customButton:button param:param];
    [self addItem:^NSArray<UIView *> * {
        return @[button];
    }];
    return button;
}

- (NSDictionary *)configForType:(SINavigationItemType)type {
    return [self configForKey:[NSString stringWithFormat:@"%@", @(type)]];
}

- (NSDictionary *)configForKey:(id)key {
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:NSClassFromString(@"SINavigationBar")] pathForResource:@"SIComponents" ofType:@"bundle"]];
    NSString *path = [bundle pathForResource:@"SINavigationAdaptor" ofType:@"plist"];
    NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *dict = config[key];
    return dict;
}

- (UIButton *)itemWithType:(SINavigationItemTypeCustom)type
                  resource:(NSString *)resource
                    action:(SINavigationBarActionBlock)actionBlock {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    switch (type) {
        case SINavigationItemTypeCustomText:
            [self customButton:button title:resource image:nil background:nil];
            break;

        case SINavigationItemTypeCustomImage:
            [self customButton:button title:nil image:resource background:nil];
            break;
        default:
            break;
    }

    [button addTarget:self
                  action:@selector(action:)
        forControlEvents:UIControlEventTouchUpInside];
    [self addItem:^NSArray<UIView *> * {
        return @[button];
    }];
    return button;
}

- (void)addSelector:(SEL)selector toButton:(UIButton *)button {
    if (self.owner && [button isKindOfClass:[UIButton class]]) {
        [button addTarget:self.owner action:selector forControlEvents:UIControlEventTouchUpInside];
        NSString *key = [NSString stringWithFormat:@"%p", button];
        self.itemParamDict[key] = NSStringFromSelector(selector);
    } else {
#ifdef DEBUG
        NSString *errMessage = [NSString stringWithFormat:@"%@未加入父视图", NSStringFromClass([self class])];
        NSAssert(NO, errMessage);
#endif
    }
}

- (UIButton *)itemWithType:(SINavigationItemTypeCustom)type
                  resource:(NSString *)resource
                  selector:(SEL)selector {
    UIButton *button = [self itemWithType:type resource:resource action:nil];
    [self addSelector:selector toButton:button];
    return button;
}

- (UIButton *)itemWithType:(SINavigationItemType)type selector:(SEL)selector {
    UIButton *button = [self itemWithType:type action:nil];
    [self addSelector:selector toButton:button];
    return button;
}

- (UIButton *)itemWithIcon:(NSString *)icon selector:(SEL)selector {
    return [self itemWithType:SINavigationItemTypeCustomImage resource:icon selector:selector];
}

- (UIButton *)itemWithTitle:(NSString *)title selector:(SEL)selector {
    return [self itemWithType:SINavigationItemTypeCustomText resource:title selector:selector];
}

- (UIButton *)itemWithType:(SINavigationItemType)type
                    action:(SINavigationBarActionBlock)actionBlock {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self customButton:button type:type];
    [button addTarget:self
                  action:@selector(action:)
        forControlEvents:UIControlEventTouchUpInside];

    [self addItem:^NSArray<UIView *> * {
        return @[button];
    }];
    return button;
}

- (void)customButton:(UIButton *)button type:(SINavigationItemType)type {
    NSDictionary *dict = [self configForType:type];
    [self customButton:button param:dict];
}

- (void)customButtonWithParam:(NSDictionary *)param {
    if (param && self.button) {
        UIButton *button = self.button;
        NSString *title = param[kSINavigationConfigKeyTitle];
        NSString *imageName = param[kSINavigationConfigKeyImage];
        NSString *background = param[kSINavigationConfigKeyBackgroundImage];
        NSString *tag = param[kSINavigationConfigKeyTag];
        if ([tag length] > 0) {
            button.tag = [tag integerValue];
        }
        [self customButton:button title:title image:imageName background:background];
    }
}

- (void)customButton:(UIButton *)button param:(NSDictionary *)param {
    if (param) {
        NSString *title = param[kSINavigationConfigKeyTitle];
        NSString *imageName = param[kSINavigationConfigKeyImage];
        NSString *background = param[kSINavigationConfigKeyBackgroundImage];
        NSString *tag = param[kSINavigationConfigKeyTag];
        if ([tag length] > 0) {
            button.tag = [tag integerValue];
        }
        [self customButton:button title:title image:imageName background:background];
    }
}

- (void)resetButton:(UIButton *)button {
    [button setTitle:nil forState:UIControlStateNormal];
    [button setImage:nil forState:UIControlStateNormal];
    [button setBackgroundImage:nil forState:UIControlStateNormal];
}

- (void)customButton:(UIButton *)button title:(NSString *)title image:(NSString *)imageName background:(NSString *)backgroundImageName {
    [self resetButton:button];
    if ([backgroundImageName length] > 0) {
        [button setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal];
    }

    if (title && [title length] > 0) {
        CGFloat width = [title sizeWithAttributes:@{NSFontAttributeName: kThemeFontDefault}].width;
        CGRect frame = button.frame;
        /*!
         *  @brief 宽度增加 kSINavigationButtonYOffset * 2,增大按钮的响应范围
         */
        frame.size = CGSizeMake(width + kSINavigationButtonYOffset * 2, kSINavigationItemHeight);
        if (backgroundImageName) {
            frame.size.width = frame.size.width + 24;
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 12 + 8, 0, 0)];
        } else {
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        button.frame = frame;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:self.textColor ?: [SIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = kThemeFontDefault;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.minimumScaleFactor = 0.5;
    } else if (imageName) {
        UIImage *image = [UIImage imageNamed:imageName];
        if (!image) {
            return;
        }
        CGFloat scale = image.size.height / kSINavigationItemHeight;
        CGRect frame = button.frame;
        frame.size = CGSizeMake(image.size.width / scale, kSINavigationItemHeight);
        button.frame = frame;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [button setImage:image forState:UIControlStateNormal];
    } else if ([backgroundImageName length] > 0) {
        UIImage *image = [UIImage imageNamed:backgroundImageName];
        if (!image) {
            return;
        }
        CGRect frame = button.frame;
        frame.size = CGSizeMake(image.size.width, image.size.height);
        button.frame = frame;
    }
}

- (UILabel *)titleItem:(NSString *)title {
    UILabel *item = (UILabel *)self.title.item;
    if (!item || ![item isKindOfClass:[UILabel class]]) {
        item = [self defaultTitle];
        [self addItem:^NSArray<UIView *> * {
            return @[item];
        }];
    }
    item.text = title;
    return item;
}

- (UILabel *)attributedTitleItem:(NSAttributedString *)title {
    UILabel *item = (UILabel *)self.title.item;
    if (!item || ![item isKindOfClass:[UILabel class]]) {
        item = [self defaultTitle];
        [self addItem:^NSArray<UIView *> * {
            return @[item];
        }];
    }
    item.attributedText = title;
    return item;
}

- (UILabel *)defaultTitle {
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 21)];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.adjustsFontSizeToFitWidth = YES;
    title.textColor = [SIColor colorWithHex:0x4a4a4a];
    [title setFont:kThemeFontTitle];
    return title;
}

#pragma mark - Custom UI

- (UIView *)addItem:(SINavigationBarAddItem)itemBlock {
    if (self.position == SINavigationItemPositionError) {
        return nil;
    }
    self.operation = SINavigationItemOperationAdd;
    return [self addItem:itemBlock action:nil];
}

- (void)adjustPosition:(NSArray<UIView *> *)itemArray {
    if (!itemArray) {
        return;
    }
    if (itemArray.count == 1) {
        UIView *item = itemArray.firstObject;
        switch (self.position) {
            case SINavigationItemPositionLeft: {
                [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.mas_left).inset(8);
                    make.centerY.mas_equalTo(self.contentView.mas_centerY);
                    make.size.mas_equalTo(item.frame.size);
                }];
            } break;

            case SINavigationItemPositionTitle: {
                [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(self.mas_centerX);
                    make.centerY.mas_equalTo(self.contentView.mas_centerY);
                    make.size.mas_equalTo(item.frame.size);
                }];
            } break;

            case SINavigationItemPositionRight: {
                [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self.mas_right).inset(8);
                    make.centerY.mas_equalTo(self.contentView.mas_centerY);
                    make.size.mas_equalTo(item.frame.size);
                }];
            } break;
            default:
                NSAssert(self.position == SINavigationItemPositionError, @"请先调用left/center/right方法");
                break;
        }
        return;
    } else {
        switch (self.position) {
            case SINavigationItemPositionLeft: {
                __block UIView *pre = nil;
                [itemArray enumerateObjectsUsingBlock:^(UIView *_Nonnull item, NSUInteger idx, BOOL *_Nonnull stop) {
                    if (idx == 0) {
                        [item mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(self).inset(8);
                            make.centerY.mas_equalTo(self.contentView.mas_centerY);
                            make.size.mas_equalTo(item.frame.size);
                        }];
                    } else {
                        [item mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(pre.mas_right);
                            make.centerY.mas_equalTo(self.contentView.mas_centerY);
                            make.size.mas_equalTo(item.frame.size);
                        }];
                    }
                    pre = item;
                }];
            } break;
            case SINavigationItemPositionRight: {
                __block UIView *pre = nil;
                [itemArray enumerateObjectsUsingBlock:^(UIView *_Nonnull item, NSUInteger idx, BOOL *_Nonnull stop) {
                    if (idx == 0) {
                        [item mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.mas_equalTo(self.mas_right).inset(8);
                            make.centerY.mas_equalTo(self.contentView.mas_centerY);
                            make.size.mas_equalTo(item.frame.size);
                        }];
                    } else {
                        [item mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.mas_equalTo(pre.mas_left).inset(8);
                            make.centerY.mas_equalTo(self.contentView.mas_centerY);
                            make.size.mas_equalTo(item.frame.size);
                        }];
                    }
                    pre = item;
                }];
            } break;
            default:
                NSAssert(self.position == SINavigationItemPositionError, @"请先调用left/center/right方法");
                break;
        }
    }
}

- (UIView *)addItem:(SINavigationBarAddItem)itemBlock action:(SINavigationBarActionBlock)actionBlock {
    [self remove]; //remove staff of old guy
    if (!itemBlock) {
        return nil;
    }
    NSArray<UIView *> *itemArray = itemBlock();
    if ([itemArray isKindOfClass:[UIView class]]) {
        itemArray = @[(UIView *)itemArray];
    }
    if (!itemArray) {
        return nil;
    }
    if (itemArray.count == 1) {
        UIView *item = itemArray.firstObject;
        //add staff of new guy
        if (actionBlock) {
            NSString *key = [NSString stringWithFormat:@"%p", item];
            self.actionBlockDict[key] = actionBlock;
            self.itemParamDict[key] = @(YES);
        }
        self.itemDict[@(self.position)] = @[item];
        [self.contentView addSubview:item];
        [self adjustPosition:@[item]];
        self.position = SINavigationItemPositionError;
        self.operation = SINavigationItemOperationNone;
        return item;
    } else {
        [itemArray enumerateObjectsUsingBlock:^(UIView *_Nonnull item, NSUInteger idx, BOOL *_Nonnull stop) {
            if (actionBlock) {
                NSString *key = [NSString stringWithFormat:@"%p", item];
                self.actionBlockDict[key] = actionBlock;
                self.itemParamDict[key] = @(YES);
            }
            [self.contentView addSubview:item];
        }];
        self.itemDict[@(self.position)] = itemArray;
        [self adjustPosition:itemArray];
        self.position = SINavigationItemPositionError;
        self.operation = SINavigationItemOperationNone;
    }

    return nil;
}

- (void)remove {
    NSArray *itemArray = self.itemDict[@(self.position)];
    if ([itemArray isKindOfClass:[NSArray class]]) {
        [itemArray enumerateObjectsUsingBlock:^(UIView *item, NSUInteger idx, BOOL *_Nonnull stop) {
            [self removeItem:item];
        }];
        [self.itemDict removeObjectForKey:@(self.position)];
    }
}

- (void)removeItem:(UIView *)item {
    [item removeFromSuperview];
    NSString *key = [NSString stringWithFormat:@"%p", item];
    [self.actionBlockDict removeObjectForKey:key];
    [self.itemParamDict removeObjectForKey:key];
}

@end
