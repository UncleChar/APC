//
//  MainViewController.m
//  AiPaChe
//
//  Created by LingLi on 16/3/17.
//  Copyright © 2016年 Char. All rights reserved.
//

#import "MainViewController.h"

#import "APCPointAnnotation.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
//#import <CoreGraphics/CoreGraphics.h>
//#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface MainViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate>
{
    BMKMapView *_mapView;
    
    BMKLocationService *_locService;
    
    NSString  *_myLocationName;

    BMKUserLocation *myLocation;
    BMKPoiSearch *_searcher;
    BMKPointAnnotation  *pointAnnotation2;
    
    APCPointAnnotation  *proprietorTouchTarget;
}

@end

@implementation MainViewController



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    self.navigationController.navigationBarHidden = 0;
    _mapView.delegate = self;
    _locService.delegate = self;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIBarButtonItem *RIGHTItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:nil];
    //    leftItem.image = [UIImage imageNamed:@"backk"];
    RIGHTItem.title = @"南京";
    self.navigationItem.rightBarButtonItem = RIGHTItem;
  
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _locService.delegate = nil;
    _searcher.delegate = nil;
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.title = @"爱啪车";
//    [self startLocation];
    [self setupMapView];//配置地图
    
    if ([self.apcRole isEqualToString:@"yezhu"]) {
        
        
    }else {
        
        [self startLocation];
        
    }
    

}

////拖动地图获取经纬
//- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
//{
//    NSLog(@"经度:%f 维度:%f",mapView.centerCoordinate.longitude,mapView.centerCoordinate.latitude);
//
//}

#pragma mark -- 配置地图
- (void)setupMapView
{
    _mapView = [[BMKMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];

    // 设置地图级别
    [_mapView setZoomLevel:19];
    
    [_mapView setMapType:BMKMapTypeStandard];
    
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
     _locService = [[BMKLocationService alloc] init];
    
}

#pragma mark -- 定位
- (void)startLocation
{
    NSLog(@"已进入定位系统");
   

    [_locService startUserLocationService];
    //    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;


    
}


#pragma mark --定位 Delegate
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}
/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
//- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
//{
//    [_mapView updateLocationData:userLocation];
//    NSLog(@"heading is %@",userLocation.heading);
//}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{

    myLocation = userLocation;
    
    
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = true;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = false;//精度圈是否显示
//    displayParam.locationViewImgName= @"icon";//定位图标名称
    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    [_mapView updateLocationViewWithParam:displayParam];
    
    
    [_mapView updateLocationData:userLocation];
    
    APCPointAnnotation* annotation = [[APCPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = myLocation.location.coordinate.latitude;
    coor.longitude = myLocation.location.coordinate.longitude;
    annotation.coordinate = coor;
    annotation.isCustomerLocation = YES;
    annotation.title = @"您当前的位置";
    [_mapView addAnnotation:annotation];
    NSLog(@" %lf",coor.longitude = myLocation.location.coordinate.longitude);
    
    [_locService stopUserLocationService];
    _searcher =[[BMKPoiSearch alloc]init];
    _searcher.delegate = self;
    [self startSearchTargetWithKeyword:@"停车场" scope:800 countShow:5 encireleLocation:coor];
    
}







#pragma mark --大头针 Delegate

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{

    NSLog(@"ddd     %ld",view.paopaoView.tag);
    

}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
 
    if ([annotation isKindOfClass:[APCPointAnnotation class]]) {
        
        return [self customPaopaoViewForAnnotation:annotation];
        
    }
    
    return nil;

}



/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
//{
//    [_mapView updateLocationData:userLocation];
//    
//    // 添加一个PointAnnotation
////    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
////    CLLocationCoordinate2D coor;
////    coor.latitude = userLocation.location.coordinate.latitude;
////    coor.longitude = userLocation.location.coordinate.longitude;
////    annotation.coordinate = coor;
////    annotation.title = @"我在这里";
////    [_mapView addAnnotation:annotation];
//    
//    myLocation = userLocation;
//
//    NSLog(@"经c度:%f  纬度:%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//
//    // 用户最新位置
//    CLLocation *location = [[CLLocation alloc]initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
//    
//    // 反地理编码(逆地理编码) : 把坐标信息转化为地址信息
//    // 地理编码 : 把地址信息转换为坐标信息
//    
//    // 地理编码类
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    // 参数1:用户位置
//    // 参数2:反地理编码完成之后的block
//    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//        if (error) {
//            NSLog(@"反地理编码失败");
//            return ;
//        }
//        
//        CLPlacemark *placeMark = [placemarks firstObject];
//        NSLog(@"国家:%@ 城市:%@ 区:%@ 具体位置:%@", placeMark.country, placeMark.locality, placeMark.subLocality, placeMark.name);
//        _myLocationName = placeMark.name;
//        
//
//        
//        
//        [_locService stopUserLocationService];
//        
//        return;
//    }];
//    // 停止定位
////    _mapView.showsUserLocation = NO;
//    
//    
//}



//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
       
        NSLog(@"yyy %@",poiResultList.poiInfoList);

        NSArray *poisArray = poiResultList.poiInfoList;
        NSInteger i = 0;
        for (BMKPoiInfo *poi in poisArray) {
            NSLog(@"%@", poi.name);
            i ++;
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(poi.pt.latitude, poi.pt.longitude);
            
            // 初始化大头针
            APCPointAnnotation* annotation = [[APCPointAnnotation alloc]init];

            annotation.coordinate = coordinate;
            annotation.orderNumber = i;
            annotation.title = poi.name;
            annotation.subtitle = poi.address;
            annotation.adressPhone = poi.phone;
            annotation.distanceString = [self distanceBetweenCoordinateA:coordinate toCoordinateB:myLocation.location.coordinate];
            [_mapView addAnnotation:annotation];
        }

        
       
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        
        UIAlertCategory *alert = [[UIAlertCategory alloc] initWithTitle:@"抱歉，未找到结果" WithMessage:@"是否重新检索"];
        
        [alert addButton:ALERT_BUTTON_OK WithTitle:@"是" WithAction:^(void *action) {
            NSLog(@"你点击了 index 为 0 的  好的");
            
//            [self setupMapView];//配置地图
//            
//            if ([self.apcRole isEqualToString:@"yezhu"]) {
//                
//                
//            }else {
//                
//                [self startLocation];
//                
//            }
        }];
        [alert addButton:ALERT_BUTTON_CANCEL WithTitle:@"否" WithAction:^(void *action) {
            NSLog(@"你点击了 index 为 1 的  取消");
        }];
        [alert show];
    }
}


- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"我的位置是" message:_myLocationName preferredStyle:UIAlertControllerStyleAlert];
    
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        
//    }];
//    [alertController addAction:okAction];
//    [self.navigationController presentViewController:alertController animated:YES completion:nil];
    
}

- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi*)mapPoi{

//        NSLog(@"caocaao%@", mapPoi.text);
//            if (proprietorTouchTarget) {
//    
//                [_mapView removeAnnotation:proprietorTouchTarget];
//            }
//
//        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(mapPoi.pt.latitude, mapPoi.pt.longitude);
//    
//        APCPointAnnotation *tt = [[APCPointAnnotation alloc]init];
//        // 初始化大头针
////        pointAnnotation2 = [[BMKPointAnnotation alloc]init];
//        //            CLLocationCoordinate2D coor;
//        tt.coordinate = coordinate;
//        tt.isProprietorSelected = YES;
//        tt.title = mapPoi.text;
//        [_mapView addAnnotation:tt];
////    }

}

- (void)startSearchTargetWithKeyword:(NSString *)target scope:(int)scope countShow:(int)count encireleLocation:(CLLocationCoordinate2D)coor {


    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = count;
    option.radius = scope;
    option.location = CLLocationCoordinate2DMake(coor.latitude,coor.longitude);
    option.keyword = target;
    
    BOOL flag = [_searcher poiSearchNearBy:option];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
//        [SVProgressHUD showSuccessWithStatus:@"周边检索发送成功"];
    }
    else
    {
        
        
        UIAlertCategory *alert = [[UIAlertCategory alloc] initWithTitle:@"检索周边失败" WithMessage:@"是否重新检索"];
        
        [alert addButton:ALERT_BUTTON_OK WithTitle:@"是" WithAction:^(void *action) {
            NSLog(@"你点击了 index 为 0 的  好的");
//            [self setupMapView];//配置地图
//            
//            if ([self.apcRole isEqualToString:@"yezhu"]) {
//                
//                
//            }else {
//                
//                [self startLocation];
//                
//            }
            
            [self startSearchTargetWithKeyword:@"停车场" scope:800 countShow:5 encireleLocation:coor];
            
        }];
        [alert addButton:ALERT_BUTTON_CANCEL WithTitle:@"否" WithAction:^(void *action) {
            NSLog(@"你点击了 index 为 1 的  取消");
        }];
        [alert show];
    }


}


- (NSString *)distanceBetweenCoordinateA:(CLLocationCoordinate2D)coorA toCoordinateB:(CLLocationCoordinate2D)coorB {

    
    BMKMapPoint pointDist = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(coorA.latitude,coorB.longitude));
    BMKMapPoint pointMyLo = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(coorB.latitude,coorB.longitude));
    CLLocationDistance distance = BMKMetersBetweenMapPoints(pointDist,pointMyLo);

    NSLog(@"dis  %f",distance);
    NSString *distanceString;
    
    if (distance < 1000) {
        
        distanceString = [NSString stringWithFormat:@"%dM",(int)distance];
        
    }else {
    
        distanceString = [NSString stringWithFormat:@"%.2fKM",distance / 1000];
        
    }

    return distanceString;

}


- (BMKPinAnnotationView *)customPaopaoViewForAnnotation:(id<BMKAnnotation>)annotation {
    
    BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
    APCPointAnnotation *customPA = (APCPointAnnotation *)annotation;

    if (customPA.isCustomerLocation) {
        
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        //            newAnnotationView.image = [UIImage imageNamed:@"ic_map_mode_category_merchants_normal.png"];
    }else {
        
        newAnnotationView.pinColor = BMKPinAnnotationColorGreen;
        //            newAnnotationView.image = [UIImage imageNamed:@"ic_map_mode_category_merchants_normal.png"];
    }
    
    newAnnotationView.animatesDrop = YES;
    

    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(customPA.coordinate.latitude,customPA.coordinate.longitude));
    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(myLocation.location.coordinate.latitude,myLocation.location.coordinate.longitude));
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);

    CGFloat  popViewW = kScreenWidth - 60;
    CGFloat popViewH = (kScreenHeight - 64) / 3;
     CGFloat levelH = popViewH / 4.5;
    UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,popViewW, popViewH)];
    
    
    
    
    //        if (customPA.isTouch) {
    //            //            statements
    //           popView.backgroundColor = kBtnColor;
    //        }else {
    //
    //            popView.backgroundColor = kBackColor;
    //        }
    popView.backgroundColor = [UIColor whiteColor];
    [popView.layer setMasksToBounds:YES];
    [popView.layer setCornerRadius:3.0];
    popView.alpha = 0.9; //
    //设置弹出气泡图片 //
    //        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:tt.imgPath]];
    // image.frame = CGRectMake(0, 160, 50, 60);
    // [popView addSubview:image];
    //自定义气泡的内容，添加子控件在popView上
    //242 36 90
    UILabel *olderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 2, levelH - 4, levelH - 4)];
    [olderLabel.layer setMasksToBounds:YES];
    [olderLabel.layer setCornerRadius:(levelH - 4)/2];
    olderLabel.text = [NSString stringWithFormat:@"%ld",customPA.orderNumber];
    olderLabel.textColor = [UIColor whiteColor];
    olderLabel.backgroundColor = [ConfigUITools colorWithR:242 G:36 B:90 A:1];
    olderLabel.textAlignment = 1;
    [popView addSubview:olderLabel];
    
    UILabel *driverName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(olderLabel.frame) + 5, 0, popViewW / 2 - CGRectGetMaxX(olderLabel.frame) - 15  , levelH)];
    driverName.text = customPA.title;
//    [NSString stringWithFormat:@" %.2f",distance] ;
    driverName.numberOfLines = 0;
    driverName.backgroundColor = [UIColor clearColor];
    driverName.font = [UIFont systemFontOfSize:13];
    driverName.textColor = [UIColor blackColor];
    driverName.textAlignment = NSTextAlignmentLeft;
    [popView addSubview:driverName];
    
    UILabel *dis = [[UILabel alloc]initWithFrame:CGRectMake(popViewW / 2 + 5, 0, popViewW / 2 - 40  , levelH)];
    dis.text = @"停车场距离目的地";
    //    [NSString stringWithFormat:@" %.2f",distance] ;
//    dis.numberOfLines = 0;
    dis.backgroundColor = [UIColor clearColor];
    dis.font = [UIFont systemFontOfSize:11];
    dis.textColor = [UIColor grayColor];
    dis.textAlignment = NSTextAlignmentLeft;
    [popView addSubview:dis];
    
    UILabel *disnUMBER = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dis.frame) + 5, 0, 60  , levelH)];
    disnUMBER.text = [self distanceBetweenCoordinateA:customPA.coordinate toCoordinateB:myLocation.location.coordinate];

    disnUMBER.numberOfLines = 0;
    disnUMBER.backgroundColor = [UIColor clearColor];
    disnUMBER.font = [UIFont systemFontOfSize:13];
    disnUMBER.textColor = [UIColor blackColor];
    disnUMBER.textAlignment = 0;
    [popView addSubview:disnUMBER];
    
    UIButton *reserveBtn = [[UIButton alloc]initWithFrame:CGRectMake(0 , levelH * 3.5, popViewW, levelH)];
    [reserveBtn setTitle:@"抢车位" forState:UIControlStateNormal];
    reserveBtn.backgroundColor = [ConfigUITools colorWithR:53 G:177 B:40 A:1];
    reserveBtn.titleLabel.numberOfLines = 0;
    reserveBtn.tag = customPA.orderNumber;
    [reserveBtn addTarget:self action:@selector(reserveBtn:) forControlEvents:UIControlEventTouchUpInside];

    [popView addSubview:reserveBtn];
    
//    UILabel *carName = [[UILabel alloc]initWithFrame:CGRectMake(8, 30, 180, 30)];
//    carName.text = annotation.subtitle;
//    carName.backgroundColor = [UIColor clearColor];
//    carName.font = [UIFont systemFontOfSize:11];
//    carName.textColor = [UIColor lightGrayColor];
//    carName.textAlignment = NSTextAlignmentLeft;
//    [popView addSubview:carName];
//    if (annotation.subtitle) {
//        UIButton *searchBn = [[UIButton alloc]initWithFrame:CGRectMake(170, 0, 50, 60)];
//        [searchBn setTitle:@"查看路线" forState:UIControlStateNormal];
//        searchBn.backgroundColor = [ConfigUITools colorWithR:53 G:177 B:40 A:1];
//        searchBn.titleLabel.numberOfLines = 0;
//        //            [searchBn addTarget:self action:@selector(searchLine)];
//        [popView addSubview:searchBn];
//    
//    }
    
    BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
    pView.frame = popView.frame;
    ((BMKPinAnnotationView*)newAnnotationView).paopaoView = nil;
    pView.tag = 1001;
    ((BMKPinAnnotationView*)newAnnotationView).paopaoView = pView;

    return newAnnotationView;
    
}


- (void)reserveBtn:(UIButton *)sender {


    NSLog(@"hhh c %ld",sender.tag);
    

}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"我的位置是" message:_myLocationName preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alertController addAction:okAction];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

- (void)dealloc
{
    [_locService stopUserLocationService];
    if(_mapView){
        _mapView = nil;
    }
}


@end
