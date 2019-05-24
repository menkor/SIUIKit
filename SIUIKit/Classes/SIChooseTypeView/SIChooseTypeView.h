//
//  SIChooseTypeView.h
//  SuperId
//
//  Created by dym on 2017/5/8.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import <SIDefine/SIDataBindDefine.h>
#import <UIKit/UIKit.h>

@interface SIChooseTypeView : UIView

@property (nonatomic, copy) SIBindActionBlock actionBlock;

@property (nonatomic, copy) NSArray<id<SIFormItemProtocol>> *dataArray;

@property (nonatomic, readonly) UIButton *bottomButton;

@property (nonatomic, copy) void (^bottomBlock)(void);

- (void)popFromView:(UIView *)view;

- (void)reloadData;

@end
