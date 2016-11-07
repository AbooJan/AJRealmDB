//
//  NestedObjTestViewController.m
//  AJRealmDB
//
//  Created by AbooJan on 2016/11/7.
//  Copyright © 2016年 AbooJan. All rights reserved.
//

#import "NestedObjTestViewController.h"
#import "WeiboStatusBean.h"
#import "AJDBManager.h"


@interface NestedObjTestViewController ()
- (IBAction)writeBtnClick:(id)sender;
- (IBAction)readBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *showContentTV;

@property (nonatomic, strong) WeiboStatusBean *weiboStatus;

@end

@implementation NestedObjTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
}

- (void)initData
{
    
    TestUserBean *user1 = [[TestUserBean alloc] init];
    user1.ID = @"601";
    user1.name = @"用户1";
    
    TestUserBean *user2 = [[TestUserBean alloc] init];
    user2.ID = @"602";
    user2.name = @"用户2";
    
    
    CommentBean *comment1 = [[CommentBean alloc] init];
    comment1.ID = @"301";
    comment1.content = @"这是评论内容1";
    comment1.user = user1;
    
    CommentBean *comment2 = [[CommentBean alloc] init];
    comment2.ID = @"302";
    comment2.content = @"这是评论内容2";
    comment2.user = user2;
    
    
    self.weiboStatus = [[WeiboStatusBean alloc] init];
    self.weiboStatus.ID = @"1001";
    self.weiboStatus.content = @"这是测试信息";
    
    [self.weiboStatus.parseUsers addObject:user1];
    [self.weiboStatus.parseUsers addObject:user2];
    
    [self.weiboStatus.comments addObject:comment1];
    [self.weiboStatus.comments addObject:comment2];
}


- (IBAction)writeBtnClick:(id)sender
{
    [AJDBManager writeObj:self.weiboStatus];
}

- (IBAction)readBtnClick:(id)sender
{
    NSArray *weiboArray = [AJDBManager queryAllObj:[WeiboStatusBean class]];
    
    WeiboStatusBean *weibo = weiboArray[0];
    
    self.showContentTV.text = [weibo description];
}
@end
