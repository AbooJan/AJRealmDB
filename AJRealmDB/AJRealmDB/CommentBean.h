//
//  CommentBean.h
//  AJRealmDB
//
//  Created by AbooJan on 2016/11/7.
//  Copyright © 2016年 AbooJan. All rights reserved.
//

#import "AJDBObject.h"
#import "TestUserBean.h"

@interface CommentBean : AJDBObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) TestUserBean *user;
@end

RLM_ARRAY_TYPE(CommentBean)
