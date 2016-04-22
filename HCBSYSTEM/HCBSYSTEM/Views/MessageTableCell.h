//
//  MessageTableCell.h
//  HCBSYSTEM
//
//  Created by itte on 16/4/19.
//  Copyright © 2016年 itte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnMsgType;
@property (weak, nonatomic) IBOutlet UILabel *lbCarNum;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UILabel *lbSpeed;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@property (weak, nonatomic) IBOutlet UIImageView *imgChoice;
@property (weak, nonatomic) IBOutlet UIButton *btnOpration;
@property (weak, nonatomic) IBOutlet UIButton *btnCallDriver;
@end
