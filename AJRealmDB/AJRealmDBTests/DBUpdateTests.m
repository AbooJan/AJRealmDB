//
//  DBUpdateTests.m
//  AJRealmDB
//
//  Created by aboojan on 2016/11/20.
//  Copyright © 2016年 AbooJan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DogBean.h"
#import "AJDBManager.h"

@interface DBUpdateTests : XCTestCase

@end

@implementation DBUpdateTests

- (void)setUp {
    [super setUp];
    
    NSMutableArray *dogs = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i++) {
        
        DogBean *dog = [DogBean new];
        dog.ID = 1000 + i;
        dog.name = [NSString stringWithFormat:@"dog%ld", (long)i];
        
        [dogs addObject:dog];
    }
    [AJDBManager writeObjArray:dogs];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
    [self testSignleItemUpdate];
    [self testManyItemsUpdate];
}

- (void)testPerformanceExample {

    [self measureBlock:^{
        //
    }];
}

- (void)testSignleItemUpdate
{
    DogBean *oldDog = [AJDBManager queryObjWithPrimaryKeyValue:@(1001) targetClass:[DogBean class]];
    
    [AJDBManager updateObj:^{
        oldDog.name = @"Peter";
    }];
    
    //---
    DogBean *newDog = [AJDBManager queryObjWithPrimaryKeyValue:@(1001) targetClass:[DogBean class]];
    NSString *newName = newDog.name;
    
    XCTAssert([newName isEqualToString:@"Peter"], @"数据更新失败!");
}

- (void)testManyItemsUpdate
{
    NSArray *oldAllDogs = [AJDBManager queryAllObj:[DogBean class]];
    [AJDBManager updateObj:^{
        for (NSInteger i = 5; i < 10; i++) {
            DogBean *dog = oldAllDogs[i];
            
            dog.name = [NSString stringWithFormat:@"Sheil%ld", i];
        }
    }];
    
    //---
    NSArray *newAllDogs = [AJDBManager queryAllObj:[DogBean class]];
    
    BOOL isChange = YES;
    for (NSInteger i = 5; i < 10; i++) {
        DogBean *newDog = newAllDogs[i];
        
        isChange = [newDog.name containsString:@"Sheil"];
        
        if (!isChange) {
            break;
        }
    }
    
    XCTAssert(isChange, @"批量修改数据失败!");
}

@end
