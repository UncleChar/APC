//
//  AuthcodeView.h
//  OutsourcingProject
//
//  Created by LingLi on 16/3/3.
//  Copyright © 2016年 LingLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthcodeView : UIView

@property (strong, nonatomic) NSArray *dataArray;//字符素材数组

@property (strong, nonatomic) NSMutableString *authCodeStr;//验证码字符串

@end
