//
//  TruckOnMapVC.h
//  HCBSYSTEM
//
//  Created by itte on 16/4/21.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "BaseVController.h"

@interface TruckOnMapVC : BaseVController
@property (strong, nonatomic) NSMutableArray *dataArray;
- (void)addTruckData:(NSArray *)dataArray;
@end
