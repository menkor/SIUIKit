//
//  SIEmptyView.h
//  SuperId
//
//  Created by Ye Tao on 2017/8/14.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "SIEmptyViewDefine.h"
#import <UIKit/UIKit.h>

@interface SIEmptyView : UIView

@property (nonatomic, copy) NSDictionary *theme;

- (void)reloadWithData:(id)model;

@property (nonatomic, copy) void (^actionBlock)(id data);

@end
