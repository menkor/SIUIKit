
//
//  YCForever.m
//  YCEasyTool
//
//  Created by YeTao on 2016/12/20.
//  Copyright © 2016年 ungacy. All rights reserved.
//

#import "YCForever.h"
#import "YCForeverDAO.h"
#import "YCProperty.h"

static NSString *const kYCFDBFileName = @"forever.sqlite";

@interface YCForever ()

@end

@implementation YCForever

+ (void)setupWithPath:(NSString *)path {
    [YCForeverDAO setupWithPath:path];
}

+ (void)setupWithName:(NSString *)name {
    NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dir = [cacheFolder stringByAppendingPathComponent:name];
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dir isDirectory:&isDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dir
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    NSString *path = [dir stringByAppendingPathComponent:kYCFDBFileName];
    [YCForeverDAO setupWithPath:path];
}

+ (void)close {
    [YCForeverDAO close];
}

@end

@implementation NSObject (YCForever)

- (id (^)(id /*NSString or NSNumber*/ table))ycf_table {
    id (^block)(id table) = ^id(id table) {
        self.yc_store(@"table", [NSString stringWithFormat:@"%@", table ?: NSStringFromClass([self class])]);
        return self;
    };
    return block;
}

- (NSString *)ycf_tableName {
    return self.yc_store(@"table", nil) ?: NSStringFromClass([self class]);
}

- (NSString *)ycf_whereCondition {
    return self.yc_store(@"where", nil);
}

- (id (^)(NSString *where))ycf_where {
    id (^block)(NSString *where) = ^id(NSString *where) {
        self.yc_store(@"where", where);
        return self;
    };
    return block;
}

- (BOOL)ycf_save {
    if ([self isKindOfClass:[NSArray class]]) {
        for (NSObject *obj in (NSArray *)self) {
            [[YCForeverDAO sharedInstance] addItem:obj table:obj.ycf_tableName];
        }
        return YES;
    }
    return [[YCForeverDAO sharedInstance] addItem:self table:self.ycf_tableName];
}

- (BOOL)ycf_updateWhere:(id)where {
    return [[YCForeverDAO sharedInstance] updateItem:self table:self.ycf_tableName where:where];
}

- (NSArray *)ycf_load {
    return [[YCForeverDAO sharedInstance] loadItem:self table:self.ycf_tableName];
}

- (BOOL)ycf_remove {
    return [[YCForeverDAO sharedInstance] removeItem:self table:self.ycf_tableName where:self.ycf_whereCondition];
}

- (BOOL)ycf_removeWhere:(id)where {
    return [[YCForeverDAO sharedInstance] removeItem:self table:self.ycf_tableName where:(id)where];
}

+ (NSArray<id> *)ycf_queryWithConditionItem:(NSObject *)item
                                      table:(NSString *)table
                                      limit:(NSUInteger)limit
                                     offset:(NSUInteger)offset
                                      order:(NSString *)order {
    return [[YCForeverDAO sharedInstance] queryWithTable:table ?: NSStringFromClass(self)
                                                   class:self
                                               condition:item
                                                   limit:limit
                                                  offset:offset
                                                   order:order];
}

+ (NSArray<id> *)ycf_queryWithSql:(NSString *)sql {
    return [[YCForeverDAO sharedInstance] queryWithSql:sql class:self];
}

+ (void)ycf_emptyTable:(NSString *)table {
    [[YCForeverDAO sharedInstance] emptyTableWithTable:table ?: NSStringFromClass(self)];
}

+ (void)ycf_dropTable:(NSString *)table {
    [[YCForeverDAO sharedInstance] dropTableWithTable:table ?: NSStringFromClass(self)];
}

@end
