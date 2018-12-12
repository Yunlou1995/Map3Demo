//
//  AppDelegate+MapConfigure.m
//  Demo_RoutePlanning
//
//  Created by 莱月再生 on 2018/12/12.
//  Copyright © 2018 top.yunloucity. All rights reserved.
//

#import "AppDelegate+MapConfigure.h"

@implementation AppDelegate (MapConfigure)
-(void)configureMapAuth {
    NSString* amapKey = @"a170037c91485f1ab49941b87e2189e3";
    NSString* bmapKey = @"";

        //    高德地图配置
    [AMapServices sharedServices].apiKey = amapKey;
    [[AMapServices sharedServices] setEnableHTTPS:YES];
}
@end
