//
//  SINavigationBar.h
//  SuperId
//
//  Created by Ye Tao on 2017/7/24.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "SINavigationBarDef.h"
#import <UIKit/UIKit.h>

#pragma mark - SINavigationBar

/*!
 @brief 自定义导航栏.
 @code
 SINavigationBar *navBar = [SINavigationBar create];
 [navBar.right.add itemWithType:SINavigationItemTypeCustomText
                      resource:@"返回"
                      selector:@selector(OnReturnBack)];
 [navBar.title titleItem:<#标题#>];
 */
@interface SINavigationBar : UIView

/*!
 *  @brief 是否显示 YES:显示.NO:隐藏
 */
@property (nonatomic, assign) BOOL visible;

/*!
 *  @brief 是否显示 YES:显示.NO:隐藏
 */
@property (nonatomic, assign) BOOL hideNavigationBarLine; //default is NO;

/*!
 @brief 一般为导航栏都在的VC
 */
@property (nonatomic, weak) id owner;

/*!
 @brief 使用MRC时返回autorelease的对象.
 */
+ (instancetype)create;

#pragma mark - Theme

/*!
 *  @brief default is SINavigationThemeWhite
 *  @param theme new theme you need
 */
- (void)setTheme:(SINavigationTheme)theme;

- (void)setThemeColor:(UIColor *)themeColor;

- (void)setTextColor:(UIColor *)textColor;

#pragma mark - Convenient

/*!
 @brief 当目前位置对应的是UIButton时,返回该button,否则则返回nil;
 @code self.left.button
 */
- (UIButton *)button;

/*!
 @brief 返回目前位置的控件,没有则返回nil;
 @code 
 self.left.item
 @endcode
 */
- (UIView *)item;

#pragma mark - Position

/*!
 @brief 设置当前位置为SINavigationItemPositionLeft
 */
- (instancetype)left;

/*!
 @brief 设置当前位置为SINavigationItemPositionTitle
 */
- (instancetype)title;

/*!
 @brief 设置当前位置为SINavigationItemPositionRight
 */
- (instancetype)right;

- (instancetype)add;

/*!
 @brief 移除当前位置的控件
 @code [self.left remove];
 */
- (void)remove;

#pragma mark - Buildin UI

/*!
 @brief 需要在[SINavigationAdaptor.plist]中提前配置该类型的tag
 */
- (id)itemWithType:(SINavigationItemType)type;

/**
 *  根据参数初始化按钮
 */
- (id)itemWithParam:(NSDictionary *)param selector:(SEL)selector;

/*!
 @brief 向owner添加selector
 @see -owner
 @warning 默认找到SINavigationBar父视图所在的VC,因此需要先将SINavigationBar加入父视图中.
 */
- (UIButton *)itemWithType:(SINavigationItemType)type selector:(SEL)selector;

/*!
 @brief 向SINavigationItemPositionTitle位置添加一个title[UILabel].
 */
- (UILabel *)titleItem:(NSString *)title;

- (UILabel *)attributedTitleItem:(NSAttributedString *)title;

#pragma mark - Custom UI

/*!
 @brief 添加
 */
- (UIView *)addItem:(SINavigationBarAddItem)itemBlock;

- (UIButton *)itemWithType:(SINavigationItemTypeCustom)type
                  resource:(NSString *)resource
                  selector:(SEL)selector;

- (UIButton *)itemWithTitle:(NSString *)title
                  selector:(SEL)selector;

- (UIButton *)itemWithIcon:(NSString *)icon
                   selector:(SEL)selector;

/*!
 *  @brief 导航栏上元素离top的距离.默认20
 */
@property (nonatomic, assign) CGFloat topBaseline; //default is status bar height

@end
