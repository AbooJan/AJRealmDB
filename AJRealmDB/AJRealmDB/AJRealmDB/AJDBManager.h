//
//  AJDatabaseManager.h
//  AJRealmDB
//
//  Created by AbooJan on 2016/11/7.
//  Copyright © 2016年 AbooJan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AJDBObject.h"
#import "AJSortFilter.h"

@interface AJDBManager : NSObject


/**
 * 设置数据库加密Key,全局只需设置一次。如果不设置，默认不加密
 * 一个数据库只对应一个Key
 @param secKey 加密Key
 */
+ (void)configSecurityKey:(NSData *)secKey;

/**
 *  写入一条数据
 *
 *  @param obj 目标数据
 */
+ (void)writeObj:(__kindof AJDBObject *)obj;

/**
 *  批量写入
 *
 *  @param objs 数组
 */
+ (void)writeObjArray:(NSArray<__kindof AJDBObject *> *)objs;

/**
 *  更新一条数据，更新数据必须在block中执行
 *
 *  @param updateBlock 在block中更新数据
 */
+ (void)updateObj:(void (^)())updateBlock;

/**
 *  在数据库中删除目标数据
 *
 *  @param obj 目标数据
 */
+ (void)deleteObj:(__kindof AJDBObject *)obj;

/**
 *  在数据库中删除目标数组数据
 *
 *  @param objs 需要删除的数据数组
 */
+ (void)deleteObjs:(NSArray<__kindof AJDBObject *> *)objs;

/**
 *  查询目标数据模型的所有存储数据
 *
 *  @param clazz 需要查询的目标类
 *
 *  @return 数据库中存储的所有数据
 */
+ (NSArray<__kindof AJDBObject *> *)queryAllObj:(Class)clazz;

/**
 *  根据断言条件查询目标数据
 *
 *  @param predicate 查询条件
 *  @param clazz     需要查询的目标类
 *
 *  @return 查询结果
 */
+ (NSArray<__kindof AJDBObject *> *)queryObjWithPredicate:(NSPredicate *)predicate targetClass:(Class)clazz;

/**
 *  根据断言条件查询数据，并进行排序
 *
 *  @param predicate  查询条件
 *  @param clazz      需要查询的类
 *  @param sortFilter 排序配置
 *
 *  @return 查询结果
 */
+ (NSArray<__kindof AJDBObject *> *)queryObjWithPredicate:(NSPredicate *)predicate sortFilter:(AJSortFilter *)sortFilter targetClass:(Class)clazz;

/**
 *  根据主键查询目标数据
 *
 *  @param primaryKey 主键值
 *  @param clazz      需要查询的类
 *
 *  @return 查询结果
 */
+ (__kindof AJDBObject *)queryObjWithPrimaryKeyValue:(id)primaryKey targetClass:(Class)clazz;

/**
 *  清空数据库
 */
+ (void)clear;

@end
