//
//  TruckInfoTableCell.h
//  HCBSYSTEM
//
//  Created by itte on 16/4/6.
//  Copyright © 2016年 itte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TruckInfoTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbCarNum;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UILabel *lbCurMonthKM;
@property (weak, nonatomic) IBOutlet UILabel *lbSpeed;
@property (weak, nonatomic) IBOutlet UILabel *lbStopTime;
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnTracePlay;

@end
