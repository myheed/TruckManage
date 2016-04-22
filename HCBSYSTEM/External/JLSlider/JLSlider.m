//
//  JLSlider.m
//  slider
//
//  Created by itte on 16/4/14.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "JLSlider.h"

@implementation JLSlider


- (CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 5, bounds.size.width, 6);
}
@end
