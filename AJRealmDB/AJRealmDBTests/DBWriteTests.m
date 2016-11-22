//
//  DBWriteTests.m
//  AJRealmDB
//
//  Created by aboojan on 2016/11/17.
//  Copyright © 2016年 AbooJan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StudentBean.h"
#import "AJDBManager.h"

@interface DBWriteTests : XCTestCase

@end

@implementation DBWriteTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
}

- (void)testPerformanceExample {
    
    [self measureBlock:^{
        //
    }];
}

- (void)testSingleItemWrite
{
    StudentBean *student = [[StudentBean alloc] init];
    student.ID = 1000;
    student.name = [NSString stringWithFormat:@"学生%ld", student.ID];
    student.age = 22;
    student.height = 160.0;
    student.checked = NO;
    
    [AJDBManager writeObj:student];
    
    // 验证--主键查询
    StudentBean *savedStudent = [AJDBManager queryObjWithPrimaryKeyValue:@(1000) targetClass:[StudentBean class]];
    
    XCTAssert(savedStudent != nil, @"数据写入失败");
}

- (void)testManyItemsWrite
{
    NSMutableArray *studentArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 20; i++) {
        StudentBean *student = [[StudentBean alloc] init];
        student.ID = 2000 + i;
        student.name = [NSString stringWithFormat:@"学生%ld", student.ID];
        student.age = 20 + i;
        student.height = 160.0 + i;
        student.checked = (i%2 == 0);
        
        [studentArray addObject:student];
    }
    
    [AJDBManager writeObjArray:studentArray];
    
    // 验证--条件查询
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ID >= 2000"];
    NSArray *queryResult = [AJDBManager queryObjWithPredicate:predicate targetClass:[StudentBean class]];
    
    XCTAssert(queryResult.count >= 20, @"批量输入写入失败!");
}

@end
