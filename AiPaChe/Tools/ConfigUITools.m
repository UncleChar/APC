//
//  ConfigUITools.m
//  TestDemoByXhl
//
//  Created by LingLi on 15/11/24.
//  Copyright © 2015年 LingLi. All rights reserved.
//

#import "ConfigUITools.h"

@implementation ConfigUITools

//初始化index控制器的诸多按钮
/**
 *
 *  @param title     按钮的标题
 *  @param color     按钮的颜色
 *  @param size      标题的字号
 *  @param frame     按钮的位置
 *  @param superView 按钮的父视图
 */
+ (UIButton *)configButtonWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)size frame:(CGRect)frame superView:(UIView *)superView {

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.backgroundColor = color;
    btn.titleLabel.font = [UIFont systemFontOfSize:size];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:0];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = 1;
    [superView addSubview:btn];
    
    return btn;


}

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)balck A:(CGFloat)alpha {

    return [UIColor colorWithRed:red /255.0 green:green/255.0 blue:balck / 255.0 alpha:alpha];
}

+ (UIColor *)colorRandomly{

    return [UIColor colorWithHue:( arc4random() % 256 / 256.0 )
           saturation:( arc4random() % 128 / 256.0 ) + 0.5
           brightness:( arc4random() % 128 / 256.0 ) + 0.5
                alpha:1];
}

+ (void)sizeToScroll:(UIScrollView *)scroll withStandardElementMaxY:(CGFloat)maxY forStepsH:(CGFloat)stepsH{
    
//    OPLog(@"kContentHeight %f",kContentHeight);
//    OPLog(@"margin %f",stepsH);
//    OPLog(@"maxY %f",maxY);
    CGFloat t = kContentHeight;
    CGFloat margin = maxY - t;
//    OPLog(@"margin %f",margin);

    
    if (maxY > kContentHeight) {
        
        scroll.contentSize = CGSizeMake(kScreenWidth, maxY );
        
    }
    
    
}

+ (CGFloat)calculateTextHeight:(NSString *)text size:(CGSize)size font:(UIFont *)font
{
    // 文本计算矩形的方法
    /** 参数
     1 文本所在范围
     2 绘制选项,
     NSStringDrawingUsesLineFragmentOrigin
     NSStringDrawingUsesFontLeading 计算时使用行间距
     3 文本属性字典
     4 上下文
     */
    
    CGRect rect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName : font } context:nil];
    
    return rect.size.height;
}

+ (NSString *)returnDateStringWithDate:(NSDate *)date {


    NSDateFormatter *dff = [[NSDateFormatter alloc]init];

    dff.dateFormat = @"yyyy-MM-dd";

    NSString *dateaf = [dff stringFromDate:date];
  

    return dateaf;
}

+ (NSDate *)returnDateFromString:(NSString *)dateString {
    
    
    NSDateFormatter *dff = [[NSDateFormatter alloc]init];
    
    dff.dateFormat = @"yyyy-MM-dd HH:mm";
    
    
 
    
    NSDate *dateaf = [dff dateFromString:dateString];
    NSDate *dataa = [NSDate dateWithTimeInterval:8 *3600 sinceDate:dateaf];
    
    return dataa;
}


+ (BOOL)isEmptyWillSubmit:(NSArray *)elementArrary {

    
    for (id elem in elementArrary) {
        
        if ([elem isKindOfClass:[UIButton class]]) {
            
            UIButton *btn = (UIButton *)elem;
            
            if (btn.titleLabel.text.length == 0) {
                
                return YES;
                
            }
            
        }
        
        if ([elem isKindOfClass:[UITextField class]]) {
            
            UITextField *tf = (UITextField *)elem;
            
            if (tf.text.length == 0) {
                
                return YES;
                
            }
            
        }
        
        if ([elem isKindOfClass:[UITextView class]]) {
            
            UITextView *tf = (UITextView *)elem;
            
            if (tf.text.length == 0) {
                
                return YES;
                
            }
            
        }
        
        
    }

    return NO;

}

+ (void)locationNotificationWithID:(NSString *)loId withContent:(NSString *)content sinceDate:(NSDate *)tipsDate isRepeat:(BOOL)repeat {

    
    // iOS8的本地消息推送需要添加一段代码
    // systemVersion,运行的目标设备的系统版本号
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 8.0 ) {
        
        // 接收消息的类型:声音,消息体,角标
        UIUserNotificationType type = UIUserNotificationTypeSound |UIUserNotificationTypeAlert | UIUserNotificationTypeBadge;
        
        // 消息设置对象
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        
        // 1.程序注册一个消息设置对象
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    
    
    UILocalNotification *localNoti = [[UILocalNotification alloc] init];
    
    
    //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
    localNoti.soundName = UILocalNotificationDefaultSoundName;
    //设置通知的相关信息，这个很重要，可以添加一些标记性内容，方便以后区分和获取通知的信息
    
    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:loId,@"id", nil];
    localNoti.userInfo = infoDic;
    
    // 设置消息重复时间:(每隔24小时重复)
    if (repeat) {
       
        localNoti.repeatInterval = kCFCalendarUnitHour;
        
    }else {
    
        localNoti.repeatInterval = 0;
    }
    
    
    // 设置消息开始时间:(10秒钟之后开始推送)
//    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:5];
//    NSDate *dataa = [NSDate dateWithTimeInterval:<#(NSTimeInterval)#> sinceDate:<#(nonnull NSDate *)#>]
    //  根据时间间隔和指定的date,获得对应的时间
//    + (instancetype)dateWithTimeInterval:(NSTimeInterval)secsToBeAdded sinceDate:(NSDate *)date;

    localNoti.fireDate = tipsDate;
    
    // 设置消息体
    localNoti.alertBody = content;
    
    // 设置角标
    localNoti.applicationIconBadgeNumber = 1;
    
    // 设置推送声音 //prwa
//        localNoti.soundName = @"pie.wav";
    
    // 2.程序定制本地消息
    [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
    

}
@end
