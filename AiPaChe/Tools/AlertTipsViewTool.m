//
//  AlertTipsViewController.m
//  OutsourcingProject
//
//  Created by LingLi on 16/2/23.
//  Copyright © 2016年 LingLi. All rights reserved.
//

#import "AlertTipsViewTool.h"

@implementation AlertTipsViewTool


+ (void)alertTipsViewWithTitle:(NSString *)title message:(NSString *)message {


//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//    
//    
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        
//        
//        
//    }];
//
//    [alertController addAction:okAction];
//    
//    [AlertTipsViewTool  presentViewController:alertController animated:YES completion:nil];

}

+ (BOOL)isEmptyWillSubmit:(NSArray *)elementArrary {
    
    
    for (id elem in elementArrary) {
        
        if ([elem isKindOfClass:[UIButton class]]) {
            
            UIButton *btn = (UIButton *)elem;
            
            if (btn.titleLabel.text.length == 0) {
                [self showTips];
                return YES;
                
            }
            
        }
        
        if ([elem isKindOfClass:[UITextField class]]) {
            
            UITextField *tf = (UITextField *)elem;
            
            if (tf.text.length == 0) {
                [self showTips];
                return YES;
                
            }
            
        }
        
        if ([elem isKindOfClass:[UITextView class]]) {
            
            UITextView *tf = (UITextView *)elem;
            
            if (tf.text.length == 0) {
                [self showTips];
                return YES;
                
            }
            
        }
        
        
    }
    
    return NO;
    
}

+ (void)showTips{

    
    [SVProgressHUD showErrorWithStatus:@"您有信息未填哦！"];

}

@end
