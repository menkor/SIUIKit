//
//  SIRefreshHeader.m
//
//  Created by Ye Tao on 2017/3/3.
//
//

#import "SIRefreshHeader.h"
#import "SIProgressView.h"
#import "SIColor.h"
#import "SIFont.h"
#import <Masonry/Masonry.h>

@interface SIRefreshHeader ()
//样式
@property (nonatomic, assign) SIRefreshHeaderStyle style;
//下拉结果状态.成功,失败,初始
@property (nonatomic, assign) HTRefreshResultState resultState;
//显示文本
@property (nonatomic, weak) UILabel *statusLabel;
//图片
@property (nonatomic, weak) UIImageView *logo;
//进度
@property (nonatomic, weak) SIProgressView *progressView;
//超时定时器
@property (nonatomic, weak) NSTimer *timeoutTimer;
//超时,默认3秒
@property (nonatomic, assign) NSTimeInterval timeout;
//最小刷新时间定时器
@property (nonatomic, weak) NSTimer *minPullingTimer;
//最小刷新时间定时器
@property (nonatomic, assign) NSTimeInterval minPullingTimeInterval;

@property (nonatomic, strong) NSDate *lastPullingTime;

@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation SIRefreshHeader

+ (instancetype)headerWithStyle:(SIRefreshHeaderStyle)style refreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    SIRefreshHeader *cmp = [self headerWithRefreshingBlock:refreshingBlock];
    cmp.style = style;
    return cmp;
}

- (void)prepare {
    [super prepare];
    // 设置控件的高度
    self.mj_h = 80;
    self.timeout = 3;
    UILabel *label = [[UILabel alloc] init];
    label.font = [SIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.statusLabel = label;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(9);
        make.height.mas_equalTo(12);
        make.right.left.mas_equalTo(self);
    }];

    SIProgressView *progressView = [[SIProgressView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [self addSubview:progressView];
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    self.progressView = progressView;
    [progressView setTrackColor:[UIColor clearColor]];
    [progressView setStartAngle:M_PI_2];

    UIImageView *logo = [[UIImageView alloc] init];
    [self addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(progressView.mas_top).offset(6);
    }];
    self.logo = logo;
    self.lastPullingTime = [NSDate date];
}

#pragma mark - Animation

- (void)animation {
    [self.progressView setStartAngle:kSIRefreshAnimationStartAngle];
    [self.progressView setProgress:(1 - 60 / 360.0)];
    [self rotateView:self.progressView];
}

- (void)rotateView:(UIView *)view {
    [UIView animateWithDuration:0.25
        delay:0
        options:UIViewAnimationOptionCurveLinear
        animations:^{
            CGAffineTransform transfrom = view.layer.affineTransform;
            view.layer.affineTransform = CGAffineTransformRotate(transfrom, M_PI_2);
        }
        completion:^(BOOL finished) {
            if (finished) {
                [self rotateView:view];
            }
        }];
}

- (void)resetProgressView {
    if (self.state != MJRefreshStateRefreshing) {
        return;
    }

    [CATransaction begin];
    [self.progressView.layer removeAllAnimations];
    [CATransaction commit];
    self.progressView.layer.affineTransform = CGAffineTransformIdentity;
    [self.progressView setStartAngle:M_PI_2];
    [self.progressView setProgress:1];
}

#pragma mark - Subviews
- (void)placeSubviews {
    [super placeSubviews];
    UIColor *themeColor = kSIRefreshHeaderColorDict[@(self.style)];
    UIImage *icon = kSIRefreshHeaderIconDict[@(self.style)];
    self.logo.image = icon;
    self.statusLabel.textColor = themeColor;
    [self.progressView setTrackColor:[UIColor clearColor]];
    [self.progressView setProgressColor:themeColor];
}

#pragma mark - Finish or Fail

- (void)finish {
    if (self.state == MJRefreshStateIdle) {
        return;
    }
    NSTimeInterval timeInterval = kSIRefreshMinPullingTimeInterval - self.minPullingTimeInterval;
    if (timeInterval > 0) {
        [self.minPullingTimer invalidate];
        self.minPullingTimer = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.resultState = HTRefreshResultStateSuccess;
            [self resetState];
        });
    } else {
        self.resultState = HTRefreshResultStateSuccess;
        [self resetState];
    }
}

- (void)fail {
    self.resultState = HTRefreshResultStateError;
    [self resetState];
}

#pragma mark -Timer

- (void)setupTimeOutTimer {
    if (self.timeoutTimer.isValid) {
        [self.timeoutTimer invalidate];
        self.timeoutTimer = nil;
    }
    self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeout
                                                         target:self
                                                       selector:@selector(fail)
                                                       userInfo:nil
                                                        repeats:NO];
}

- (void)setupMinPullingTimer {
    if (self.minPullingTimer.isValid) {
        [self.minPullingTimer invalidate];
        self.minPullingTimer = nil;
    }
    self.minPullingTimeInterval = 0;
    self.minPullingTimer = [NSTimer scheduledTimerWithTimeInterval:kSIRefreshTimerFireTimeInterval
                                                            target:self
                                                          selector:@selector(handleMinPullingTimer:)
                                                          userInfo:nil
                                                           repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.minPullingTimer forMode:NSRunLoopCommonModes];
}

- (void)handleMinPullingTimer:(NSTimer *)sender {
    self.minPullingTimeInterval += kSIRefreshTimerFireTimeInterval;
    if (self.minPullingTimeInterval >= kSIRefreshMinPullingTimeInterval) {
        [sender invalidate];
        sender = nil;
    }
}

#pragma mark - State

- (void)setResultState:(HTRefreshResultState)resultState {
    _resultState = resultState;
    [self updateWithResultState];
}

/*!
 *  @brief 根据完成状态,更新提示信息.
 */
- (void)updateWithResultState {
    if (self.state != MJRefreshStateRefreshing) {
        return;
    }
    switch (self.resultState) {
        case HTRefreshResultStateError:
            self.statusLabel.text = [self stateText:kSIRefreshHeaderTitleError];
            break;
        case HTRefreshResultStateSuccess:
            self.statusLabel.text = [self stateText:kSIRefreshHeaderTitleSuccess];
            break;
        default:
            break;
    }
}

/*!
 *  @brief 设置state为MJRefreshStateIdle
 */
- (void)resetState {
    [self resetProgressView];
    __weak typeof(self) weak_self = self;
    [self endRefreshingWithCompletionBlock:^{
        //设置完成状态为HTRefreshResultStateOrigin,此时会允许设置其他的提示信息
        weak_self.resultState = HTRefreshResultStateOrigin;
        //恢复初始状态
        [weak_self setState:MJRefreshStateIdle];
    }];
}

/*!
 *  @brief 设置各个状态下显示的提示信息
 *  @param state 当前状态
 */
- (void)setState:(MJRefreshState)state {
    [super setState:state];
    switch (self.state) {
        case MJRefreshStateIdle: {
            /*!
         *  @brief 只有在HTRefreshResultStateOrigin的完成状态下,才更新提示信息
         *  这样做是保证下拉完成时到下拉列表隐藏,显示的提示信息都是完成状态[刷新完成/失败]的提示
         */
            if (self.resultState == HTRefreshResultStateOrigin) {
                self.statusLabel.text = [self stateText:kSIRefreshHeaderTitleIdle];
            }
        } break;
        case MJRefreshStatePulling: {
            self.statusLabel.text = [self stateText:kSIRefreshHeaderTitlePulling];
        }

        break;
        case MJRefreshStateRefreshing: {
            self.statusLabel.text = [self stateText:kSIRefreshHeaderTitleRefreshing];
            self.lastPullingTime = [NSDate date];
            [self setupTimeOutTimer];
            [self setupMinPullingTimer];
            [self animation];
        } break;
        default:
            break;
    }
}

/*!
 *  @brief 自定义显示的提示信息,添加[上次更新]的时间
 */
- (NSString *)stateText:(NSString *)string {
    if (!kSIRefreshHeaderTitleAppendDate) {
        return string;
    }
    NSString *lastUpdatedTimeString = [self.formatter stringFromDate:[self lastPullingTime]];
    return [string stringByAppendingFormat:kSIRefreshHeaderTitleFormat, lastUpdatedTimeString];
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = kSIRefreshHeaderDateFormat;
    }
    return _formatter;
}

#pragma mark - Pulling Percent
- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    /*!
     *  @brief 延迟30%出现.体现递增/减过程
     */
    if (pullingPercent >= 0 && pullingPercent <= 1.2) {
        pullingPercent = pullingPercent - 0.2;
    }
    if (pullingPercent > 1) {
        pullingPercent = 1;
    }
    [self.progressView setProgress:pullingPercent < 0 ? 0 : pullingPercent];
}

@end
