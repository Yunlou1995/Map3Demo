//
//  MapSearchTableViewController.h
//  Demo_RoutePlanning
//
//  Created by 莱月再生 on 2018/12/12.
//  Copyright © 2018 top.yunloucity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MapPOIAnnotation.h"

NS_ASSUME_NONNULL_BEGIN
@protocol MapSearchTableViewDelegate <NSObject>

-(void)tableViewController:(UITableViewController *)tableVC didSelectPOI:(MapPOIAnnotation *)poi;

@end

@interface MapSearchTableViewController : UITableViewController

@property(weak, nonatomic)id <MapSearchTableViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
