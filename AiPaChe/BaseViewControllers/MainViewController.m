//
//  MainViewController.m
//  AiPaChe
//
//  Created by LingLi on 16/3/17.
//  Copyright © 2016年 Char. All rights reserved.
//

#import "MainViewController.h"
#import "MyBMKPointAnnotation.h"

// 支付信息配置文件
#import "PartnerConfig.h"

// 数据签名文件
#import "DataSigner.h"

// 订单
#import "Order.h"
// 支付sdk
#import <AlipaySDK/AlipaySDK.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
@interface MainViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate>
{
    BMKMapView *_mapView;
    
    BMKLocationService *_locService;
    
    NSString  *_myLocationName;
    
    BMKUserLocation *locationMy;
    BMKPoiSearch *_searcher;
    BMKPointAnnotation  *pointAnnotation2;
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
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self startLocation];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化地图
    [self setupMapView];
    
    

    
    
    
    
    
    
//    self.view.backgroundColor = [UIColor purpleColor];
//    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 200, 100, 40)];
//    [btn setTitle:@"支付·" forState:UIControlStateNormal];
//    [self.view addSubview:btn];
//    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

////拖动地图获取经纬
//- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
//{
//    NSLog(@"经度:%f 维度:%f",mapView.centerCoordinate.longitude,mapView.centerCoordinate.latitude);
//
//}


- (void)setupMapView
{
    _mapView = [[BMKMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    _locService = [[BMKLocationService alloc] init];
    // 设置地图级别
    [_mapView setZoomLevel:15];
    
    [_mapView setMapType:BMKMapTypeStandard];
  
    
    [self.view addSubview:_mapView];
    
}

//开启定位
- (void)startLocation
{
    NSLog(@"已进入定位系统");
    [_locService startUserLocationService];
//    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    
}


#pragma mark locationSerce Delegate
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}


/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {


    
    if ([annotation isKindOfClass:[MyBMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
//        newAnnotationView.image
        
        MyBMKPointAnnotation *tt = (MyBMKPointAnnotation *)annotation;
        NSLog(@"vxsqqq      ---     %@",tt.subtitle);
//        //判断类别，需要添加不同类别，来赋予不同的标注图片
//        if (tt.profNumber == 100000) { newAnnotationView.image = [UIImage imageNamed:@"ic_map_mode_category_merchants_normal.png"]; }else if (tt.profNumber == 100001){ }
        //设定popView的高度，根据是否含有缩略图
        double popViewH = 60;
        if (annotation.subtitle == nil) {
//            popViewH = 38;
        }

        BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(tt.coordinate.latitude,tt.coordinate.longitude));
        BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(locationMy.location.coordinate.latitude,locationMy.location.coordinate.longitude));
        CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
        
//
//        BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(tt.coordinate.latitude,tt.coordinate.longitude));
//        BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(38.915,115.404));
//        CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
//        
//       BMKMapPoint point3 = BMKMapPointForCoordinate(12);
        UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth-100, popViewH)];
        if (tt.isTouch) {
            //            statements
           popView.backgroundColor = kBtnColor;
        }else {
        
            popView.backgroundColor = kBackColor;
        }
        
        [popView.layer setMasksToBounds:YES];
        [popView.layer setCornerRadius:3.0];
        popView.alpha = 0.9; //
        //设置弹出气泡图片 //
//        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:tt.imgPath]];
        // image.frame = CGRectMake(0, 160, 50, 60);
        // [popView addSubview:image];
        //自定义气泡的内容，添加子控件在popView上
        
        UILabel *driverName = [[UILabel alloc]initWithFrame:CGRectMake(8, 4, 160, 30)];
        driverName.text =[NSString stringWithFormat:@" %.2f",distance] ;
        driverName.numberOfLines = 0;
        driverName.backgroundColor = [UIColor clearColor];
        driverName.font = [UIFont systemFontOfSize:15];
        driverName.textColor = [UIColor blackColor];
        driverName.textAlignment = NSTextAlignmentLeft;
        [popView addSubview:driverName];
        UILabel *carName = [[UILabel alloc]initWithFrame:CGRectMake(8, 30, 180, 30)];
        carName.text = annotation.subtitle;
        carName.backgroundColor = [UIColor clearColor];
        carName.font = [UIFont systemFontOfSize:11];
        carName.textColor = [UIColor lightGrayColor];
        carName.textAlignment = NSTextAlignmentLeft;
        [popView addSubview:carName];
        if (annotation.subtitle) {
            UIButton *searchBn = [[UIButton alloc]initWithFrame:CGRectMake(170, 0, 50, 60)];
            [searchBn setTitle:@"查看路线" forState:UIControlStateNormal];
            searchBn.backgroundColor = [UIColor greenColor];
            searchBn.titleLabel.numberOfLines = 0;
//            [searchBn addTarget:self action:@selector(searchLine)];
            [popView addSubview:searchBn]; }
        BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
        pView.frame = CGRectMake(0, 0, kScreenWidth-100, popViewH);
        ((BMKPinAnnotationView*)newAnnotationView).paopaoView = nil; 
        ((BMKPinAnnotationView*)newAnnotationView).paopaoView = pView;

        
        return newAnnotationView;
    }
    return nil;

}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    
    // 添加一个PointAnnotation
//    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
//    CLLocationCoordinate2D coor;
//    coor.latitude = userLocation.location.coordinate.latitude;
//    coor.longitude = userLocation.location.coordinate.longitude;
//    annotation.coordinate = coor;
//    annotation.title = @"我在这里";
//    [_mapView addAnnotation:annotation];
    
    locationMy = userLocation;

    NSLog(@"经c度:%f  纬度:%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _searcher =[[BMKPoiSearch alloc]init];
    _searcher.delegate = self;
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 2;
    option.radius = 10000;
    option.location = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    //        CLLocationCoordinate2D{39.915, 116.404};
    option.keyword = @"停车场";
    BOOL flag = [_searcher poiSearchNearBy:option];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
    // 用户最新位置
    CLLocation *location = [[CLLocation alloc]initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    
    // 反地理编码(逆地理编码) : 把坐标信息转化为地址信息
    // 地理编码 : 把地址信息转换为坐标信息
    
    // 地理编码类
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    // 参数1:用户位置
    // 参数2:反地理编码完成之后的block
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"反地理编码失败");
            return ;
        }
        
        CLPlacemark *placeMark = [placemarks firstObject];
        NSLog(@"国家:%@ 城市:%@ 区:%@ 具体位置:%@", placeMark.country, placeMark.locality, placeMark.subLocality, placeMark.name);
        _myLocationName = placeMark.name;
        

        
        
        [_locService stopUserLocationService];
        
        return;
    }];
    // 停止定位
//    _mapView.showsUserLocation = NO;
    
    
}
//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"yyy %@",poiResultList.poiInfoList);
        BMKPoiInfo *ff = poiResultList.poiInfoList[0];
        
        
        NSArray *pois = poiResultList.poiInfoList;
        for (BMKPoiInfo *poi in pois) {
            NSLog(@"%@", poi.name);
            
            // 经纬度
//            AMapGeoPoint *point = poi.location;
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(poi.pt.latitude, poi.pt.longitude);
            
            // 初始化大头针
            MyBMKPointAnnotation* annotation = [[MyBMKPointAnnotation alloc]init];
//            CLLocationCoordinate2D coor;
            annotation.coordinate = coordinate;
//            annotation.coordinate = coor;
            annotation.title = poi.name;
            annotation.subtitle = poi.address;
            annotation.isTouch = NO;
            [_mapView addAnnotation:annotation];
        }
        
        
        
        NSLog(@"vvv %@",ff.address);
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"我的位置是" message:_myLocationName preferredStyle:UIAlertControllerStyleAlert];
    
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        
//    }];
//    [alertController addAction:okAction];
//    [self.navigationController presentViewController:alertController animated:YES completion:nil];
    
}
- (void)mapView:(BMKMapView *)mapView onClickedBMKOverlayView:(BMKOverlayView *)overlayView{



}
- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi*)mapPoi{

        NSLog(@"caocaao%@", mapPoi.text);
            if (pointAnnotation2) {
    
                [_mapView removeAnnotation:pointAnnotation2];
            }
        // 经纬度
//        //            AMapGeoPoint *point = poi.location;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(mapPoi.pt.latitude, mapPoi.pt.longitude);
    
     MyBMKPointAnnotation *tt = [[MyBMKPointAnnotation alloc]init];
        // 初始化大头针
//        pointAnnotation2 = [[BMKPointAnnotation alloc]init];
        //            CLLocationCoordinate2D coor;
        tt.coordinate = coordinate;
    tt.isTouch = YES;
        //            annotation.coordinate = coor;
        tt.title = mapPoi.text;
//        annotation.subtitle = ;
        [_mapView addAnnotation:tt];
//    }

}


//- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
//
//{
//    
//    NSLog(@"onClickedMapBlank-latitude==%f,longitude==%f",coordinate.latitude,coordinate.longitude);
//    
//    NSString* showmeg = [NSString stringWithFormat:@"您点击了地图空白处(blank click).\r\n当前经度:%f,当前纬度:%f,\r\nZoomLevel=%d;RotateAngle=%d;OverlookAngle=%d", coordinate.longitude,coordinate.latitude,
//                         
//                         (int)_mapView.zoomLevel,_mapView.rotation,_mapView.overlooking];
//    NSLog(@"touch %@",showmeg);
//    
//    
//    
//    // 用户最新位置
//    CLLocation *location = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
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
//        NSLog(@"ddddddd具体位置:%@-%@-%@", placeMark.name,placeMark.thoroughfare,placeMark.subThoroughfare);
//        //    _showMsgLabel.text = showmeg; Street = 科韵路 18号
////        　　Thoroughfare = 科韵路
////        　　SubThoroughfare = 18号
//        if (pointAnnotation2) {
//            
//            [_mapView removeAnnotation:pointAnnotation2];
//        }
//        
//        pointAnnotation2 = [[BMKPointAnnotation alloc]init];
//        
//        //    CLLocationCoordinate2D coor（使用上面获取的）;
//        CLLocationCoordinate2D coordinate1 = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
//        //    coor.latitude = 上面获取的;
//        //
//        //    coor.longitude = 上面获取的;
//        
//        pointAnnotation2.coordinate = coordinate1;
//        
//        pointAnnotation2.title = placeMark.thoroughfare;
//        
//        pointAnnotation2.subtitle = placeMark.subThoroughfare;
//        
//        [_mapView addAnnotation:pointAnnotation2];
////        [_locService stopUserLocationService];
//        
//        return;
//    }];
//
//    
//}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"我的位置是" message:_myLocationName preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alertController addAction:okAction];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _locService.delegate = nil;
    
}

- (void)dealloc
{
    if(_mapView){
        _mapView = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//- (void)btnClicked {
//    NSString *partner = PartnerID; //支付宝分配给商户的ID
//    NSString *seller = SellerID; //收款支付宝账号（用于收💰）
//    NSString *privateKey = PartnerPrivKey; //商户私钥
//    
//    /*
//     * 生成订单信息及签名
//     */
//    //将商品信息赋予Order的成员变量
//    Order *order = [[Order alloc] init];
//    order.partner = partner; //商户ID
//    order.seller = seller; //收款支付宝账号
//    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
//    order.productName = @"香蕉"; //商品标题
//    order.productDescription = @"5斤香蕉"; //商品描述
//    order.amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格(重要)
//    order.notifyURL =  @"http://www.xxx.com"; //回调URL（通知服务器端交易结果）(重要)
//    // 1777297988
//    order.service = @"mobile.securitypay.pay";
//    order.paymentType = @"1";
//    order.inputCharset = @"utf-8";
//    order.itBPay = @"30m";
//    order.showUrl = @"m.alipay.com";
//    
//    // 应用注册scheme, 在AlipayDEMO-Info.plist定义URL types
//    NSString *appScheme = @"alisdkdemo";
//    
//    //将商品信息拼接成字符串
//    NSString *orderSpec = [order description];
//    NSLog(@"orderSpec = %@",orderSpec);
//    
//    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//    id<DataSigner> signer = CreateRSADataSigner(privateKey); //通过私钥创建签名
//    NSString *signedString = [signer signString:orderSpec]; //将订单信息签名
//    
//    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = nil;
//    if (signedString != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",  orderSpec, signedString, @"RSA"];
//    }
//    
//    //支付订单，如果安装有支付宝钱包客户端则直接进入客户端，否则进入网页支付
//    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//        
//        NSLog(@"callback reslut = %@",resultDic);
//        
//    }];
//    
//}
//
//#pragma mark   ============== 产生随机订单号 ==============
//- (NSString *)generateTradeNO
//{
//    static int kNumber = 15;
//    
//    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//    NSMutableString *resultStr = [[NSMutableString alloc] init];
//    srand((unsigned)time(0));
//    for (int i = 0; i < kNumber; i++)
//    {
//        unsigned index = rand() % [sourceStr length];
//        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
//        [resultStr appendString:oneStr];
//    }
//    return resultStr;
//}
@end
