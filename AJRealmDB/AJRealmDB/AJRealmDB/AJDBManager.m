//
//  AJDatabaseManager.m
//  AJRealmDB
//
//  Created by AbooJan on 2016/11/7.
//  Copyright © 2016年 AbooJan. All rights reserved.
//

#import "AJDBManager.h"
#import "Base64.h"

@interface AJDBManager()
@property (nonatomic,strong) RLMRealmConfiguration *realmConfig;
@end

@implementation AJDBManager

+ (AJDBManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    static AJDBManager * instance;
    dispatch_once( &onceToken, ^{
        
        instance = [[AJDBManager alloc] init];
    
        
        // 加密KEY,一个数据库，加密Key必须唯一,否则读取不了数据
        NSString *sourceKey = [@"A1234567890987654321qwertyuioplkjhgfdsazxcvbnm8gruodchgwpjsziub8" base64EncodedString];
        NSData *seckey = [NSData dataWithBase64EncodedString:sourceKey];

        NSLog(@"$$: %@", seckey);
        
        // 数据库配置
        instance.realmConfig = [RLMRealmConfiguration defaultConfiguration];
        instance.realmConfig.encryptionKey = seckey;
        
    });
    
    return instance;
}

+ (void)checkClazz:(Class)clazz
{
    BOOL isCorrectClass = [[clazz new] isKindOfClass:[AJDBObject class]];
    NSAssert(isCorrectClass, @"必须继承自AJDBObject");
}

/// 跨线程读写数据会出问题，必须每次都实例化一个最新的
- (RLMRealm *)realm
{
    if (self.realmConfig) {
        
        NSError *error = nil;
        RLMRealm *tempRealm = [RLMRealm realmWithConfiguration:self.realmConfig error:&error];
        if (error) {
            NSLog(@"Error opening realm: %@", error);
        }
        
        return tempRealm;
        
    }else{
        
        return [RLMRealm defaultRealm];
    }
}

#pragma mark - 写入

+ (void)writeObj:(__kindof AJDBObject *)obj
{
    RLMRealm *realm = [[self sharedInstance] realm];
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:obj];
    [realm commitWriteTransaction];
}

+ (void)writeObjArray:(NSArray<__kindof AJDBObject *> *)objs
{
    RLMRealm *realm = [[self sharedInstance] realm];
    [realm beginWriteTransaction];
    [realm addOrUpdateObjectsFromArray:objs];
    [realm commitWriteTransaction];
}

#pragma mark - 更新

+ (void)updateObj:(void (^)())updateBlock
{
    RLMRealm *realm = [[self sharedInstance] realm];
    
    [realm transactionWithBlock:^{
        updateBlock();
    }];
}

#pragma mark - 删除

+ (void)deleteObj:(__kindof AJDBObject *)obj
{
    RLMRealm *realm = [[self sharedInstance] realm];
    [realm beginWriteTransaction];
    [realm deleteObject:obj];
    [realm commitWriteTransaction];
}

+ (void)deleteObjs:(NSArray<__kindof AJDBObject *> *)objs
{
    RLMRealm *realm = [[self sharedInstance] realm];
    [realm beginWriteTransaction];
    [realm deleteObjects:objs];
    [realm commitWriteTransaction];
}

#pragma mark - 查询

+ (NSArray<__kindof AJDBObject *> *)queryAllObj:(Class)clazz
{
    [AJDBManager checkClazz:clazz];
    
    RLMRealm *realm = [[self sharedInstance] realm];
    RLMResults<AJDBObject *> *queryResult = [clazz allObjectsInRealm:realm];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSInteger i = 0; i < queryResult.count; i ++) {
        
        AJDBObject *item = [queryResult objectAtIndex:i];
        
        [resultArray addObject:item];
    }
    
    return resultArray;
}

+ (NSArray<__kindof AJDBObject *> *)queryObjWithPredicate:(NSPredicate *)predicate targetClass:(Class)clazz
{
    [AJDBManager checkClazz:clazz];
    
    RLMRealm *realm = [[self sharedInstance] realm];
    RLMResults<AJDBObject *> *queryResult = [clazz objectsInRealm:realm withPredicate:predicate];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSInteger i = 0; i < queryResult.count; i ++) {
        
        AJDBObject *item = [queryResult objectAtIndex:i];
        
        [resultArray addObject:item];
    }
    
    return resultArray;
}

+ (NSArray<__kindof AJDBObject *> *)queryObjWithPredicate:(NSPredicate *)predicate sortFilter:(AJSortFilter *)sortFilter targetClass:(Class)clazz;
{
    [AJDBManager checkClazz:clazz];
    
    RLMRealm *realm = [[self sharedInstance] realm];
    RLMResults<AJDBObject *> *queryResult = [[clazz objectsInRealm:realm withPredicate:predicate]
                                             sortedResultsUsingProperty:sortFilter.sortPropertyName
                                             ascending:sortFilter.ascending];
    
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSInteger i = 0; i < queryResult.count; i ++) {
        
        AJDBObject *item = [queryResult objectAtIndex:i];
        
        [resultArray addObject:item];
    }
    
    return resultArray;
}

+ (__kindof AJDBObject *)queryObjWithPrimaryKeyValue:(id)primaryKey targetClass:(Class)clazz;
{
    [AJDBManager checkClazz:clazz];
    
    RLMRealm *realm = [[self sharedInstance] realm];
    AJDBObject *queryObj = [clazz objectInRealm:realm forPrimaryKey:primaryKey];
    
    return queryObj;
}

#pragma mark - 清空数据库
+ (void)clear
{
    RLMRealm *realm = [[self sharedInstance] realm];
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
}

@end
