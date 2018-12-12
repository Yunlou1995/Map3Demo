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
#import <AMapNaviKit/AMapNaviKit.h>

#import "MapSearchTableViewController.h"

@interface AMAPViewController ()
<AMapNaviDriveManagerDelegate,
MAMapViewDelegate,
AMapNaviDriveViewDelegate>

@property(strong, nonatomic)MAMapView* mapView;
@property(strong, nonatomic)AMapNaviPoint* startPoint;
@property(strong, nonatomic)AMapNaviPoint* endPoint;
@property(strong, nonatomic)AMapNaviDriveView* driveView;

@end

@implementation AMAPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"地图";
    UIBarButtonItem * searchItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAddress)];
    [self.navigationItem setRightBarButtonItem:searchItem];

    [self.view addSubview:self.mapView];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)dealloc {

}


-(void)searchAddress {
    MapSearchTableViewController * vc = [[MapSearchTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
    
}

-(MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
        _mapView.showsUserLocation = true;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        _mapView.delegate = self;
    }
    return _mapView;
}

@end
