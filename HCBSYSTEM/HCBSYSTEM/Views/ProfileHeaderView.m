//
//  ProfileHeaderView.m
//  HCBSYSTEM
//
//  Created by itte on 16/4/20.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "ProfileHeaderView.h"

@implementation ProfileHeaderView


- (instancetype)init
{
    if (self = [super init]) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"ProfileHeaderView" owner:nil options:nil];
        self = [views objectAtIndex:0];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"ProfileHeaderView" owner:nil options:nil];
        self = [views objectAtIndex:0];
        self.frame = frame;
    }
    return self;
}
@end
