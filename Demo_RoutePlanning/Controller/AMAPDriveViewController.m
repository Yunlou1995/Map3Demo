//
//  AMAPDriveViewController.m
//  Demo_RoutePlanning
//
//  Created by 莱月再生 on 2018/12/7.
//  Copyright © 2018 top.yunloucity. All rights reserved.
//

#import "AMAPDriveViewController.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
@interface AMAPDriveViewController ()
<AMapNaviDriveManagerDelegate,
AMapNaviDriveViewDelegate>

@property(strong, nonatomic)AMapNaviPoint* startPoint;
@property(strong, nonatomic)AMapNaviPoint* endPoint;
@property(strong, nonatomic)AMapNaviDriveView* driveView;

@end

@implementation AMAPDriveViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initDriveView];
    [self initDriveManager];
    [self initDriveInfo];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)dealloc {

    [[AMapNaviDriveManager sharedInstance] stopNavi];
    [[AMapNaviDriveManager sharedInstance] removeDataRepresentative:self.driveView];
    [[AMapNaviDriveManager sharedInstance] setDelegate:nil];

    BOOL success = [AMapNaviDriveManager destroyInstance];
    NSLog(@"单例是否销毁成功 : %d",success);
}

    //初始化驾车信息
- (void)initDriveInfo {
        //    设置起始点终点
    self.startPoint = [AMapNaviPoint locationWithLatitude:39.99 longitude:116.47];
    self.endPoint = [AMapNaviPoint locationWithLatitude:39.90 longitude:116.32];

        //设置车辆信息
    AMapNaviVehicleInfo *info = [[AMapNaviVehicleInfo alloc] init];
    info.vehicleId = @"京N66Y66"; //设置车牌号
    info.type = 1;              //设置车辆类型,0:小车; 1:货车. 默认0(小车).
    info.size = 4;              //设置货车的类型(大小)
    info.width = 3;             //设置货车的宽度,范围:(0,5],单位：米
    info.height = 3.9;          //设置货车的高度,范围:(0,10],单位：米
    info.length = 15;           //设置货车的长度,范围:(0,25],单位：米
    info.weight = 50;           //设置货车的总重量,范围:(0,100]
    info.load = 45;             //设置货车的核定载重,范围:(0,100],核定载重应小于总重
    info.axisNums = 6;          //设置货车的轴数（用来计算过路费及限重）
    [[AMapNaviDriveManager sharedInstance] setVehicleInfo:info];

    [[AMapNaviDriveManager sharedInstance] calculateDriveRouteWithStartPoints:@[self.startPoint]
                                                                    endPoints:@[self.endPoint]
                                                                    wayPoints:nil
                                                              drivingStrategy:17];
}

    //初始化驾车管理器
- (void)initDriveManager
{
    [[AMapNaviDriveManager sharedInstance] setDelegate:self];
        //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
    [[AMapNaviDriveManager sharedInstance] addDataRepresentative:self.driveView];
}

    //初始化驾车导航界面
- (void)initDriveView
{
    if (self.driveView == nil) {
        self.driveView = [[AMapNaviDriveView alloc] initWithFrame:self.view.bounds];
        self.driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.driveView setDelegate:self];

        [self.view addSubview:self.driveView];
    }
}


#pragma mark - 驾车导航界面按钮事件
/**
 * @brief 导航界面关闭按钮点击时的回调函数
 * @param driveView 驾车导航界面
 */
- (void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView {
    [self.navigationController popViewControllerAnimated:true];
}

/**
 * @brief 导航界面更多按钮点击时的回调函数
 * @param driveView 驾车导航界面
 */
- (void)driveViewMoreButtonClicked:(AMapNaviDriveView *)driveView {

}

/**
 * @brief 导航界面转向指示View点击时的回调函数
 * @param driveView 驾车导航界面
 */
- (void)driveViewTrunIndicatorViewTapped:(AMapNaviDriveView *)driveView {

}

/**
 * @brief 导航界面显示模式改变后的回调函数
 * @param driveView 驾车导航界面
 * @param showMode 显示模式
 */
- (void)driveView:(AMapNaviDriveView *)driveView didChangeShowMode:(AMapNaviDriveViewShowMode)showMode {

}

/**
 * @brief 驾车导航界面跟随模式改变后的回调函数. since 6.2.0
 * @param driveView 驾车导航界面
 * @param trackMode 跟随模式
 */
- (void)driveView:(AMapNaviDriveView *)driveView didChangeTrackingMode:(AMapNaviViewTrackingMode)trackMode {

}

/**
 * @brief 驾车导航界面横竖屏切换后的回调函数. since 6.2.0
 * @param driveView 驾车导航界面
 * @param isLandscape 是否时横屏
 */
- (void)driveView:(AMapNaviDriveView *)driveView didChangeOrientation:(BOOL)isLandscape {

}

/**
 * @brief 驾车导航界面白天黑夜模式切换后的回调函数. since 6.2.0
 * @param driveView 驾车导航界面
 * @param showStandardNightType 是否为黑夜模式
 */
- (void)driveView:(AMapNaviDriveView *)driveView didChangeDayNightType:(BOOL)showStandardNightType {

}


#pragma mark - Delegate
    //路径规划成功
- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteSuccessWithType:(AMapNaviRoutePlanType)type {
    NSLog(@"路径规划成功");
        //    禁行
    if (driveManager.naviRoute.forbiddenInfo.count) {
        NSLog(@"/n下面是禁行信息");
        for (AMapNaviRouteForbiddenInfo* info in driveManager.naviRoute.forbiddenInfo) {
            NSLog(@"/n禁行信息：类型：%ld，车型：%@，道路名：%@，禁行时间段：%@，经纬度：%@",(long)info.type,info.vehicleType,info.roadName,info.timeDescription,info.coordinate);
        }
    }
        //限行
    if (driveManager.naviRoute.roadFacilityInfo.count) {
        NSLog(@"/n打印限行设施");
        for (AMapNaviRoadFacilityInfo *info in driveManager.naviRoute.roadFacilityInfo) {
            if (info.type == AMapNaviRoadFacilityTypeTruckHeightLimit || info.type == AMapNaviRoadFacilityTypeTruckWidthLimit || info.type == AMapNaviRoadFacilityTypeTruckWeightLimit) {
                NSLog(@"/n限行信息：类型：%ld，道路名：%@，经纬度：%@",(long)info.type,info.roadName,info.coordinate);
            }
        }
    }
        //算路成功后开始GPS导航
    [[AMapNaviDriveManager sharedInstance] startGPSNavi];
}

@end
