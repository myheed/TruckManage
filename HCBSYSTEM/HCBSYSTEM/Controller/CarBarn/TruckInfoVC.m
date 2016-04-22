//
//  TruckInfoVC.m
//  HCBSYSTEM
//
//  Created by itte on 16/4/14.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "TruckInfoVC.h"

@interface TruckInfoVC ()
@property (weak, nonatomic) IBOutlet UILabel *lbCarNum;
@property (weak, nonatomic) IBOutlet UILabel *lbCarType;
@property (weak, nonatomic) IBOutlet UILabel *lbCarLength;
@property (weak, nonatomic) IBOutlet UILabel *lbCarWeight;

@property (weak, nonatomic) IBOutlet UILabel *lbDriverName;
@property (weak, nonatomic) IBOutlet UILabel *lbDriverID;
@property (weak, nonatomic) IBOutlet UILabel *lbPhoneNum;

@property (weak, nonatomic) IBOutlet UILabel *lbDeviceNum;
@property (weak, nonatomic) IBOutlet UILabel *lbDeviceType;
@property (weak, nonatomic) IBOutlet UILabel *lbSIMNum;
@property (weak, nonatomic) IBOutlet UILabel *lbServiceEndTime;
@end

@implementation TruckInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"车辆详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navig_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backup)];
    
    VechicleInfoModel *truckInfo = self.params[@"TruckInfo"];
    
    self.lbCarNum.text = truckInfo.License;
    self.lbCarType.text = truckInfo.VehicleTypeName;
//    self.lbCarLength.text = truckInfo.;
//    self.lbCarWeight.text = truckInfo.;
//    
//    self.lbDriverName.text = truckInfo.;
//    self.lbDriverID.text = truckInfo.;
//    self.lbPhoneNum.text = truckInfo.;
//    
//    self.lbDeviceNum.text = truckInfo.;
//    self.lbDeviceType.text = truckInfo.;
//    self.lbSIMNum.text = truckInfo.;
//    self.lbServiceEndTime.text = truckInfo.;
}


@end
