//
//  MultiThreadViewController.m
//  AJRealmDB
//
//  Created by AbooJan on 2016/11/7.
//  Copyright © 2016年 AbooJan. All rights reserved.
//

#import "MultiThreadViewController.h"
#import "StudentBean.h"
#import "AJDBManager.h"

@interface MultiThreadViewController ()

@end

@implementation MultiThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"$Main$: %@", [NSThread currentThread]);
    
    [self thread1];
    [self thread2];
    
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        [self thread3];
    }];
    [thread start];
}

- (void)thread1
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"$$: %@", [NSThread currentThread]);
        
        StudentBean *student = [[StudentBean alloc] init];
        student.ID = 6001;
        student.name = [NSString stringWithFormat:@"学生%ld", student.ID];
        student.age = 26;
        student.height = 160.0 + 1;
        student.checked = NO;
        
        [AJDBManager writeObj:student];
    });
}

- (void)thread2
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"$$: %@", [NSThread currentThread]);
        
        StudentBean *student = [[StudentBean alloc] init];
        student.ID = 6601;
        student.name = [NSString stringWithFormat:@"学生%ld", student.ID];
        student.age = 24;
        student.height = 162.0 + 1;
        student.checked = YES;
        
        [AJDBManager writeObj:student];
    });
}

- (void)thread3
{
    NSLog(@"$$: %@", [NSThread currentThread]);
    
    NSArray *students = [AJDBManager queryAllObj:[StudentBean class]];
    for (StudentBean *student in students) {
        NSLog(@"%ld--%@", student.ID, student.name);
    }
}

@end
