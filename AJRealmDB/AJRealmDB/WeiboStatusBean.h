//
//  WeiboStatusBean.h
//  AJRealmDB
//
//  Created by AbooJan on 2016/11/7.
//  Copyright © 2016年 AbooJan. All rights reserved.
//

#import "AJDBObject.h"
#import "TestUserBean.h"
#import "CommentBean.h"

@interface WeiboStatusBean : AJDBObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) RLMArray<TestUserBean *><TestUserBean> *parseUsers;

@property (nonatomic, strong) RLMArray<CommentBean *><CommentBean> *comments;

@end

