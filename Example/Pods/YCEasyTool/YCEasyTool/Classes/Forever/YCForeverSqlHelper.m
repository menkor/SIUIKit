
//
//  YCForeverSqlHelper.m
//  YCEasyTool
//
//  Created by YeTao on 2016/12/20.
//  Copyright © 2016年 ungacy. All rights reserved.
//

#import "YCForeverSqlHelper.h"
#import "YCProperty.h"

static inline id ModelCreateNumberFromProperty(__unsafe_unretained id model,
                                               __unsafe_unretained YCProperty *property) {
    switch (property.type) {
        case YCEncodingTypeBool: {
            bool value = ((bool (*)(id, SEL))(void *)objc_msgSend)((id)model, property.getter);
            return @(value);
        }
        case YCEncodingTypeInt8: {
            int8_t value = ((int8_t(*)(id, SEL))(void *)objc_msgSend)((id)model, property.getter);
            return value != 0 ? @(value) : nil;
        }
        case YCEncodingTypeUInt8: {
            uint8_t value = ((uint8_t(*)(id, SEL))(void *)objc_msgSend)((id)model, property.getter);
            return value != 0 ? @(value) : nil;
        }
        case YCEncodingTypeInt16: {
            int16_t value = ((int16_t(*)(id, SEL))(void *)objc_msgSend)((id)model, property.getter);
            return value != 0 ? @(value) : nil;
        }
        case YCEncodingTypeUInt16: {
            uint16_t value = ((uint16_t(*)(id, SEL))(void *)objc_msgSend)((id)model, property.getter);
            return value != 0 ? @(value) : nil;
        }
        case YCEncodingTypeInt32: {
            int32_t value = ((int32_t(*)(id, SEL))(void *)objc_msgSend)((id)model, property.getter);
            return value != 0 ? @(value) : nil;
        }
        case YCEncodingTypeUInt32: {
            uint32_t value = ((uint32_t(*)(id, SEL))(void *)objc_msgSend)((id)model, property.getter);
            return value != 0 ? @(value) : nil;
        }
        case YCEncodingTypeInt64: {
            int64_t value = ((int64_t(*)(id, SEL))(void *)objc_msgSend)((id)model, property.getter);
            return value != 0 ? @(value) : nil;
        }
        case YCEncodingTypeUInt64: {
            uint64_t value = ((uint64_t(*)(id, SEL))(void *)objc_msgSend)((id)model, property.getter);
            return value != 0 ? @(value) : nil;
        }
        case YCEncodingTypeFloat: {
            float num = ((float (*)(id, SEL))(void *)objc_msgSend)((id)model, property.getter);
            if (isnan(num) || isinf(num))
                return nil;
            return num != 0 ? @(num) : nil;
        }
        case YCEncodingTypeDouble: {
            double num = ((double (*)(id, SEL))(void *)objc_msgSend)((id)model, property.getter);
            if (isnan(num) || isinf(num))
                return nil;
            return num != 0 ? @(num) : nil;
        }
        case YCEncodingTypeLongDouble: {
            double num = ((long double (*)(id, SEL))(void *)objc_msgSend)((id)model, property.getter);
            if (isnan(num) || isinf(num))
                return nil;
            return num != 0 ? @(num) : nil;
        }
        case YCEncodingTypeString: {
            NSString *value = ((id(*)(id, SEL))(void *)objc_msgSend)((id)model, property.getter);
            if ([property.objcType isEqualToString:@"NSNumber"]) {
                return value;
            }
            return value && value.length > 0 ? value : nil;
        }
        default:
            return nil;
    }
}

@implementation YCForeverSqlHelper

+ (NSString *)createTableSqlWithTable:(NSString *)table
                                class:(Class)itemClass {
    if (!table) {
        return nil;
    }
    NSMutableString *sql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ( ", table];
    NSArray<YCProperty *> *propertyArray = [itemClass yc_propertyArray];
    NSArray *primaryKeyArray;
    if ([itemClass respondsToSelector:@selector(primaryKeyArray)]) {
        primaryKeyArray = [itemClass primaryKeyArray];
    } else {
        NSString *primaryKey = [itemClass primaryKey];
        primaryKeyArray = @[primaryKey];
    }

    __block NSUInteger primaryKeyFound = primaryKeyArray.count;
    [propertyArray enumerateObjectsUsingBlock:^(YCProperty *_Nonnull obj,
                                                NSUInteger idx,
                                                BOOL *_Nonnull stop) {
        if (obj.isNumber) {
            if (obj.type >= YCEncodingTypeFloat) {
                [sql appendFormat:@"'%@' real,", obj.name];
            } else {
                [sql appendFormat:@"'%@' integer,", obj.name];
            }
        } else {
            [sql appendFormat:@"'%@' text,", obj.name];
        }
        if ([primaryKeyArray containsObject:obj.name]) {
            primaryKeyFound--;
        }
    }];
    if (primaryKeyFound != 0) {
        NSAssert(NO, @"Not all primary found!");
        return nil;
    }
    [sql appendString:@"primary key("];
    [primaryKeyArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [sql appendFormat:@"'%@', ", obj];
    }];
    [sql deleteCharactersInRange:NSMakeRange(sql.length - 2, 2)];
    [sql appendString:@"));"];

    return sql;
}

+ (NSString *)insertSqlWithItem:(NSObject<YCForeverItemProtocol> *)item
                          table:(NSString *)table {
    if (!table) {
        return nil;
    }
    NSMutableString *sql = [NSMutableString stringWithFormat:@"INSERT OR REPLACE INTO '%@' VALUES ( ", table];
    NSArray<YCProperty *> *propertyArray = [item yc_propertyArray];
    for (NSUInteger index = 0; index < [propertyArray count]; index++) {
        [sql appendFormat:@"?%zd,", index + 1];
    }
    [sql deleteCharactersInRange:NSMakeRange([sql length] - 1, 1)];
    [sql appendString:@")"];
    return sql;
}

+ (NSString *)updateSqlWithItem:(NSObject<YCForeverItemProtocol> *)item
                          table:(NSString *)table
                          where:(NSArray<NSString *> *)whereKeyArray {
    if (!table) {
        return nil;
    }
    NSMutableString *sql = [NSMutableString stringWithFormat:@"UPDATE %@ SET ", table];
    NSArray<YCProperty *> *propertyArray = [item yc_propertyArray];
    NSMutableString *where = [NSMutableString string];

    if (whereKeyArray.count == 0) {
        Class itemClass = [item class];
        NSArray *primaryKeyArray;
        if ([itemClass respondsToSelector:@selector(primaryKeyArray)]) {
            primaryKeyArray = [itemClass primaryKeyArray];
        } else {
            NSString *primaryKey = [itemClass primaryKey];
            primaryKeyArray = @[primaryKey];
        }
        whereKeyArray = primaryKeyArray;
    }
    [where appendString:@" WHERE "];
    __block BOOL condition = NO;
    [propertyArray enumerateObjectsUsingBlock:^(YCProperty *_Nonnull obj,
                                                NSUInteger idx,
                                                BOOL *_Nonnull stop) {
        id value = ModelCreateNumberFromProperty(item, obj);
        if (value) {
            if (obj.type == YCEncodingTypeString) {
                [sql appendFormat:@" \"%@\" = '%@', ", obj.name, value];
            } else {
                [sql appendFormat:@" \"%@\" = %@, ", obj.name, value];
            }
        }
        if ([whereKeyArray containsObject:obj.name]) {
            id value = ModelCreateNumberFromProperty(item, obj);
            if (value) {
                if (obj.type == YCEncodingTypeString) {
                    [where appendFormat:@" \"%@\" = '%@' AND ", obj.name, value];
                } else {
                    [where appendFormat:@" \"%@\" = %@ AND ", obj.name, value];
                }
                condition = YES;
            }
        }
    }];
    if (!condition) {
        return [self insertSqlWithItem:item table:table];
    }
    if ([sql hasSuffix:@", "]) {
        [sql deleteCharactersInRange:NSMakeRange([sql length] - 2, 2)];
    }
    if ([where hasSuffix:@" AND "]) {
        [where deleteCharactersInRange:NSMakeRange([where length] - 5, 5)];
    }
    [sql appendString:where];
    return sql;
}

+ (NSString *)removeSqlWithItem:(NSObject<YCForeverItemProtocol> *)item
                          table:(NSString *)table
                          where:(NSArray<NSString *> *)whereKeyArray {
    if (!table) {
        return nil;
    }
    Class itemClass = [item class];
    if (!whereKeyArray) {
        if ([itemClass respondsToSelector:@selector(primaryKeyArray)]) {
            whereKeyArray = [itemClass primaryKeyArray];
        } else {
            NSString *primaryKey = [itemClass primaryKey];
            whereKeyArray = @[primaryKey];
        }
    }

    NSMutableString *sql = [NSMutableString stringWithFormat:@"DELETE FROM '%@' WHERE ", table];

    NSArray<YCProperty *> *propertyArray = [item yc_propertyArray];
    [propertyArray enumerateObjectsUsingBlock:^(YCProperty *_Nonnull obj,
                                                NSUInteger idx,
                                                BOOL *_Nonnull stop) {
        if ([whereKeyArray containsObject:obj.name]) {
            id value = ModelCreateNumberFromProperty(item, obj);
            if (value) {
                [sql appendFormat:@"\"%@\" = '%@' AND ", obj.name, value];
            }
        }
    }];
    if ([sql hasSuffix:@" AND "]) {
        [sql deleteCharactersInRange:NSMakeRange([sql length] - 5, 5)];
    }
    return sql;
}

+ (NSString *)selectSqlWithItem:(id<YCForeverItemProtocol>)item
                          table:(NSString *)table {
    if (item) {
        if (!table) {
            return nil;
        }
        return [self selectSqlWithItemArray:@[item] table:table];
    }
    return nil;
}

+ (NSString *)selectSqlWithItemArray:(NSArray<id<YCForeverItemProtocol>> *)itemArray
                               table:(NSString *)table {
    NSObject<YCForeverItemProtocol> *item = itemArray.firstObject;
    Class itemClass = [item class];
    if (!table) {
        return nil;
    }
    NSArray<YCProperty *> *propertyArray = [item yc_propertyArray];
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM '%@' WHERE ", table];
    [itemArray enumerateObjectsUsingBlock:^(NSObject<YCForeverItemProtocol> *_Nonnull item,
                                            NSUInteger idx,
                                            BOOL *_Nonnull stop) {

        if (![item isKindOfClass:itemClass]) {
            NSAssert([item isKindOfClass:itemClass], @"Items in array are not the same class");
            return;
        }
        [sql appendString:@"( "];
        [propertyArray enumerateObjectsUsingBlock:^(YCProperty *_Nonnull property,
                                                    NSUInteger idx,
                                                    BOOL *_Nonnull stop) {
            id value = ModelCreateNumberFromProperty(item, property);
            if (value) {
                [sql appendFormat:@"%@ = %@ AND ", property.name, value];
            }
        }];
        if ([sql hasSuffix:@" AND "]) {
            [sql deleteCharactersInRange:NSMakeRange([sql length] - 5, 5)];
        }
        [sql appendString:@" ) OR "];
    }];
    if ([sql hasSuffix:@" OR "]) {
        [sql deleteCharactersInRange:NSMakeRange([sql length] - 4, 4)];
    }
    return sql;
}

+ (NSString *)querySqlWithTable:(NSString *)table
                          class:(Class)cls
                          limit:(NSUInteger)limit
                      condition:(NSObject<YCForeverItemProtocol> *)item
                         offset:(NSUInteger)offset
                          order:(NSString *)order {
    if (!table) {
        return nil;
    }
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM '%@' ", table];
    if (item) {
        [sql appendString:@"WHERE"];
        NSArray<YCProperty *> *propertyArray = [cls yc_propertyArray];
        [propertyArray enumerateObjectsUsingBlock:^(YCProperty *_Nonnull obj,
                                                    NSUInteger idx,
                                                    BOOL *_Nonnull stop) {
            id value = ModelCreateNumberFromProperty(item, obj);
            if (value) {
                if (obj.type == YCEncodingTypeString) {
                    [sql appendFormat:@" \"%@\" = '%@' AND", obj.name, value];
                } else {
                    [sql appendFormat:@" \"%@\" = %@ AND", obj.name, value];
                }
            }
        }];
        if ([sql hasSuffix:@"AND"]) {
            [sql deleteCharactersInRange:NSMakeRange([sql length] - 3, 3)];
        } else if ([sql hasSuffix:@"WHERE"]) {
            [sql deleteCharactersInRange:NSMakeRange([sql length] - 5, 5)];
        }
    }
    if (order) {
        [sql appendString:order];
    }
    if (limit > 0) {
        [sql appendFormat:@" LIMIT %zd OFFSET %zd", limit, offset];
    }
    return sql;
}

+ (NSString *)dropSqlWithTable:(NSString *)table {
    if (!table) {
        return nil;
    }
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE '%@'", table];
    return sql;
}

+ (NSString *)emptySqlWithTable:(NSString *)table {
    if (!table) {
        return nil;
    }
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM '%@'", table];
    return sql;
}

@end