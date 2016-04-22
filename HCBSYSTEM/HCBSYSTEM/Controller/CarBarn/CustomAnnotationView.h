//
//  CustomAnnotationView.h
//  HCBSYSTEM
//
//  Created by itte on 16/4/14.
//  Copyright © 2016年 itte. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CustomAnnotationView : UIView
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UILabel *lbCarNum;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UILabel *lbCurMonthMileage;
@property (weak, nonatomic) IBOutlet UILabel *lbSpeed;
@property (weak, nonatomic) IBOutlet UILabel *lbStopTime;
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnCarInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnTracePlay;

@end
