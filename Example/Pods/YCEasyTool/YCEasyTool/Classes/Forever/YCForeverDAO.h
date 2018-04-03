//
//  YCForeverDAO.h
//  YCEasyTool
//
//  Created by YeTao on 2016/12/20.
//  Copyright © 2016年 ungacy. All rights reserved.
//

#import "YCForeverProtocol.h"
#import <Foundation/Foundation.h>

@interface YCForeverDAO : NSObject

+ (void)setupWithPath:(NSString *)path;

+ (void)close;

+ (instancetype)sharedInstance;

@property (nonatomic, assign) BOOL verbose; ///< Set `YES` to enable error logs for debug.

- (BOOL)addItem:(id)item table:(NSString *)table;

- (BOOL)updateItem:(id)item table:(NSString *)table where:(id)where;

- (NSArray *)loadItem:(id)item table:(NSString *)table;

- (BOOL)removeItem:(id)item table:(NSString *)table where:(id)where;

- (NSArray<id<YCForeverItemProtocol>> *)queryWithTable:(NSString *)table
                                                 class:(Class)cls
                                             condition:(id)item
                                                 limit:(NSUInteger)limit
                                                offset:(NSUInteger)offset
                                                 order:(NSString *)order;

- (NSArray<id<YCForeverItemProtocol>> *)queryWithSql:(NSString *)sql
                                               class:(Class)cls;

- (NSArray<NSDictionary *> *)queryWithSql:(NSString *)sql;

- (BOOL)dropTableWithTable:(NSString *)table;

- (BOOL)emptyTableWithTable:(NSString *)table;

- (void)clear;

@end
