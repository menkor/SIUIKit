//
//  SIAffairInfoView.h
//  SuperId
//
//  Created by Ye Tao on 2019/5/14.
//  Copyright © 2019 SuperID. All rights reserved.
//

#import <SIDefine/SIDataBindDefine.h>
#import <UIKit/UIKit.h>

@interface SIAffairInfoView : UIView <SIDataBindProtocol>

@property (nonatomic, copy) SIBindActionBlock actionBlock;

@end
