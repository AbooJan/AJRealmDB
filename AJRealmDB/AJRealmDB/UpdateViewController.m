//
//  UpdateViewController.m
//  AJRealmDB
//
//  Created by AbooJan on 2016/11/7.
//  Copyright © 2016年 AbooJan. All rights reserved.
//

#import "UpdateViewController.h"
#import "DogBean.h"
#import "AJDBManager.h"

@interface UpdateViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *ageTF;

- (IBAction)updateBtnClick:(id)sender;

@end

@implementation UpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameTF.text = self.studentBean.name;
    self.ageTF.text = [NSString stringWithFormat:@"%ld", (long)self.studentBean.age];
}


- (IBAction)updateBtnClick:(id)sender
{

    
    [AJDBManager updateObj:^{
        
        
        self.studentBean.name = self.nameTF.text;
        self.studentBean.age = [self.ageTF.text integerValue];
        
    }];
    
    [self.delegate confirmUpdate];
    
    NSLog(@"更新成功~");
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 批量写入删除测试

- (IBAction)writeArrayBtnClick:(UIButton *)sender
{
    NSMutableArray *dogArray = [NSMutableArray array];
    for (int i = 0; i < 6; i++) {
        DogBean *dog1 = [[DogBean alloc] init];
        dog1.ID = 100+i;
        dog1.name = [NSString stringWithFormat:@"dog%ld", (long)(100+i)];
        
        [dogArray addObject:dog1];
    }
    
    [AJDBManager writeObjs:dogArray];
}

- (IBAction)deleteArrayBtnClick:(id)sender
{
    NSArray *dogArray = [AJDBManager queryAllObj:[DogBean class]];
    
    if (dogArray.count > 0) {
        [AJDBManager deleteObjs:dogArray];
    }
}

@end
