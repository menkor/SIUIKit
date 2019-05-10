//
//  SIProgressView.h
//
//  Created by Ye Tao on 2017/3/3.
//
//

#import <UIKit/UIKit.h>

@interface SIProgressView : UIView

- (id)initWithFrame:(CGRect)frame;

@property (nonatomic) CGFloat progressWidth;

@property (nonatomic) CGFloat trackWidth;

/*!
 *  @brief progress 设置最近的进度
 *  @param progress [0-1]
 */
- (void)setProgress:(CGFloat)progress;

/*!
 *  @param trackColor 进度条背景色
 */
- (void)setTrackColor:(UIColor *)trackColor;

/*!
 *  @param progressColor 进度条颜色
 */
- (void)setProgressColor:(UIColor *)progressColor;

/*!
 *  @param angle [0-M_PI * 2].0:最右边  M_PI_2 最下边  M_PI 最左边  M_PI + M_PI_2 最上面
 */
- (void)setStartAngle:(CGFloat)angle;

/*!
 *  @brief Default YES
 *  @param clockwise YES:顺时针  NO:逆时针
 */
- (void)setClockwise:(BOOL)clockwise;

@end
