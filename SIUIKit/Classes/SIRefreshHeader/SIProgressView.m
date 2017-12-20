//
//  SIProgressView.m
//
//  Created by Ye Tao on 2017/3/3.
//
//

#import "SIProgressView.h"

@interface SIProgressView ()
@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic) CGFloat progress; //0~1之间的数
@property (nonatomic, strong) CAShapeLayer *trackLayer;
@property (nonatomic, strong) UIBezierPath *trackPath;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) UIBezierPath *progressPath;
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) BOOL clockwise;
@end

@implementation SIProgressView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _trackLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_trackLayer];
        _trackLayer.fillColor = nil;
        _trackLayer.frame = self.bounds;
        _progressLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_progressLayer];
        _progressLayer.fillColor = nil;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.frame = self.bounds;
        self.progressWidth = 1;
        self.trackWidth = 1;
        self.startAngle = 0;
        self.clockwise = YES;
    }
    return self;
}

- (void)setTrack {
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGFloat radius = (self.bounds.size.width - _trackWidth) / 2;
    _trackPath = [UIBezierPath bezierPathWithArcCenter:center
                                                radius:radius
                                            startAngle:self.startAngle
                                              endAngle:M_PI * 2
                                             clockwise:self.clockwise];
    _trackLayer.path = _trackPath.CGPath;
}

- (void)setProgress {
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGFloat radius = (self.bounds.size.width - _progressWidth) / 2;
    _progressPath = [UIBezierPath bezierPathWithArcCenter:center
                                                   radius:radius
                                               startAngle:self.startAngle
                                                 endAngle:self.startAngle + (M_PI * 2) * _progress
                                                clockwise:self.clockwise];
    _progressLayer.path = _progressPath.CGPath;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return nil;
}

- (void)setProgressWidth:(CGFloat)progressWidth {
    _progressWidth = progressWidth;
    _trackLayer.lineWidth = _trackWidth;
    _progressLayer.lineWidth = _progressWidth;
    [self setTrack];
    [self setProgress];
}

- (void)setTrackColor:(UIColor *)trackColor {
    _trackLayer.strokeColor = trackColor.CGColor;
}

- (void)setProgressColor:(UIColor *)progressColor {
    _progressLayer.strokeColor = progressColor.CGColor;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setProgress];
}

@end
