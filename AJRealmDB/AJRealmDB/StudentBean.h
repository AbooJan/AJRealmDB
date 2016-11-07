//
//  StudentBean.h
//  AJRealmDB
//
//  Created by AbooJan on 2016/11/7.
//  Copyright © 2016年 AbooJan. All rights reserved.
//

#import "AJDBObject.h"

@interface StudentBean : AJDBObject
@property   NSInteger   ID;
@property   NSString    *name;
@property   NSInteger   age;
@property   double     height;
@property   BOOL        checked;
@end
RLM_ARRAY_TYPE(StudentBean)
