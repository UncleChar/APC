//
//  MyBMKPointAnnotation.h
//  AiPaChe
//
//  Created by UncleChar on 16/3/17.
//  Copyright © 2016年 Char. All rights reserved.
//


#import <BaiduMapAPI_Map/BMKPointAnnotation.h>

@interface APCPointAnnotation :BMKPointAnnotation


@property (nonatomic, assign) BOOL  isTouch;
@property (nonatomic, assign) NSInteger  orderNumber;
@property (nonatomic, assign) BOOL  isCustomerLocation;
@property (nonatomic, assign) BOOL  isProprietorSelected;
@property (nonatomic, strong) NSString  *distanceString;
@property (nonatomic, strong) NSString  *adressPhone;


@end
