//
//  SIArrowView.m
//  SuperId
//
//  Created by Ye Tao on 2017/2/23.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "SIArrowView.h"

@interface SIArrowView ()

@property (nonatomic, assign) SIArrowViewStyle style;

@property (nonatomic, assign) SIArrowViewStyle direction;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, strong) CAShapeLayer *arrowLayer;

@end

@implementation SIArrowView

+ (instancetype)arrowWithFrame:(CGRect)frame
                         style:(SIArrowViewStyle)style
                         color:(UIColor *)color {
    SIArrowView *arrow = [[SIArrowView alloc] initWithFrame:frame];
    arrow.style = style;
    arrow.color = color;
    arrow.backgroundColor = [UIColor clearColor];
    [arrow reload];
    return arrow;
}

- (void)reload {
    CGSize size = self.frame.size;
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (self.style & SIArrowViewStyleTriangle) {
        [path moveToPoint:CGPointZero];
        [path addLineToPoint:CGPointMake(size.width, 0)];
        [path addLineToPoint:CGPointMake(size.width / 2, size.height)];
        [path addLineToPoint:CGPointZero];
        self.arrowLayer.fillColor = self.color.CGColor;
        self.arrowLayer.strokeColor = nil;
    } else if (self.style & SIArrowViewStyleArrow) {
        [path moveToPoint:CGPointZero];
        [path addLineToPoint:CGPointMake(size.width / 2, size.height)];
        [path addLineToPoint:CGPointMake(size.width, 0)];
        self.arrowLayer.strokeColor = self.color.CGColor;
        self.arrowLayer.fillColor = nil;
        self.arrowLayer.lineWidth = 1;
    } else {
        NSAssert(NO, @"Unkown style");
    }

    self.arrowLayer.frame = self.bounds;
    self.arrowLayer.path = path.CGPath;
    self.direction = SIArrowViewDirectionDown;
    [self updateDirection:self.style & SIArrowViewDirectionMask animated:NO];
}

- (void)updateDirection:(SIArrowViewStyle)direction animated:(BOOL)animated {
    if (direction == self.direction) {
        return;
    }
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (direction) {
        case SIArrowViewDirectionUp: {
            transform = CGAffineTransformMakeRotation(180.0 / 360.0 * M_PI * 2);
        } break;
        case SIArrowViewDirectionDown: {
            transform = CGAffineTransformMakeRotation(0);
        } break;
        case SIArrowViewDirectionLeft: {
            transform = CGAffineTransformMakeRotation(90.0 / 360.0 * M_PI * 2);
        } break;
        case SIArrowViewDirectionRight: {
            transform = CGAffineTransformMakeRotation(-90.0 / 360.0 * M_PI * 2);
        } break;
        default:
            break;
    }
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.arrowLayer.affineTransform = transform;
                         }];
    } else {
        [CATransaction setDisableActions:YES];
        self.arrowLayer.affineTransform = transform;
        [CATransaction setDisableActions:NO];
    }
    self.direction = direction;
}

- (CAShapeLayer *)arrowLayer {
    if (!_arrowLayer) {
        _arrowLayer = [[CAShapeLayer alloc] init];
        [self.layer addSublayer:_arrowLayer];
    }
    return _arrowLayer;
}

@end
