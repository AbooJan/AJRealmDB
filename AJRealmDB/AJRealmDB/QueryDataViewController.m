//
//  QueryDataViewController.m
//  AJRealmDB
//
//  Created by AbooJan on 2016/11/7.
//  Copyright © 2016年 AbooJan. All rights reserved.
//

#import "QueryDataViewController.h"
#import "StudentBean.h"
#import "AJDBManager.h"

@interface QueryDataViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *studentArray;

@property (weak, nonatomic) IBOutlet UITextField *primaryKeyTF;
- (IBAction)primaryKeyBtnClick:(id)sender;
- (IBAction)prdicateBtnClick:(id)sender;

@end

@implementation QueryDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.studentArray = [NSMutableArray array];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.studentArray.count;
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
}


- (IBAction)primaryKeyBtnClick:(id)sender
{
    // 主键查询
    
    [self.view endEditing:YES];
    
    NSString *primaryKey = self.primaryKeyTF.text;
    if (primaryKey != nil && primaryKey.length > 0) {
        
        StudentBean *student = [AJDBManager queryObjWithPrimaryKeyValue:@([primaryKey integerValue]) targetClass:[StudentBean class]];
        
        if (student) {
            
            [self.studentArray removeAllObjects];
            
            [self.studentArray addObject:student];
            
            [self.tableView reloadData];
            
        }else{
            NSLog(@"没有找到");
        }
    }
}

- (IBAction)prdicateBtnClick:(id)sender
{
    // 添加查询
    
    [self.view endEditing:YES];
    
    // 不排序的查询
//    NSPredicate *query1 = [NSPredicate predicateWithFormat:@"age > %d", 25];
//    NSArray *queryResult = [AJDBManager queryObjWithPredicate:query1 targetClass:[StudentBean class]];
//    
//    if (queryResult.count > 0) {
//        [self.studentArray removeAllObjects];
//        
//        [self.studentArray addObjectsFromArray:queryResult];
//        
//        [self.tableView reloadData];
//    }
    
    // 排序查询
    NSPredicate *query2 = [NSPredicate predicateWithFormat:@"height >= %f", 166.0f];
    AJSortFilter *sortFilter = [AJSortFilter sortFilterWithPropertyName:@"age" ascending:NO];
    NSArray *queryResult = [AJDBManager queryObjWithPredicate:query2 sortFilter:sortFilter targetClass:[StudentBean class]];
    
    if (queryResult.count > 0) {
        [self.studentArray removeAllObjects];
        
        [self.studentArray addObjectsFromArray:queryResult];
        
        [self.tableView reloadData];
    }
    
}
@end
