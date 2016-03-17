//
//  AlertTipsViewController.h
//  OutsourcingProject
//
//  Created by LingLi on 16/2/23.
//  Copyright © 2016年 LingLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertTipsViewTool: UIViewController


+ (void)alertTipsViewWithTitle:(NSString *)title message:(NSString *)message;

+ (BOOL)isEmptyWillSubmit:(NSArray *)elementArrary;

@end
