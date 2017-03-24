//
//  DMDBHelper.h
//  LGMusic
//
//  Created by SHERMAN on 2017/3/18.
//  Copyright © 2017年 sherman. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DOCEMENT_PATH  [NSString stringWithFormat:@"%@%@", NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject, @"/database.db"]
@class FMResultSet;

@interface FMDBHelper : NSObject

+ (FMDBHelper *)sharedFMDBHelper;

/**
 实例化方法

 @param path 数据库路径
 @return 实例对象
 */
- (instancetype)initWithPath: (NSString *)path;

/**
 建表方法
 
 @param tableName NSString, unnull, table name
 @param columnDict unnull, table columns
 */
- (BOOL)createTable:(NSString *)tableName columns:(NSDictionary *)columnDict;

/**
 数据库表增加数据操作
 
 @param columnDict 增加列名称和值字典，一一对应
 @param tableName 表名
 @return BOOL YES/NO 更新数据是否成功
 */
- (BOOL)insertValueByColumns:(NSDictionary *)columnDict intoTable:(NSString *)tableName;

/**
 删除表数据操作
 
 @param tableName 表名
 @param conditions 判断条件，类似 "WEHRE age = 18..."
 @return 是否删除数据成功
 */
- (BOOL)deleteValueFromTable:(NSString *)tableName conditions:(NSDictionary *)conditions;

/**
 查找表格数据
 
 @param tableName 表名，必选，字符串
 @param selects 要查询的列数组，类似[@"age", @"name"]，非必选
 @param conditions 判断条件字典，类似{"id" : 1},非必选
 @return FMResultSet 结果集
 */
- (FMResultSet *)queryValueFromTable:(NSString *)tableName selects:(NSArray *)selects conditions:(NSDictionary *)conditions;

@end
