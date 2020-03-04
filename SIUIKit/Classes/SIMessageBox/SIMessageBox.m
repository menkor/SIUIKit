//
//  SIMessageBox.m
//  SuperId
//
//  Created by Ye Tao on 2017/8/15.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "SIMessageBox.h"
#import <SITheme/SIColor.h>
#import <SITheme/SIFont.h>

@interface SIMessageBox () <UIGestureRecognizerDelegate, CAAnimationDelegate>

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) NSMutableDictionary *blockDict;

@property (nonatomic, strong) NSArray *buttonTitles;

@property (nonatomic, strong) UIVisualEffectView *containerView;

@property (nonatomic, strong) UIView<SIMessageBoxCustomProtocol> *messageView;

@property (nonatomic, copy) SIMessageBoxActionBlock allActionBlock;

@property (nonatomic, copy) SIMessageBoxCustomActionBlock customActionBlock;

@property (nonatomic, assign) BOOL buildin;

@property (nonatomic, assign) SIMessageBoxType type;

@property (nonatomic, strong) UIColor *lastButtonTitleColor;

@property (nonatomic, strong) UIScrollView *backgroudView;

@property (nonatomic, assign) BOOL locked;

@property (nonatomic, weak) UIView *fromView;

- (BOOL)isWaiting;

@end

#define Lock() dispatch_semaphore_wait(self->_lock, DISPATCH_TIME_FOREVER)
#define Unlock() dispatch_semaphore_signal(self->_lock)

@interface _SIMessageBoxQueue : NSObject

+ (instancetype)queue;

@end

@implementation _SIMessageBoxQueue {
    NSMutableArray *_queue;
    dispatch_semaphore_t _lock;
}

+ (instancetype)queue {
    static dispatch_once_t once = 0;
    static id instance = nil;

    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _queue = [NSMutableArray array];
        _lock = dispatch_semaphore_create(1);
    }
    return self;
}

- (BOOL)enqueue:(SIMessageBox *)box {
    Lock();
    for (SIMessageBox *some in [_queue copy]) {
        if (box.isWaiting && some.isWaiting) {
            [box hide];
            Unlock();
            return NO;
        }
        [some hide];
        [_queue removeObject:some];
    }
    [_queue addObject:box];
    Unlock();
    return YES;
}

- (void)dequeue {
    Lock();
    for (SIMessageBox *some in _queue) {
        [some hide];
    }
    [_queue removeAllObjects];
    Unlock();
}

@end

@implementation SIMessageBox

#pragma mark - Default Builder

+ (void)showMessage:(NSString *)message {
    SIMessageBox *box = [SIMessageBox boxWithType:SIMessageBoxStatusSuccess title:message message:nil];
    [box hideAfterDelay:1.5];
}

+ (void)showInfo:(NSString *)info {
    SIMessageBox *box = [SIMessageBox boxWithType:SIMessageBoxStatusInfo title:info message:nil];
    [box hideAfterDelay:1.5];
}

+ (void)showError:(NSString *)error {
    SIMessageBox *box = [SIMessageBox boxWithType:SIMessageBoxStatusError title:error message:nil];
    [box hideAfterDelay:1.5];
}

+ (void)showWarning:(NSString *)warning {
    SIMessageBox *box = [SIMessageBox boxWithType:SIMessageBoxStatusWarning title:warning message:nil];
    [box hideAfterDelay:1.5];
}

+ (void)showWaiting:(NSString *)waiting {
    [self showWaiting:waiting hideAfterDelay:20];
}

+ (void)showWaiting:(NSString *)waiting hideAfterDelay:(CGFloat)delay {
    SIMessageBox *box = [SIMessageBox boxWithType:SIMessageBoxStatusWaiting title:waiting message:nil];
    if (delay > 0) {
        [box hideAfterDelay:delay];
    } else {
        [box show];
    }
}

+ (void)hideWaiting {
    [[_SIMessageBoxQueue queue] dequeue];
}

+ (instancetype)boxWithType:(SIMessageBoxType)type title:(NSString *)title message:(NSString *)message {
    return [self boxWithType:type title:title message:message action:nil];
}

+ (instancetype)boxWithType:(SIMessageBoxType)type title:(NSString *)title message:(NSString *)message action:(SIMessageBoxActionBlock)actionBlock {
    SIMessageBox *box = [SIMessageBox createWithTitle:title message:message];
    box.type = type;
    SIMessageBoxType style = type & SIMessageBoxTypeMask;
    switch (style) {
        case SIMessageBoxTypeNone:
            box.buttonTitles = nil;
            break;
        case SIMessageBoxTypeOK:
            box.buttonTitles = @[kSIMessageBoxButtonOK];
            break;
        case SIMessageBoxTypeCancel:
            box.buttonTitles = @[kSIMessageBoxButtonCancel];
            break;
        case SIMessageBoxTypeBoth:
            box.buttonTitles = @[kSIMessageBoxButtonCancel, kSIMessageBoxButtonOK];
            break;
        default:
            break;
    }
    box.buildin = YES;
    [box setAllActionBlock:actionBlock];
    if ([[_SIMessageBoxQueue queue] enqueue:box]) {
        return box;
    }
    return nil;
}

- (void)setAllButtonActionBlock:(SIMessageBoxActionBlock)actionBlock {
    self.allActionBlock = [actionBlock copy];
}

- (BOOL)isWaiting {
    SIMessageBoxType status = self.type & SIMessageBoxStatusMask;
    return status == SIMessageBoxStatusWaiting;
}

#pragma mark - Initialize

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint touchPoint = [touch locationInView:self];
    BOOL touchInBackground = !CGRectContainsPoint(self.containerView.frame, touchPoint);
    if (touchInBackground && !self.isWaiting && !self.hold) {
        if (self.allActionBlock) {
            self.allActionBlock(SIMessageBoxButtonIndexCancel);
        }
        [self hide];
    }
    return NO;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        _messageAlignment = NSTextAlignmentCenter;
    }
    return self;
}

+ (instancetype)createWithTitle:(NSString *)title message:(NSString *)message {
    SIMessageBox *alertView = [[SIMessageBox alloc] init];
    alertView.frame = [UIScreen mainScreen].bounds;
    alertView.backgroundColor = [UIColor clearColor];
    alertView.title = title.length > 0 ? title : nil;
    alertView.message = message.length > 0 ? message : nil;
    alertView.animated = NO;
    return alertView;
}

#pragma mark - Subviews

- (UIView *)contentView {
    return self.containerView.contentView;
}

- (void)addContainerView {
    UIVisualEffectView *containerView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    NSNumber *boxWidth = self.theme[@"boxWidth"];
    containerView.frame = CGRectMake(0, 0, boxWidth ? boxWidth.floatValue : kSIMessageBoxWidth, 0);
    NSNumber *cornerRadius = self.theme[@"cornerRadius"];
    containerView.layer.cornerRadius = cornerRadius ? cornerRadius.floatValue : kSIMessageBoxRadius;
    containerView.layer.masksToBounds = YES;
    containerView.subviews[1].backgroundColor = self.theme[@"containerColor"] ?: [UIColor colorWithWhite:0 alpha:0.5];
    self.containerView = containerView;
    [self addSubview:containerView];
}

- (void)addIconView {
    SIMessageBoxType status = self.type & SIMessageBoxStatusMask;
    if (status == SIMessageBoxStatusNone || status == SIMessageBoxStatusInfo) {
        return;
    }
    CGRect frame = self.containerView.frame;
    frame.size.height += kSIMessageBoxIconHeight + kSIMessageBoxIconTop;

    if (status == SIMessageBoxStatusWaiting) {
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [view startAnimating];
        [self.contentView addSubview:view];
        if (self.title.length > 0) {
            CGFloat titleWidth = frame.size.width - kSIMessageBoxMessageXOffset * 2;
            CGSize titleSize = [self content:self.title font:kSIMessageBoxTitleFont fitWidth:titleWidth];
            frame.size.width = MAX(127, MIN(titleSize.width + kSIMessageBoxMessageXOffset * 2, titleWidth));
        }
        self.containerView.frame = frame;
        view.frame = CGRectMake((frame.size.width - 40) / 2, kSIMessageBoxIconTop, 40, 40);
        return;
    }
    self.containerView.frame = frame;
    CGSize iconSize = CGSizeMake(40, 40);
    CGFloat topOffset = kSIMessageBoxIconTop;
    UIImageView *icon = [[UIImageView alloc] init];
    if (status == SIMessageBoxStatusError) {
        icon.image = kSIMessageErrorIcon;
    } else if (status == SIMessageBoxStatusSuccess) {
        icon.image = kSIMessageSuccessIcon;
    } else if (status == SIMessageBoxStatusWarning) {
        icon.image = kSIMessageWarningIcon;
        frame.size.width = 130;
        topOffset = 30;
        self.containerView.frame = frame;
    }
    [self.contentView addSubview:icon];

    icon.frame = CGRectMake((frame.size.width - iconSize.width) / 2, topOffset, iconSize.width, iconSize.height);
}

- (CGSize)content:(NSString *)content font:(UIFont *)font fitWidth:(CGFloat)width {
    CGRect titleRect = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{
                                              NSFontAttributeName: font
                                          }
                                             context:nil];
    return titleRect.size;
}

- (void)addTitleView {
    if (self.title) {
        CGRect frame = self.containerView.frame;
        UIFont *titleFont = self.theme[@"titleFont"] ?: kSIMessageBoxTitleFont;
        CGFloat xOffset = kSIMessageBoxMessageXOffset;
        if (self.type == SIMessageBoxStatusWarning) {
            titleFont = [SIFont systemFontOfSize:12];
            xOffset = 12;
        }
        CGFloat titleWidth = frame.size.width - xOffset * 2;
        CGSize titleSize = [self content:self.title font:titleFont fitWidth:titleWidth];
        CGFloat titleYOffset = [self.theme[@"titleYOffset"] floatValue];
        UIEdgeInsets insets = [self.theme[@"insets"] UIEdgeInsetsValue];
        if (titleYOffset < 1) {
            titleYOffset = kSIMessageBoxTitleYOffset;
        }
        CGFloat titleHeight = titleSize.height + titleYOffset;
        frame.size.height += titleHeight;
        frame.size.height += insets.top;
        if (self.type == SIMessageBoxStatusInfo) {
            frame.size.width = MIN(titleSize.width + xOffset * 2, kSIMessageBoxWidth);
            titleWidth = frame.size.width - xOffset * 2;
        }
        if (self.type == SIMessageBoxStatusWarning) {
            frame.size.height = 130;
        }
        self.containerView.frame = frame;
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;

        titleLabel.text = self.title;
        if ((self.type & SIMessageBoxTypeMask) == SIMessageBoxTypeNone) {
            titleLabel.textColor = self.theme[@"titleColor"] ?: kSIMessageBoxMessageTextColor;
            titleLabel.frame = CGRectMake(xOffset,
                                          frame.size.height - titleHeight,
                                          titleWidth,
                                          titleHeight);
        } else {
            titleLabel.textColor = self.theme[@"titleColor"] ?: kSIMessageBoxMessageTextBlackColor;
            titleLabel.frame = CGRectMake(xOffset,
                                          frame.size.height - titleHeight + titleYOffset / 2,
                                          titleWidth,
                                          titleHeight);
        }
        [self.contentView addSubview:titleLabel];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = titleFont;
    }
}

- (void)addMessageLabelView {
    if (self.message) {
        CGRect frame = self.containerView.frame;
        UIFont *messageFont = self.theme[@"messageFont"] ?: kSIMessageBoxMessageFont;
        CGFloat messageWidth = frame.size.width - kSIMessageBoxMessageXOffset * 2;
        CGSize messageSize = [self content:self.message font:messageFont fitWidth:messageWidth];
        CGFloat messageHeight = messageSize.height;
        if (!self.title) {
            messageHeight += 50;
        }
        CGFloat messageYOffset = self.theme[@"messageYOffset"] ? [self.theme[@"messageYOffset"] floatValue] : kSIMessageBoxMessageYOffset;
        CGFloat offsetY = frame.size.height + messageYOffset;
        frame.size.height += messageHeight + messageYOffset + kSIMessageBoxMessageBottomOffset;
        UIEdgeInsets insets = [self.theme[@"insets"] UIEdgeInsetsValue];
        frame.size.height += insets.bottom;
        self.containerView.frame = frame;

        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.frame = CGRectMake(kSIMessageBoxMessageXOffset,
                                        offsetY,
                                        messageWidth,
                                        messageHeight);
        messageLabel.text = self.message;
        messageLabel.numberOfLines = 0;
        messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
        if ((self.type & SIMessageBoxTypeMask) == SIMessageBoxTypeNone) {
            messageLabel.textColor = self.theme[@"messageColor"] ?: kSIMessageBoxMessageTextColor;
        } else {
            messageLabel.textColor = self.theme[@"messageColor"] ?: kSIMessageBoxMessageTextBlackColor;
        }

        [self.contentView addSubview:messageLabel];
        messageLabel.font = messageFont;
        messageLabel.textAlignment = _messageAlignment;
    }
}

- (void)addCustomMessageView {
    CGFloat messageHeight = self.messageView.frame.size.height;
    CGFloat messageWidth = self.messageView.frame.size.width;
    CGRect frame = self.containerView.frame;
    frame.size.height += messageHeight;
    frame.size.width = messageWidth;
    self.containerView.frame = frame;
    CGRect messageFrame = self.messageView.frame;
    messageFrame.origin.x = (frame.size.width - messageWidth) / 2;
    messageFrame.origin.y = frame.size.height - messageHeight;
    self.messageView.frame = messageFrame;
    [self.contentView addSubview:self.messageView];
}

- (void)addLineView {
    CGRect frame = self.containerView.frame;
    frame.size.height += kSIMessageBoxLineHeight + kSIMessageBoxLineYOffset;
    self.containerView.frame = frame;
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(0, frame.size.height - kSIMessageBoxLineHeight, frame.size.width, kSIMessageBoxLineHeight);
    line.backgroundColor = kSIMessageBoxLineColor;
    [self.contentView addSubview:line];
}

- (void)addButtons {
    if ([self.buttonTitles count] <= 0) {
        return;
    }
    if (!self.lastButtonTitleColor) {
        self.lastButtonTitleColor = kSIMessageBoxLastButtonColor;
    }
    CGRect frame = self.containerView.frame;
    frame.size.height += kSIMessageBoxButtonHeight;
    self.containerView.frame = frame;
    NSArray *buttonTitles = self.buttonTitles;
    CGFloat buttonHeight = kSIMessageBoxButtonHeight;
    NSUInteger count = [buttonTitles count];
    CGFloat buttonWidth = frame.size.width / count;
    for (NSUInteger index = 0; index < count; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

        [button setFrame:CGRectMake(index * buttonWidth, frame.size.height - buttonHeight, buttonWidth, buttonHeight)];

        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:index];
        [button setTitle:buttonTitles[index] forState:UIControlStateNormal];
        if (index == count - 1) {
            [button setTitleColor:self.lastButtonTitleColor forState:UIControlStateNormal];
        } else {
            [button setTitleColor:kSIMessageBoxFirstButtonColor forState:UIControlStateNormal];
        }
        if (self.theme[@(index)]) {
            [button setTitleColor:self.theme[@(index)] forState:UIControlStateNormal];
        }
        [button setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
        [button.titleLabel setFont:kSIMessageBoxLastButtonFont];
        [self.contentView addSubview:button];
        if (index > 0) {
            UIView *line = [[UIView alloc] init];
            line.frame = CGRectMake(buttonWidth * index - kSIMessageBoxLineHeight / 2,
                                    frame.size.height - buttonHeight,
                                    kSIMessageBoxLineHeight,
                                    buttonHeight);
            line.backgroundColor = kSIMessageBoxLineColor;
            [self.contentView addSubview:line];
        }
    }
}

- (void)initSubviews {
    SIMessageBoxType status = self.type & SIMessageBoxStatusMask;
    if (status == SIMessageBoxStatusWaiting && !self.message && !self.title) {
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        view.color = [SIColor colorWithHex:0x4a4a4a];
        [view startAnimating];
        [self addSubview:view];
        view.frame = CGRectMake(0, 0, 40, 40);
        view.center = self.center;
        return;
    }
    [self addContainerView];
    SIMessageBoxType type = self.type & SIMessageBoxTypeMask;
    if (type == SIMessageBoxTypeNone) {
        [self addIconView];
    } else {
        self.contentView.backgroundColor = [SIColor whiteColor];
    }
    [self addTitleView];
    if (self.messageView) {
        [self addCustomMessageView];
    } else {
        [self addMessageLabelView];
    }
    if (type != SIMessageBoxTypeNone) {
        [self addLineView];
    }
    [self addButtons];
    self.containerView.center = self.center;
}

#pragma mark - Custom UI

- (NSUInteger)addButtonWithTitle:(NSString *)title {
    return [self addButtonWithTitle:title action:nil];
}

- (NSUInteger)addButtonWithTitle:(NSString *)title action:(SIMessageBoxActionBlock)actionBlock {
    if (self.blockDict == nil) {
        self.blockDict = [NSMutableDictionary dictionary];
    }
    //使用预置的api +[SIMessageBox boxWithType:title:message:]创建后,如果调用此方法,则清除所有预置的按钮
    if (self.buildin) {
        self.buttonTitles = nil;
        self.buildin = NO;
    }
    if (self.buttonTitles == nil) {
        self.buttonTitles = [NSArray array];
    }
    self.buttonTitles = [self.buttonTitles arrayByAddingObject:title];
    NSUInteger index = [self.buttonTitles count] - 1;
    if (actionBlock) {
        self.blockDict[@(index)] = [actionBlock copy];
    }
    return index;
}

#pragma mark - Action

- (void)buttonAction:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if (self.messageView &&
        self.customActionBlock &&
        [self.messageView respondsToSelector:@selector(messageBoxActionSelectedIndex)]) {
        NSUInteger actionIndex = [self.messageView messageBoxActionSelectedIndex];
        self.customActionBlock(tag, actionIndex);
    }
    if (self.allActionBlock) {
        self.allActionBlock(tag);
    } else {
        SIMessageBoxActionBlock block = self.blockDict[@(tag)];
        if (block) {
            block(tag);
        }
    }
    [self hide];
}

#pragma mark - Animation

- (void)animation {
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.delegate = self;
    if (self.visible) {
        popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    } else {
        popAnimation.values = @[
            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 1.0f)]
        ];
    }
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];

    [self.containerView.layer addAnimation:popAnimation forKey:nil];
    self.backgroundColor = [SIColor clearColor];
    [UIView animateWithDuration:0.4
                     animations:^{
                         if (self.visible) {
                             self.backgroundColor = self.coverColor;
                             if (self.onShowup) {
                                 self.onShowup(self.containerView);
                             }
                         } else {
                             self.backgroundColor = [SIColor clearColor];
                         }
                     }];
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
    if (!self.visible) {
        [self removeFromSuperview];
    }
}

#pragma mark - Visible

- (void)showFrom:(UIView *)view {
    self.fromView = view;
    [self show:self.animated];
}

- (void)show {
    [self show:self.animated];
}

- (void)show:(BOOL)animated {
    if (!self || self.locked) {
        return;
    }
    self.visible = YES;
    [self initSubviews];
    if (animated) {
        [self animation];
    } else {
        self.backgroundColor = self.coverColor;
        if (self.onShowup) {
            self.onShowup(self.containerView);
        }
    }
    UIView *superView = self.fromView ?: [UIApplication sharedApplication].keyWindow;
    self.backgroudView = [[UIScrollView alloc] initWithFrame:superView.bounds];
    [self.backgroudView addSubview:self];
    self.backgroudView.contentSize = superView.bounds.size;
    [superView addSubview:self.backgroudView];
    [superView bringSubviewToFront:self.backgroudView];
}

- (void)hideAfterDelay:(CFTimeInterval)delay {
    if (delay <= 0) {
        return;
    }
    if (!self.visible) {
        [self show];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hide];
    });
}

- (void)hide {
    [self hide:self.animated];
}

- (void)hide:(BOOL)animated {
    if (self.hold) {
        return;
    }
    self.locked = YES;
    self.visible = NO;
    [self.backgroudView removeFromSuperview];
    [self removeFromSuperview];
}

#pragma mark - Custom Message View

- (void)setCustomMessageView:(UIView<SIMessageBoxCustomProtocol> *)view {
    self.messageView = view;
    self.message = nil;
}

@end
