//
//  AJDBConfig.h
//  RealmPro
//
//  Created by zbj on 2018/5/18.
//  Copyright © 2018年 qlchat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AJDBObject.h"

@interface AJDBConfig : NSObject

/// 数据库加密KEY
@property (nonatomic, strong, nullable) NSData *encryptKey;
/// 数据库版本
@property (nonatomic, assign) uint64_t dbVer;
/// 数据库版本合并处理回调
@property (nonatomic, copy, nullable) RLMMigrationBlock migrationBlock;

@end
