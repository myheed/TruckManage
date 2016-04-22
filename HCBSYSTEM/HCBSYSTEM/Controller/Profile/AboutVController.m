//
//  AboutVController.m
//  HCBSYSTEM
//
//  Created by itte on 16/4/22.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "AboutVController.h"

@interface AboutVController ()

@end

@implementation AboutVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navig_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backup)];
}


@end
