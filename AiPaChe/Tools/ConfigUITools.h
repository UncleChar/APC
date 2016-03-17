//
//  ConfigUITools.h
//  TestDemoByXhl
//
//  Created by LingLi on 15/11/24.
//  Copyright © 2015年 LingLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigUITools : NSObject

+ (UIButton *)configButtonWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)size frame:(CGRect)frame superView:(UIView *)superView ;

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)balck A:(CGFloat)alpha;

+ (UIColor *)colorRandomly;

+ (void)sizeToScroll:(UIScrollView *)scroll withStandardElementMaxY:(CGFloat)maxY forStepsH:(CGFloat)stepsH;

+ (CGFloat)calculateTextHeight:(NSString *)text size:(CGSize)size font:(UIFont *)font;

+ (NSString *)returnDateStringWithDate:(NSDate *)date;

+ (NSDate *)returnDateFromString:(NSString *)dateString;

+ (BOOL)isEmptyWillSubmit:(NSArray *)elementArrary;

+ (void)locationNotificationWithID:(NSString *)loId withContent:(NSString *)content sinceDate:(NSDate *)tipsDate isRepeat:(BOOL)repeat;
@end
