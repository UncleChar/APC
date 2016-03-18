//
//  MainViewController.h
//  AiPaChe
//
//  Created by LingLi on 16/3/17.
//  Copyright © 2016年 Char. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
@interface MainViewController : UIViewController

@property (nonatomic , strong) NSString  *apcRole;


- (NSString *)distanceBetweenCoordinateA:(CLLocationCoordinate2D)coorA toCoordinateB:(CLLocationCoordinate2D)coorB;

- (void) startSearchTargetWithKeyword:(NSString *)target scope:(int)scope countShow:(int)count  encireleLocation:(CLLocationCoordinate2D)coor;

- (BMKPinAnnotationView *)customPaopaoViewForAnnotation:(id<BMKAnnotation>)annotation;
@end
