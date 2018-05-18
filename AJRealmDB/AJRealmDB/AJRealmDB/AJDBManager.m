//
//  AJDatabaseManager.m
//  AJRealmDB
//
//  Created by AbooJan on 2016/11/7.
//  Copyright © 2016年 AbooJan. All rights reserved.
//

#import "AJDBManager.h"

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
        
    });
    
    return instance;
}


+ (void)setupConfigInfo:(AJDBConfig *)cfg
{
    if (cfg == nil) {
        return;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 数据库配置
        RLMRealmConfiguration *rlmCfg = [RLMRealmConfiguration defaultConfiguration];
        rlmCfg.schemaVersion = cfg.dbVer;
        rlmCfg.migrationBlock = cfg.migrationBlock;
        
        if (cfg.encryptKey.length > 0) {
            rlmCfg.encryptionKey = cfg.encryptKey;
        }
        
        [self sharedInstance].realmConfig = rlmCfg;
    });
}

+ (void)configSecurityKey:(NSData *)secKey
{
    if (secKey == nil || [secKey length] == 0) {
        return;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 数据库配置
        [self sharedInstance].realmConfig = [RLMRealmConfiguration defaultConfiguration];
        [self sharedInstance].realmConfig.encryptionKey = secKey;
    });
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

+ (void)writeObjs:(NSArray<__kindof AJDBObject *> *)objs
{
    RLMRealm *realm = [[self sharedInstance] realm];
    [realm beginWriteTransaction];
    [realm addOrUpdateObjects:objs];
    [realm commitWriteTransaction];
}

#pragma mark - 更新

+ (void)updateObj:(void (^)(void))updateBlock
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

+ (void)deleteObjWithPrimaryKey:(id)primaryKey targetClass:(Class)clazz
{
    AJDBObject *obj = [self queryObjWithPrimaryKey:primaryKey targetClass:clazz];
    if (obj) {
        [self deleteObj:obj];
    }
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

+ (NSArray<__kindof AJDBObject *> *)queryObjsWithPredicate:(NSPredicate *)predicate targetClass:(Class)clazz
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

+ (NSArray<__kindof AJDBObject *> *)queryObjsWithPredicate:(NSPredicate *)predicate sortFilter:(AJSortFilter *)sortFilter targetClass:(Class)clazz;
{
    [AJDBManager checkClazz:clazz];
    
    RLMRealm *realm = [[self sharedInstance] realm];
    
    RLMResults<AJDBObject *> *queryResult = [[clazz objectsInRealm:realm withPredicate:predicate]
                                             sortedResultsUsingKeyPath:sortFilter.sortPropertyName
                                             ascending:sortFilter.ascending];
    
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSInteger i = 0; i < queryResult.count; i ++) {
        
        AJDBObject *item = [queryResult objectAtIndex:i];
        
        [resultArray addObject:item];
    }
    
    return resultArray;
}

+ (__kindof AJDBObject *)queryObjWithPrimaryKey:(id)primaryKey targetClass:(Class)clazz;
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
