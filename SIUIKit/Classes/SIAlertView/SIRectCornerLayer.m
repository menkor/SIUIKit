//
//  SIRectCornerLayer.m
//  SuperId
//
//  Created by Ye Tao on 2017/8/25.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "SIRectCornerLayer.h"

@implementation SIRectCornerLayer

- (void)setCornerStyle:(UIRectCorner)cornerStyle {
    _cornerStyle = cornerStyle;
    [self drawCorner];
}

- (void)drawCorner {
    if (CGRectEqualToRect(self.frame, CGRectZero) ||
        self.cornerRadius == 0) {
        return;
    }
    //angle [0-M_PI * 2].0:最右边  M_PI_2 最下边  M_PI 最左边  M_PI + M_PI_2 最上面
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                               byRoundingCorners:_cornerStyle
                                                     cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];

    self.path = path.CGPath;
}

@end
