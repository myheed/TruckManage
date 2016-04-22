//
//  CustromAnnotationView.m
//  HCBSYSTEM
//
//  Created by itte on 16/4/14.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "CustomAnnotationView.h"

@implementation CustomAnnotationView


-(instancetype)init
{
    if (self = [super init]) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"CustomAnnotationView" owner:nil options:nil];
        self = [views objectAtIndex:0];
        _backGroundView.layer.cornerRadius = 5;
        _btnCarInfo.layer.cornerRadius = 5;
        _btnTracePlay.layer.cornerRadius = 5;
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"CustomAnnotationView" owner:nil options:nil];
        self = [views objectAtIndex:0];
        _backGroundView.layer.cornerRadius = 5;
        _btnCarInfo.layer.cornerRadius = 5;
        _btnTracePlay.layer.cornerRadius = 5;
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
