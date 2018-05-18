//
//  DatabaseTestViewController.m
//  AJRealmDB
//
//  Created by AbooJan on 2016/11/7.
//  Copyright © 2016年 AbooJan. All rights reserved.
//

#import "DatabaseTestViewController.h"
#import "StudentBean.h"
#import "UpdateViewController.h"
#import "QueryDataViewController.h"
#import "NestedObjTestViewController.h"
#import "AJDBManager.h"

#define MAIN_STORYBOARD [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]

@interface DatabaseTestViewController () <UITableViewDataSource, UITableViewDelegate, UpdateViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *studentArray;

@property (nonatomic, assign) NSInteger itemCount;
@end

@implementation DatabaseTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
}

- (void)initData
{
    
    [self refreshData];
    
    if (self.studentArray) {
        self.itemCount = self.studentArray.count;
    }
}

- (void)initView
{
    //
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.studentArray.count;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"testCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1001];
    UILabel *ageLabel = (UILabel *)[cell viewWithTag:1002];
    UILabel *heightLabel = (UILabel *)[cell viewWithTag:1003];
    UISegmentedControl *check = (UISegmentedControl *)[cell viewWithTag:1004];
    
    if (self.studentArray.count > 0) {
        StudentBean *student = self.studentArray[indexPath.row];
        nameLabel.text =  student.name;
        ageLabel.text = [NSString stringWithFormat:@"%ld", student.age];
        heightLabel.text = [NSString stringWithFormat:@"%.2f", student.height];
        
        if (student.checked) {
            check.selectedSegmentIndex = 0;
        }else{
            check.selectedSegmentIndex = 1;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    StudentBean *student = self.studentArray[indexPath.row];
    
    
    UpdateViewController *updateVC = [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:@"UpdateViewController"];
    updateVC.studentBean = student;
    updateVC.delegate = self;
    
    [self.navigationController pushViewController:updateVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        StudentBean *student = self.studentArray[indexPath.row];
        [self deleteWithObj:student];
    }
}

- (void)confirmUpdate
{
    [self refreshData];
}

#pragma mark - <事件>

#pragma mark 查询所有数据
- (void)refreshData
{
    self.studentArray = [AJDBManager queryAllObj:[StudentBean class]];
    
    [self.tableView reloadData];
}

#pragma mark 查询插入数据
- (void)addBarItemClick
{
    StudentBean *student = [[StudentBean alloc] init];
    student.ID = 1000 + self.itemCount;
    student.name = [NSString stringWithFormat:@"学生%ld", student.ID];
    student.age = 20 + self.itemCount;
    student.height = 160.0 + self.itemCount;
    
    if ((self.itemCount % 2) == 0) {
        student.checked = YES;
    }else{
        student.checked = NO;
    }
    
    [AJDBManager writeObj:student];
    
    self.itemCount ++;
    
    [self refreshData];
}

#pragma mark 查询数据
- (void)queryData
{
    QueryDataViewController *queryVC = [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:@"QueryDataViewController"];
    [self.navigationController pushViewController:queryVC animated:YES];
}

#pragma mark 清空数据
- (void)cleanData
{
    [AJDBManager clear];
    
    [self refreshData];
}

#pragma mark 删除数据
- (void)deleteWithObj:(StudentBean *)student
{
    // 根据obj删除
    [AJDBManager deleteObj:student];
    [self refreshData];
    
}

#pragma mark - action
- (IBAction)addBtnClick:(id)sender
{
    [self addBarItemClick];
}

- (IBAction)manyAddBtnClick:(id)sender
{
    // 批量添加
    
    NSMutableArray *studentArray = [NSMutableArray array];
    for (NSInteger i = 2000; i < 2010;  i ++) {
        
        StudentBean *student = [[StudentBean alloc] init];
        student.ID = i;
        student.name = [NSString stringWithFormat:@"二学生%ld", student.ID];
        student.age = 20 + self.itemCount;
        student.height = 120.0 + self.itemCount;
        
        if ((i % 2) == 0) {
            student.checked = YES;
        }else{
            student.checked = NO;
        }
        
        self.itemCount ++;
        
        [studentArray addObject:student];
    }
    
    [AJDBManager writeObjs:studentArray];
    
    [self refreshData];
}

- (IBAction)queryBtnClick:(id)sender
{
    [self queryData];
}
- (IBAction)cleanBtnClick:(id)sender
{
    [self cleanData];
}
- (IBAction)nestedBtnClick:(id)sender
{
    NestedObjTestViewController *nestedVC = [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:@"NestedObjTestViewController"];
    [self.navigationController pushViewController:nestedVC animated:YES];
}

@end
