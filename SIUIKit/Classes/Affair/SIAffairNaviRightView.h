//
//  SIAffairNaviRightView.h
//  SuperId
//
//  Created by Ye Tao on 2019/5/14.
//  Copyright © 2019 SuperID. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SIAffairNaviRightActionType) {
    SIAffairNaviRightActionTypeMore = 100,
    SIAffairNaviRightActionTypeRole,
};

@class SIAffairNaviRightView;
@protocol SIAffairNaviRightActionDelegate <NSObject>

- (void)naviRightView:(SIAffairNaviRightView *)view action:(SIAffairNaviRightActionType)action data:(id)data;

@end

@class SIFormItem;
@interface SIAffairNaviRightView : UIView

@property (nonatomic, weak) id<SIAffairNaviRightActionDelegate> delegate;

- (void)reloadData;

@property (nonatomic, strong, readonly) SIFormItem *item;

@end

@class SIAffairInfo;
/*
 SIAffairDefineImp.m
 */
extern void SIAffairNaviRightPop(id<SIAffairNaviRightActionDelegate> delegate, SIAffairInfo *affair, UIView *some);
