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

- (void)popFromView:(UIView *)view;

- (void)reloadData;

@end
