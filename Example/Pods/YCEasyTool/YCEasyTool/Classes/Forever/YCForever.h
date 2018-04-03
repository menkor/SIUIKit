//
//  YCForever.h
//  YCEasyTool
//
//  Created by YeTao on 2016/12/20.
//  Copyright © 2016年 ungacy. All rights reserved.
//

#import "YCForeverProtocol.h"
#import <Foundation/Foundation.h>

@interface YCForever : NSObject

+ (void)setupWithPath:(NSString *)path;

+ (void)setupWithName:(NSString *)name;

+ (void)close;

@end

@interface NSObject (YCForever)

/**
 set table name
 */
- (id (^)(id /*NSString or NSNumber*/ table))ycf_table;
/**
 Save item to db

 @return result of saving
 */
- (BOOL)ycf_save;

/**
 Save item to db
 
 @return result of saving
 */
- (BOOL)ycf_updateWhere:(id)where;

/**
 set where conditions
 */
- (id (^)(NSString *where))ycf_where;

/**
 Load item from db according to item'primary key
 Value will set to `self` after successfully loading
 
 @return result
 */
- (NSArray *)ycf_load;

/**
 Remove item from db
 
 @return result of removing
 */
- (BOOL)ycf_removeWhere:(id)where;

/**
 Remove item from db
 
 @return result of removing
 */
- (BOOL)ycf_remove;
/**
 Load items match to nonnull value in item;
 
 @param item set condition value in item
 @return items match condition
 */
+ (NSArray *)ycf_queryWithConditionItem:(id)item
                                  table:(NSString *)table
                                  limit:(NSUInteger)limit
                                 offset:(NSUInteger)offset
                                  order:(NSString *)order;

/**
 OK,do it yourself

 @param sql just select sql
 @return what you need
 */
+ (NSArray *)ycf_queryWithSql:(NSString *)sql;

/**
 Clear all data from table
 */
+ (void)ycf_emptyTable:(NSString *)table;

/**
 Drop table from db
 */
+ (void)ycf_dropTable:(NSString *)table;

@end
