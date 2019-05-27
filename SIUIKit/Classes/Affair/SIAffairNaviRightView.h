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

@class SIAffairInfo;
@class SIAffairNaviRightView;
@protocol SIAffairNaviRightActionDelegate <NSObject>

- (void)naviRightView:(SIAffairNaviRightView *)view action:(SIAffairNaviRightActionType)action data:(id)data;

@end

@interface SIAffairNaviRightItem : NSObject

@property (nonatomic, assign) BOOL white;

@property (nonatomic, assign) BOOL showRight;

@property (nonatomic, copy) NSString *rightIcon;

@property (nonatomic, strong) SIAffairInfo *affair;

@property (nonatomic, strong) NSArray<UIButton *> *extra;

@end

@interface SIAffairNaviRightView : UIView

@property (nonatomic, weak) id<SIAffairNaviRightActionDelegate> delegate;

- (void)reloadData;

@property (nonatomic, strong, readonly) SIAffairNaviRightItem *item;

@end

/*
 SIAffairDefineImp.m
 */
extern void SIAffairNaviRightPop(id<SIAffairNaviRightActionDelegate> delegate, SIAffairInfo *affair, UIView *some);
