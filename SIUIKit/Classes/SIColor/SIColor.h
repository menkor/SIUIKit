//
//  SIColor.h
//
//  Created by Ye Tao on 2017/3/3.
//
//

#import <UIKit/UIKit.h>

@interface SIColor : UIColor

/*!
 *  @brief 转化16进制值字符串[0x1234ab]->UIColor
 *  @param stringToConvert 如: @"0x1234ab" ,@"#1234ab"
 *  @return 16进制值字符串对应的颜色
 *  @code
    [SIColor colorWithHexString:@"0x1234ab"];
 */

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
/*!
 *  @brief 转化16进制值[0x1234ab]->UIColor
 *  @param hexValue 如: 0x1234ab
 *  @return 16进制值对应的颜色
 *  @code
    [SIColor colorWithHex:0x1234ab];
 */
+ (UIColor *)colorWithHex:(unsigned long)hexValue;

/*!
 *  @brief 转化16进制值[0x1234ab]->UIColor
 *  @param hexValue 如: 0x1234ab
 *  @param alpha 如: 0.4
 *  @return 16进制值以及alpha对应的颜色
 *  @code
    [SIColor colorWithHex:0x1234ab alpha:0.3];
 */
+ (UIColor *)colorWithHex:(unsigned long)hexValue alpha:(CGFloat)alpha;

@end
