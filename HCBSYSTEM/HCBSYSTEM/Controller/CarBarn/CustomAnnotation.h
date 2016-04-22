//
//  CustomAnnotation.h
//  HCBSYSTEM
//
//  Created by itte on 16/4/14.
//  Copyright © 2016年 itte. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface CustomAnnotation : BMKPointAnnotation
@property (retain, nonatomic) VechicleInfoModel *vechicleInfo;
@end
