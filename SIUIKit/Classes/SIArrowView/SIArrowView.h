//
//  SIArrowView.h
//  SuperId
//
//  Created by Ye Tao on 2017/2/23.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, SIArrowViewStyle) {
    SIArrowViewDirectionMask = 0xF,
    SIArrowViewDirectionUp = 0,
    SIArrowViewDirectionDown = 1,
    SIArrowViewDirectionLeft = 2,
    SIArrowViewDirectionRight = 3,

    SIArrowViewStyleTriangle = 1 << 4,
    SIArrowViewStyleArrow = 1 << 5,
};

@interface SIArrowView : UIView

+ (instancetype)arrowWithFrame:(CGRect)frame style:(SIArrowViewStyle)style color:(UIColor *)color;

- (void)updateDirection:(SIArrowViewStyle)direction animated:(BOOL)animated;

@end
