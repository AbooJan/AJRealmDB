//
//  SortFilter.m
//  AJRealmDB
//
//  Created by AbooJan on 2016/11/7.
//  Copyright © 2016年 AbooJan. All rights reserved.
//

#import "AJSortFilter.h"

@implementation AJSortFilter

+ (instancetype)sortFilterWithPropertyName:(NSString *)propertyName ascending:(BOOL)ascending
{
    AJSortFilter *sortFilter = [[AJSortFilter alloc] init];
    sortFilter.sortPropertyName = propertyName;
    sortFilter.ascending = ascending;
    
    return sortFilter;
}
@end
