//
//  DMDBHelper.m
//  LGMusic
//
//  Created by SHERMAN on 2017/3/18.
//  Copyright © 2017年 sherman. All rights reserved.
//

#import "FMDBHelper.h" 
#import "FMDatabase.h"

@implementation FMDBHelper {
    FMDatabase *_db;
    NSLock *_lock;
}

/**
 初始化单例方法

 @return FMDBHelper 实例变量
 */
+ (FMDBHelper *)sharedFMDBHelper {
    static FMDBHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[FMDBHelper alloc] initWithPath:DOCEMENT_PATH];
    });
    return  helper;
}

- (instancetype)initWithPath: (NSString *)path {
    
    if (self = [super init]) {
        _db = [FMDatabase databaseWithPath:path];
        BOOL ret = [_db open];
        if (!ret) {
            NSLog(@"打开数据库失败");
        }
        _lock = [[NSLock alloc] init];
    }
    return self;
}

/**
 建表方法

 @param tableName NSString, unnull, table name
 @param columnDict unnull, table columns
 */
- (BOOL)createTable:(NSString *)tableName columns:(NSDictionary *)columnDict {
    [_lock lock];
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(UID INTEGER PRIMARY KEY AUTOINCREMENT", tableName];
    for (NSString *key in columnDict) {
        sql = [sql stringByAppendingFormat:@", %@ %@", key,columnDict[key]];
    }
    sql = [sql stringByAppendingString:@");"];
    BOOL ret = [_db executeUpdate:sql];
    if (!ret) {
        NSLog(@"建表失败");
    }
    [_lock unlock];
    return ret;
}

/**
 数据库表增加数据操作

 @param columnDict 增加列名称和值字典，一一对应
 @param tableName 表名
 @return BOOL YES/NO 更新数据是否成功
 */
- (BOOL)insertValueByColumns:(NSDictionary *)columnDict intoTable:(NSString *)tableName {
    [_lock lock];
    NSString *columns = [columnDict.allKeys componentsJoinedByString:@","];
    NSMutableArray *temp = [NSMutableArray array];
    for (NSInteger i = 0; i < columnDict.allKeys.count; i ++) {
        [temp addObject:@"?"];
    }
    NSString *valueSymbol = [temp componentsJoinedByString:@","];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES(%@);", tableName, columns, valueSymbol];
//    BOOL ret = [_db executeQuery:sql withArgumentsInArray:columnDict.allValues];
    BOOL ret = [_db executeUpdate:sql withArgumentsInArray:columnDict.allValues];
    
    NSLog(@"%@ %@", sql, columnDict);
    if (!ret) {
        NSLog(@"更新数据失败！");
    }
    [_lock unlock];
    return ret;
}


- (FMResultSet *)selectValueFromTable:(NSString *)tableName selects:(NSArray *)selects conditions:(NSDictionary *)conditions {
    [_lock lock];
    
    
    
    [_lock unlock];
    return nil;
}

/**
 删除表数据操作

 @param tableName 表名
 @param conditions 判断条件，类似 "WEHRE age = 18..."
 @return 是否删除数据成功
 */
- (BOOL)deleteValueFromTable:(NSString *)tableName conditions:(NSDictionary *)conditions {
    [_lock lock];
    NSString *sql = @"";
    for (NSString *key in conditions) {
        NSString *str;
        ([sql  isEqualToString: @""])?(str = @" WHERE "):(str = @" AND ");
        sql = [sql stringByAppendingFormat:@"%@ %@ = ?", str, key];
    }
    NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM %@ %@;", tableName, sql];
    BOOL ret = [_db executeUpdate:querySQL withArgumentsInArray:conditions.allValues];
    
    //[_db executeUpdate:<#(NSString *)#> withArgumentsInArray:<#(NSArray *)#>];
    if (!ret) {
        NSLog(@"删除数据失败！");
    }
    
    NSLog(@"%@", querySQL);
    [_lock unlock];
    return ret;
}

/**
 查找表格数据

 @param tableName 表名，必选，字符串
 @param selects 要查询的列数组，类似[@"age", @"name"]，非必选
 @param conditions 判断条件字典，类似{"id" : 1},非必选
 @return FMResultSet 结果集
 */
- (FMResultSet *)queryValueFromTable:(NSString *)tableName selects:(NSArray *)selects conditions:(NSDictionary *)conditions {
    [_lock lock];
    NSString *selectString = @"*";
    if (selects && selects.count > 0) {
        selectString = [selects componentsJoinedByString:@","];
    }
    
    NSString *conditionString = @"";
    if (conditions && conditions.count > 0) {
        for (NSString *key in conditions) {
            NSString *str ;
            ([conditionString isEqualToString:@""])?(str = @" WHERE " ):(str = @" AND " );
            conditionString = [conditionString stringByAppendingString: [NSString stringWithFormat:@"%@ %@ = '%@'", str, key, conditions[key]]];
        }
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ %@;", selectString, tableName, conditionString];
//    NSLog(@"%@",sql);
    FMResultSet *result = [_db executeQuery:sql];
    [_lock unlock];
    return result;
}





@end
