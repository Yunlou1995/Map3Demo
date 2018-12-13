//
//  MapPOIAnnotation.m
//  Demo_RoutePlanning
//
//  Created by 莱月再生 on 2018/12/13.
//  Copyright © 2018 top.yunloucity. All rights reserved.
//

#import "MapPOIAnnotation.h"

@interface MapPOIAnnotation ()
@property (nonatomic, readwrite, strong) AMapPOI *poi;
@end

@implementation MapPOIAnnotation

@synthesize poi = _poi;

#pragma mark - MAAnnotation Protocol

- (NSString *)title
{
    return self.poi.name;
}

- (NSString *)subtitle
{
    return self.poi.address;
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.poi.location.latitude, self.poi.location.longitude);
}

#pragma mark - Life Cycle

- (id)initWithPOI:(AMapPOI *)poi
{
    if (self = [super init]) {
        self.poi = poi;
    }
    return self;
}

@end
