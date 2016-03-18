//
//  JustBackBtn.m
//  OutsourcingProject
//
//  Created by UncleChar on 16/2/20.
//  Copyright © 2016年 LingLi. All rights reserved.
//

#import "PublicTopElement.h"

@interface PublicTopElement ()

@end

@implementation PublicTopElement

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = 0;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(backBack)];
    leftItem.image = [UIImage imageNamed:@"backk"];
    self.navigationItem.leftBarButtonItem = leftItem;
//    self.view.backgroundColor = kBackColor;
    
    UIBarButtonItem *RIGHTItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:nil];
//    leftItem.image = [UIImage imageNamed:@"backk"];
    RIGHTItem.title = @"南京";
    self.navigationItem.rightBarButtonItem = RIGHTItem;
}

- (void)backBack {

    [self.navigationController popViewControllerAnimated:YES];
}


@end
