//
//  DataModels.h
//  HCBTCSJ
//
//  Created by itte on 16/2/23.
//  Copyright © 2016年 itte. All rights reserved.
//


#import <MJExtension.h>


@interface BaseModel : NSObject
@end

@interface CommonModel : NSObject
@property (copy, nonatomic) NSString *Status;
@property (copy, nonatomic) NSString *ErrorMsg;
@property (strong, nonatomic) id Content;
@end

// 用户模型
@interface UserModel : BaseModel
@property (copy, nonatomic) NSString *userID;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *userType;
@end

// 车辆信息模型
@interface VechicleInfoModel : BaseModel
@property (nonatomic,copy) NSString *VID;                         //车辆ID
@property (nonatomic,copy) NSString *DepID;                       //组织ID
@property (nonatomic,copy) NSString *DepName;                     //组织名称
@property (nonatomic,copy) NSString *DepNO;                       //组织编号
@property (nonatomic,copy) NSString *License;                     //车牌号
@property (nonatomic,copy) NSString *GpsTime;                     //GPS时间
@property (nonatomic,copy) NSString *VehicleTypeName;             //车辆类型
@property (nonatomic,copy) NSString *TotalDistance;               //总行驶里程
@property (nonatomic,copy) NSString *Speed;                       //当前速度
@property (nonatomic,copy) NSString *Status;                      //状态
@property (nonatomic,copy) NSString *Direction;                   //方向
@property (nonatomic,copy) NSString *Location;                    //位置
@property (nonatomic,assign) CGFloat Longitude;                   //经度
@property (nonatomic,assign) CGFloat Latitude;                    //纬度
@property (nonatomic,copy) NSString *StopTime;                    //停车时间
@end

// 车辆轨迹模型
@interface CarTraceModel : BaseModel
@property (copy, nonatomic) NSString *Vid;
@property (copy, nonatomic) NSString *Gpstime;
@property (assign, nonatomic) double Latitude;             // 纬度
@property (assign, nonatomic) double Longitude;            // 经度
@property (assign, nonatomic) NSInteger Speed;
@property (assign, nonatomic) NSInteger Direction;
@property (copy, nonatomic) NSString *Status;
@property (copy, nonatomic) NSString *Distance;
@property (copy, nonatomic) NSString *Locations;
@end

