//
//  ProfileHeaderView.h
//  HCBSYSTEM
//
//  Created by itte on 16/4/20.
//  Copyright © 2016年 itte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UIView *setupView;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbDetailName;
@property (weak, nonatomic) IBOutlet UILabel *lbTruckNum;
@property (weak, nonatomic) IBOutlet UILabel *lbOneDaySumKM;
@property (weak, nonatomic) IBOutlet UILabel *lbOneMonthSumKM;

@end
