//
//  SIChooseTypeView.m
//  SuperId
//
//  Created by dym on 2017/5/8.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "SIChooseTypeView.h"
#import "SIChooseTypeViewCell.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import <Masonry/Masonry.h>
#import <SIDefine/SIDefine.h>
#import <SITheme/SIColor.h>
#import <SITheme/SIFont.h>
#import <YCEasyTool/YCCollectionView.h>

@interface SIChooseTypeView () <YCCollectionViewDelegate>

@property (nonatomic, strong) UIButton *bottomButton;

@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic, strong) YCCollectionView *collection;

@end

@implementation SIChooseTypeView

- (instancetype)init {
    self = [super init];
    [self initUI];
    return self;
}

- (void)reloadData {
    _collection.flowLayout.itemSize = CGSizeMake(80, 92);
    NSUInteger count = MIN(3, self.dataArray.count);
    if (count == 1) {
        _collection.flowLayout.sectionInset = UIEdgeInsetsMake(0, (ScreenWidth - 80) / 2, 0, 0);
    } else {
        CGFloat margin = count == 2 ? 120 : 60;
        _collection.flowLayout.sectionInset = UIEdgeInsetsMake(0, margin / 2, 0, margin / 2);
    }
    [self.collection mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(110 * MAX(1, self.dataArray.count / 3));
    }];
    self.collection.dataSource[YCCollectionViewSingleSectionKey] = self.dataArray;
    [self.collection reloadData];
}

- (void)initUI {
    self.backgroundColor = [SIColor colorWithHex:0x80ffffff];

    [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(self).inset(kBottomHeight);
    }];

    [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(114);
        make.height.mas_equalTo(0);
    }];
}

- (void)cancel {
    [self removeFromSuperview];
    [self.effectView removeFromSuperview];
}

- (void)popFromView:(UIView *)view {
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:beffect];
    effectView.frame = view.frame;
    [view addSubview:effectView];
    self.effectView = effectView;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top).offset(height);
        make.left.right.mas_equalTo(view);
        make.height.mas_equalTo(height);
    }];

    [view layoutIfNeeded];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top);
    }];
    [UIView animateWithDuration:0.25
                     animations:^{
                         [view layoutIfNeeded];
                     }];
}

- (void)collectionView:(YCCollectionView *)collectionView action:(id)action atIndexPath:(NSIndexPath *)indexPath {
    [self cancel];
    if (self.actionBlock) {
        self.actionBlock([collectionView objectAtIndexPath:indexPath]);
    }
}

#pragma mark - Lazy Load

- (UIButton *)bottomButton {
    if (!_bottomButton) {
        _bottomButton = [[UIButton alloc] init];
        _bottomButton.backgroundColor = [SIColor colorWithHex:0xf7f7f7];
        _bottomButton.titleLabel.font = [SIFont systemFontOfSize:16];
        _bottomButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_bottomButton setTitle:@"取消" forState:UIControlStateNormal];
        [_bottomButton setTitleColor:[SIColor colorWithHex:0x926dea] forState:UIControlStateNormal];
        [_bottomButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bottomButton];
    }
    return _bottomButton;
}

- (YCCollectionView *)collection {
    if (!_collection) {
        _collection = [[YCCollectionView alloc] initWithFrame:CGRectZero];
        UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
        [_collectionView setValue:layout forKey:@"flowLayout"];
        _collection.cellClass = [SIChooseTypeViewCell class];
        _collection.flowLayout.minimumLineSpacing = 28;
        _collection.flowLayout.minimumInteritemSpacing = 10;
        _collection.flowLayout.sectionInset = UIEdgeInsetsMake(0, 30, 0, 30);
        _collection.delegate = self;
        _collection.collectionView.scrollEnabled = NO;
        [self addSubview:_collection];
    }
    return _collection;
}

@end
