//
//  AMAPViewController.m
//  Demo_RoutePlanning
//
//  Created by 莱月再生 on 2018/12/7.
//  Copyright © 2018 top.yunloucity. All rights reserved.
//

#import "AMAPViewController.h"
#import <MapKit/MapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import "MapSearchTableViewController.h"
#import "UIView+LayoutMethods.h"
#import "PoiDetailViewController.h"
#import "UIView+HandyAutoLayout.h"

@interface AMAPViewController ()
<AMapNaviDriveManagerDelegate,
MAMapViewDelegate,
AMapNaviDriveViewDelegate,
MapSearchTableViewDelegate,
AMapNaviCompositeManagerDelegate
>

@property(strong, nonatomic)MAMapView* mapView;
@property(strong, nonatomic)AMapNaviPoint* startPoint;
@property(strong, nonatomic)AMapNaviPoint* endPoint;

@property(strong, nonatomic)AMapNaviCompositeManager* compositeManager;

@end

@implementation AMAPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"地图";
    UIBarButtonItem * searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchItemOnClick)];
    [self.navigationItem setRightBarButtonItem:searchItem];

    [self.view addSubview:self.mapView];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)dealloc {

}

-(void)locationButtonOnClick {
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:true];
}

- (void)gotoDetailForPoi:(AMapPOI *)poi
{
    if (poi != nil) {
        PoiDetailViewController* detail = [[PoiDetailViewController alloc] init];
        detail.poi = poi;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (void)gotoNaviForPoi:(AMapPOI *)poi
{
    if (poi != nil) {

            // 初始化
        self.compositeManager = [[AMapNaviCompositeManager alloc] init];
            // 如果需要使用AMapNaviCompositeManagerDelegate的相关回调（如自定义语音、获取实时位置等），需要设置delegate
        self.compositeManager.delegate = self;

            //导航组件配置类 since 5.2.0
        AMapNaviCompositeUserConfig *config = [[AMapNaviCompositeUserConfig alloc] init];

            //传入起点，并且带高德POIId
        [config setRoutePlanPOIType:AMapNaviRoutePlanPOITypeStart location:[AMapNaviPoint locationWithLatitude:self.mapView.userLocation.location.coordinate.latitude longitude:self.mapView.userLocation.location.coordinate.longitude] name:@"起点" POIId:nil];

            //传入终点，并且带高德POIId
        [config setRoutePlanPOIType:AMapNaviRoutePlanPOITypeEnd location:[AMapNaviPoint locationWithLatitude:poi.location.latitude longitude:poi.location.longitude] name:poi.name POIId:poi.uid];
            //启动
        [self.compositeManager presentRoutePlanViewControllerWithOptions:config];
    }
}

#pragma mark - AMapNaviCompositeManagerDelegate
    // 发生错误时,会调用此方法
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager error:(NSError *)error {
    NSLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
}


    // 算路成功后的回调函数,路径规划页面的算路、导航页面的重算等成功后均会调用此方法
- (void)compositeManagerOnCalculateRouteSuccess:(AMapNaviCompositeManager *)compositeManager {
    NSLog(@"onCalculateRouteSuccess,%ld",(long)compositeManager.naviRouteID);
}

    // 算路失败后的回调函数,路径规划页面的算路、导航页面的重算等失败后均会调用此方法
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager onCalculateRouteFailure:(NSError *)error {
    NSLog(@"onCalculateRouteFailure error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

    // 开始导航的回调函数
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager didStartNavi:(AMapNaviMode)naviMode {
    NSLog(@"didStartNavi,%ld",(long)naviMode);
}


    // 当前位置更新回调
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager updateNaviLocation:(AMapNaviLocation *)naviLocation {
    NSLog(@"updateNaviLocation,%@",naviLocation);
}

    // 导航到达目的地后的回调函数
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager didArrivedDestination:(AMapNaviMode)naviMode {
    NSLog(@"didArrivedDestination,%ld",(long)naviMode);
}

#pragma mark - MAMapViewDelegate

/**
 * @brief 标注view的accessory view(必须继承自UIControl)被点击时，触发该回调
 * @param mapView 地图View
 * @param view callout所属的标注view
 * @param control 对应的control
 */
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[MapPOIAnnotation class]]) {
//        [self gotoDetailForPoi:[(MapPOIAnnotation *)view.annotation poi]];
        [self gotoNaviForPoi:[(MapPOIAnnotation *)view.annotation poi]];
    }
}

/**
 * @brief 根据anntation生成对应的View。

 注意：
 1、5.1.0后由于定位蓝点增加了平滑移动功能，如果在开启定位的情况先添加annotation，需要在此回调方法中判断annotation是否为MAUserLocation，从而返回正确的View。
 if ([annotation isKindOfClass:[MAUserLocation class]]) {
 return nil;
 }

 2、请不要在此回调中对annotation进行select和deselect操作，此时annotationView还未添加到mapview。

 * @param mapView 地图View
 * @param annotation 指定的标注
 * @return 生成的标注View
 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MapPOIAnnotation class]]) {
        static NSString *poiIdentifier = @"poiIdentifier";
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
        if (poiAnnotationView == nil)
            {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
            }

        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

        return poiAnnotationView;
    }
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
        {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];

        polylineRenderer.lineWidth   = 4.f;
        polylineRenderer.strokeColor = [UIColor magentaColor];

        return polylineRenderer;
        }

    return nil;
}



-(void)searchItemOnClick {
    MapSearchTableViewController * vc = [[MapSearchTableViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:true];
}

- (void)tableViewController:(UITableViewController *)tableVC didSelectPOI:(nonnull MapPOIAnnotation *)poi {
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView setCenterCoordinate:poi.coordinate animated:true];
    [self.mapView addAnnotation:poi];

}

-(MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
        _mapView.showsUserLocation = true;
        _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
        [_mapView setZoomLevel:17];
        _mapView.delegate = self;
    }
    return _mapView;
}

@end
