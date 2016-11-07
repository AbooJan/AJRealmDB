//
//  UpdateViewController.h
//  AJRealmDB
//
//  Created by AbooJan on 2016/11/7.
//  Copyright © 2016年 AbooJan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentBean.h"

@protocol UpdateViewControllerDelegate <NSObject>

- (void)confirmUpdate;

@end

@interface UpdateViewController : UIViewController
@property (nonatomic, strong) StudentBean *studentBean;

@property (nonatomic, assign) id<UpdateViewControllerDelegate> delegate;
@end
