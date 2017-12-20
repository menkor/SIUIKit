//
//  YCTreeMenuView.m
//  YCEasyTool
//
//  Created by Ye Tao on 2017/2/13.
//
//

#import "YCTreeMenuView.h"

@interface YCTreeMenuView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<id<YCTreeMenuNodeProtocol>> *nodeArray;

@property (nonatomic, strong) NSMutableArray<id<YCTreeMenuNodeProtocol>> *dataSource;

@property (nonatomic, strong) Class cellClass;

@end

@implementation YCTreeMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)registerMenuCell:(Class)cls {
    self.cellClass = cls;
    [self.tableView registerClass:cls forCellReuseIdentifier:NSStringFromClass(cls)];
}

- (void)reloadData:(NSArray<id<YCTreeMenuNodeProtocol>> *)nodeArray {
    self.nodeArray = nodeArray;
    [self parseNode:nil];
}

- (void)parseNode:(id<YCTreeMenuNodeProtocol>)node {
    self.dataSource = [NSMutableArray array];
    [self countForNodeArray:self.nodeArray];
    NSInteger currentIndex = [self.dataSource indexOfObject:node];
    if (currentIndex != NSNotFound) {
        NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:0];
        NSInteger totolChildrenCount = [self flattenNodeArray:node.children willShrink:YES].count;
        for (NSInteger index = 0; index < totolChildrenCount; index++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:currentIndex + index + 1 inSection:0]];
        }
        [self.tableView beginUpdates];
        if (node.expanded) {
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        }
        [self.tableView endUpdates];
    } else {
        [self.tableView reloadData];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (NSArray *)flattenNodeArray:(NSArray<id<YCTreeMenuNodeProtocol>> *)nodeArray willShrink:(BOOL)shrink {
    __block CGFloat nodeCount = 0;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    [nodeArray enumerateObjectsUsingBlock:^(id<YCTreeMenuNodeProtocol> _Nonnull obj,
                                            NSUInteger idx,
                                            BOOL *_Nonnull stop) {
        nodeCount += 1;
        [array addObject:obj];

        if (obj.expanded && obj.children) {
            NSArray *childArray = [self flattenNodeArray:obj.children willShrink:shrink];
            nodeCount += childArray.count;
            [array addObjectsFromArray:childArray];
        }
        if (shrink) {
            obj.expanded = NO;
        }
    }];
    return array;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (CGFloat)countForNodeArray:(NSArray<id<YCTreeMenuNodeProtocol>> *)nodeArray {
    __block CGFloat count = 0;
    [nodeArray enumerateObjectsUsingBlock:^(id<YCTreeMenuNodeProtocol> _Nonnull obj,
                                            NSUInteger idx,
                                            BOOL *_Nonnull stop) {
        count += 1;
        if (obj.parent) {
            obj.depth = obj.parent.depth + 1;
        }

        [self.dataSource addObject:obj];
        if (obj.expanded && obj.children) {
            count += [self countForNodeArray:obj.children];
        }
    }];
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<YCTreeMenuNodeProtocol> node = self.dataSource[indexPath.row];
    return [node height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell<YCTreeMenuCellProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.cellClass)];
    id<YCTreeMenuNodeProtocol> node = self.dataSource[indexPath.row];
    [cell reloadData:node];
    __weak typeof(node) weak_node = node;
    __weak typeof(self) weak_self = self;
    [cell setActionBlock:^() {
        [weak_self didChangeNode:weak_node];
    }];
    if (self.cellConfigureBlock) {
        self.cellConfigureBlock(cell, indexPath);
    }
    return cell;
}

- (void)didChangeNode:(id<YCTreeMenuNodeProtocol>)node {
    if (node.children.count > 0) {
        node.expanded = !node.expanded;
        [self parseNode:node];
        if (self.delegate && [self.delegate respondsToSelector:@selector(treeMenu:didChangeNode:)]) {
            [self.delegate treeMenu:self didChangeNode:node];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(treeMenu:didSelectNode:)]) {
        id<YCTreeMenuNodeProtocol> node = self.dataSource[indexPath.row];
        [self.delegate treeMenu:self didSelectNode:node];
    }
}

@end