//
//  YCForeverSqlHelper.h
//  YCEasyTool
//
//  Created by YeTao on 2016/12/20.
//  Copyright © 2016年 ungacy. All rights reserved.
//

#import "YCForeverProtocol.h"
#import <Foundation/Foundation.h>

@interface YCForeverSqlHelper : NSObject

+ (NSString *)createTableSqlWithTable:(NSString *)table
                                class:(Class)cls;

+ (NSString *)insertSqlWithItem:(id<YCForeverItemProtocol>)item
                          table:(NSString *)table;

+ (NSString *)updateSqlWithItem:(id<YCForeverItemProtocol>)item
                          table:(NSString *)table
                          where:(NSArray<NSString *> *)whereKeyArray;

+ (NSString *)removeSqlWithItem:(id<YCForeverItemProtocol>)item
                          table:(NSString *)table
                          where:(NSArray<NSString *> *)whereKeyArray;

+ (NSString *)selectSqlWithItem:(id<YCForeverItemProtocol>)item
                          table:(NSString *)table;

+ (NSString *)selectSqlWithItemArray:(NSArray<id<YCForeverItemProtocol>> *)itemArray
                               table:(NSString *)table;

+ (NSString *)querySqlWithTable:(NSString *)table
                          class:(Class)cls
                          limit:(NSUInteger)limit
                      condition:(id<YCForeverItemProtocol>)item
                         offset:(NSUInteger)offset
                          order:(NSString *)order;

+ (NSString *)dropSqlWithTable:(NSString *)table;

+ (NSString *)emptySqlWithTable:(NSString *)table;

@end
