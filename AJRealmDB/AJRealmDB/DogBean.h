//
//  DogBean.h
//  AJRealmDB
//
//  Created by AbooJan on 2016/11/7.
//  Copyright © 2016年 AbooJan. All rights reserved.
//

#import "AJDBObject.h"

@interface DogBean : AJDBObject
@property   NSInteger   ID;
@property   NSString    *name;
@end
RLM_ARRAY_TYPE(DogBean)
