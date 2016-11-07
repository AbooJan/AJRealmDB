//
//  DBObject.h
//  AJRealmDB
//
//  Created by AbooJan on 2016/11/7.
//  Copyright © 2016年 AbooJan. All rights reserved.
//

#import <Realm/Realm.h>

@interface AJDBObject : RLMObject
/// 必须定义主键
+ (NSString *)primaryKey;
@end
