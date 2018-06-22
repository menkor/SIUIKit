//
//  SIChooseTypeViewCell.h
//  SuperId
//
//  Created by Ye Tao on 2018/2/9.
//  Copyright © 2018年 SuperId. All rights reserved.
//

#import <SIDefine/SIDataBindDefine.h>
#import <UIKit/UIKit.h>

@interface SIChooseTypeViewCell : UICollectionViewCell <SIDataBindProtocol>

@property (nonatomic, copy) SIBindActionBlock actionBlock;

@end
