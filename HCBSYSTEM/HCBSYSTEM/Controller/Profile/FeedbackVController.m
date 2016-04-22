//
//  FeedbackVController.m
//  HCBSYSTEM
//
//  Created by itte on 16/4/22.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "FeedbackVController.h"

@interface FeedbackVController ()
@property (weak, nonatomic) IBOutlet UITextView *txtView;

@end

@implementation FeedbackVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = false;
    self.navigationItem.title = @"意见反馈";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navig_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backup)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitFeedback)];
    
    self.txtView.placeholder = @"请输入你宝贵的意见";
}

- (void)submitFeedback
{
}


@end
