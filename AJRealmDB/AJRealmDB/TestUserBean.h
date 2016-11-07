//
//  TestUserBean.h
//  AJRealmDB
//
//  Created by AbooJan on 2016/11/7.
//  Copyright © 2016年 AbooJan. All rights reserved.
//

#import "AJDBObject.h"

@interface TestUserBean : AJDBObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@end

RLM_ARRAY_TYPE(TestUserBean)
