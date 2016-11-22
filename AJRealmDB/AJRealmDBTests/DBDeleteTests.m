//
//  DBDeleteTests.m
//  AJRealmDB
//
//  Created by aboojan on 2016/11/21.
//  Copyright © 2016年 AbooJan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestUserBean.h"
#import "AJDBManager.h"

@interface DBDeleteTests : XCTestCase

@end

@implementation DBDeleteTests

- (void)setUp {
    [super setUp];
    
    NSMutableArray *userArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i++) {
        TestUserBean *user = [TestUserBean new];
        user.ID = [NSString stringWithFormat:@"%ld", (long)(200+i)];
        user.name = [NSString stringWithFormat:@"TestUser_%ld", (long)i];
        [userArray addObject:user];
    }
    
    [AJDBManager writeObjArray:userArray];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testDeleteSingleItem
{
    TestUserBean *oldUser = [AJDBManager queryObjWithPrimaryKeyValue:@"201" targetClass:[TestUserBean class]];
    XCTAssert(oldUser != nil, @"没有数据");
    
    [AJDBManager deleteObj:oldUser];
    
    TestUserBean *newUser = [AJDBManager queryObjWithPrimaryKeyValue:@"201" targetClass:[TestUserBean class]];
    XCTAssert(newUser == nil, @"删除数据失败");
}

- (void)testDeleteItems
{
    NSArray *userArray = [AJDBManager queryAllObj:[TestUserBean class]];
    XCTAssert(userArray.count > 0, @"空数据");
    
    [AJDBManager deleteObjs:userArray];
    
    NSArray *changedUserArray = [AJDBManager queryAllObj:[TestUserBean class]];
    XCTAssert(changedUserArray.count == 0, @"批量数据删除失败");
}

@end
