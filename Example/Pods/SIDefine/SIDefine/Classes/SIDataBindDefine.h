//
//  SIDataBindDefine.h
//  SuperId
//
//  Created by Ye Tao on 2017/3/23.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#ifndef SIDataBindDefine_h
#define SIDataBindDefine_h

static NSString *__nonnull const kSIDataBindReloadAction = @"reload";

typedef void (^SIBindActionBlock)(__nullable id data);

@protocol SIDataBindProtocol <NSObject>

- (void)reloadWithData:(__nullable id)model;

@optional

- (void)initUI;

@property (nonatomic, copy, nullable) SIBindActionBlock actionBlock;

- (UIView *__nullable)bottomLine;

@end

/**
 optional protocol
 */
@protocol SIFormItemProtocol <NSObject>

@optional
@property (nonatomic, copy) NSString *key;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, strong) id data;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy) NSDictionary *theme;

@end

#endif /* SIDataBindDefine_h */
