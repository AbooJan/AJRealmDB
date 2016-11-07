//
//  SortFilter.h
//  AJRealmDB
//
//  Created by AbooJan on 2016/11/7.
//  Copyright © 2016年 AbooJan. All rights reserved.
//
//  排序过滤
//

#import <Foundation/Foundation.h>

@interface AJSortFilter : NSObject
@property (nonatomic, copy) NSString *sortPropertyName;
/// 是否升序
@property (nonatomic, assign) BOOL ascending;

+ (instancetype)sortFilterWithPropertyName:(NSString *)propertyName ascending:(BOOL)ascending;

@end
