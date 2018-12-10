//
//  SINavigationBar.m
//  SuperId
//
//  Created by Ye Tao on 2017/7/24.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "SINavigationBar.h"
#import <Masonry/Masonry.h>
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

@property (nonatomic, strong) UIColor *themeColor;

@property (nonatomic, strong) UIColor *textColor;

@end

@implementation SINavigationBar

#pragma mark - Life Cycle

+ (instancetype)create {
    SINavigationBar *bar = [[self alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    return bar;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _visible = YES;
        [self setTheme:SINavigationThemeWhite];
        _topBaseline = kSINavigationItemYOffset;
        self.hideNavigationBarLine = NO;
    }
    return self;
}

- (void)setHideNavigationBarLine:(BOOL)hideNavigationBarLine {
    _hideNavigationBarLine = hideNavigationBarLine;
    self.bottomLine.hidden = hideNavigationBarLine;
}

#pragma mark - Lazy Load

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
        UIView *view = self.itemDict[@(self.position)];
        return view;
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
    self.operation = SINavigationItemPositionAdd;
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

- (void)setTopBaseline:(CGFloat)topBaseline {
    if (topBaseline == _topBaseline) {
        return;
    }
    _topBaseline = topBaseline;
    [self.itemDict enumerateKeysAndObjectsUsingBlock:^(NSNumber *_Nonnull key, UIView *_Nonnull obj, BOOL *_Nonnull stop) {
        self.position = key.integerValue;
        [self adjustPosition:obj];
    }];
    self.position = SINavigationItemPositionError;
}

#pragma mark - Custom UI

- (UIView *)addItem:(SINavigationBarAddItem)itemBlock {
    if (self.operation == SINavigationItemPositionAdd) {
        return [self addItem:itemBlock action:nil];
    }
    return nil;
}

- (void)adjustPosition:(UIView *)newItem {
    if (!newItem) {
        return;
    }
    switch (self.position) {
        case SINavigationItemPositionLeft: {
            [newItem mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.mas_left).inset(8);
                make.centerY.mas_equalTo(self.mas_centerY).offset(_topBaseline / 2);
                make.size.mas_equalTo(newItem.frame.size);
            }];
        } break;

        case SINavigationItemPositionTitle: {
            [newItem mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.mas_centerX);
                make.centerY.mas_equalTo(self.mas_centerY).offset(_topBaseline / 2);
                make.size.mas_equalTo(newItem.frame.size);
            }];
        } break;

        case SINavigationItemPositionRight: {
            [newItem mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.mas_right).inset(8);
                make.centerY.mas_equalTo(self.mas_centerY).offset(_topBaseline / 2);
                make.size.mas_equalTo(newItem.frame.size);
            }];
        } break;
        default:
            NSAssert(self.position == SINavigationItemPositionError, @"请先调用left/center/right方法");
            break;
    }
}

- (UIView *)addItem:(SINavigationBarAddItem)itemBlock action:(SINavigationBarActionBlock)actionBlock {
    [self remove]; //remove staff of old guy
    if (!itemBlock) {
        return nil;
    }
    NSArray<UIView *> *newItemArray = nil;
    newItemArray = itemBlock();
    if (!newItemArray) {
        return nil;
    }
    if (newItemArray.count == 1) {
        UIView *newItem = newItemArray.firstObject;
        //add staff of new guy
        if (actionBlock) {
            NSString *key = [NSString stringWithFormat:@"%p", newItem];
            self.actionBlockDict[key] = actionBlock;
            self.itemParamDict[key] = @(YES);
        }
        self.itemDict[@(self.position)] = newItem;
        [self addSubview:newItem];
        [self adjustPosition:newItem];
        self.position = SINavigationItemPositionError;
        return newItem;
    } else {
        __block UIView *pre = nil;
        [newItemArray enumerateObjectsUsingBlock:^(UIView *_Nonnull newItem, NSUInteger idx, BOOL *_Nonnull stop) {
            if (actionBlock) {
                NSString *key = [NSString stringWithFormat:@"%p", newItem];
                self.actionBlockDict[key] = actionBlock;
                self.itemParamDict[key] = @(YES);
            }
            [self addSubview:newItem];
            if (idx == 0) {
                self.itemDict[@(self.position)] = newItem;
                [newItem mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self.mas_right).inset(8);
                    make.centerY.mas_equalTo(self.mas_centerY).offset(_topBaseline / 2);
                    make.size.mas_equalTo(newItem.frame.size);
                }];
            } else {
                [newItem mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(pre.mas_left);
                    make.centerY.mas_equalTo(self.mas_centerY).offset(_topBaseline / 2);
                    make.size.mas_equalTo(newItem.frame.size);
                }];
            }
            pre = newItem;
        }];
        self.position = SINavigationItemPositionError;
    }
    return nil;
}

- (void)remove {
    UIView *item = self.item;
    if (item) {
        [item removeFromSuperview];
        [self.itemDict removeObjectForKey:@(self.position)];
        NSString *key = [NSString stringWithFormat:@"%p", item];
        [self.actionBlockDict removeObjectForKey:key];
        [self.itemParamDict removeObjectForKey:key];
    }
}

@end
