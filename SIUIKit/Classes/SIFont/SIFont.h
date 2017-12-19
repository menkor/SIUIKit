//
//  SIFont.h
//  SuperId
//
//  Created by YeTao on 17/1/18.
//
//

#import <UIKit/UIKit.h>

@interface SIFont : NSObject

/*!
 *  @brief PingFangSC-Regular
 */
+ (UIFont *)systemFontOfSize:(CGFloat)fontSize;

/*!
 *  @brief PingFangSC-Semibold
 */
+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize;

/*!
 *  @brief PingFangSC-Light
 */
+ (UIFont *)lightSystemFontOfSize:(CGFloat)fontSize;

/*!
 *  @brief PingFangSC-Medium
 */
+ (UIFont *)mediumSystemFontOfSize:(CGFloat)fontSize;

/*!
 *  @brief PingFangSC-Medium
 */
+ (UIFont *)italicSystemFontOfSize:(CGFloat)fontSize;

/*!
 *  @brief 自定义字体
 */
+ (UIFont *)fontWithName:(NSString *)fontName size:(CGFloat)fontSize;

@end
