//
//  MapPOIAnnotation.h
//  Demo_RoutePlanning
//
//  Created by 莱月再生 on 2018/12/13.
//  Copyright © 2018 top.yunloucity. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapCommonObj.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapPOIAnnotation : NSObject <MAAnnotation>

- (id)initWithPOI:(AMapPOI *)poi;

@property (nonatomic, readonly, strong) AMapPOI *poi;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

/*!
 @brief 获取annotation标题
 @return 返回annotation的标题信息
 */
- (NSString *)title;

/*!
 @brief 获取annotation副标题
 @return 返回annotation的副标题信息
 */
- (NSString *)subtitle;
@end

NS_ASSUME_NONNULL_END

