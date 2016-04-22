//
//  JLTipsView.m
//  HCBTCHZ
//
//  Created by itte on 16/3/24.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "JLTipsView.h"

#define MariginOfTipsLabel       15.0f
#define TagOfTipsView            98765

@interface JLTipsView ()
@property (nonatomic, strong) UIImageView *tipsImageView;
@property (nonatomic, strong) UILabel     *tipsLabel;
@property (nonatomic, strong) UIButton    *tipsButton;
@end

@implementation JLTipsView

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

-(void)setTipsLabelText:(NSString *)tips
{
    self.tipsLabel.text = tips;
    self.tipsLabel.width = self.width * 0.5;
    [self.tipsLabel sizeToFit];                 //计算出label的大小，目的是为了给image和button位置参照
    self.tipsLabel.centerX = self.centerX;
    self.tipsLabel.centerY = self.centerY;
    
    if (self.tipsImageView) {
        self.tipsImageView.centerY = self.centerY - (self.tipsImageView.height + self.tipsLabel.height) / 2.0f - MariginOfTipsLabel;
    }
    if (self.tipsButton) {
        self.tipsButton.centerY = self.centerY + (self.tipsButton.height + self.tipsLabel.height) / 2.0f + MariginOfTipsLabel;
    }
}

+ (JLTipsView *)showTips:(NSString *)tips
                  inView:(UIView *)view
{
    JLTipsView *tipsView = nil;
    if ([view viewWithTag:TagOfTipsView]) {
        tipsView = (JLTipsView *)[view viewWithTag:TagOfTipsView];
    }
    else {
        tipsView = [[JLTipsView alloc] init];
    }
    tipsView.tag = TagOfTipsView;
    tipsView.backgroundColor = [UIColor clearColor];
    tipsView.top = 0;
    tipsView.left = 0;
    tipsView.width = view.width;
    tipsView.height = view.height;
    tipsView.tipsLabel = [[UILabel alloc] init];
    tipsView.tipsLabel.backgroundColor = [UIColor clearColor];
    tipsView.tipsLabel.textColor = [UIColor darkGrayColor];
    tipsView.tipsLabel.font = [UIFont systemFontOfSize:14];
    tipsView.tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsView.tipsLabel.lineBreakMode = NSLineBreakByCharWrapping;
    tipsView.tipsLabel.numberOfLines = 0;
    [tipsView setTipsLabelText:tips];
    [tipsView addSubview:tipsView.tipsLabel];
    [view addSubview:tipsView];//这句代码会遮挡view上的其他控件
    
    return tipsView;
}

+ (JLTipsView *)showTips:(NSString *)tips
                  inView:(UIView *)view
               withImage:(UIImage *)image
          andPressHandle:(TipsTapHandle)pressHandle
{
    JLTipsView *tipsView = [JLTipsView showTips:tips inView:view];
    
    if (image) {
        tipsView.tipsImageView = [[UIImageView alloc] initWithImage:image];
        tipsView.tipsImageView.centerX = tipsView.centerX;
        tipsView.tipsImageView.centerY = tipsView.centerY - (tipsView.tipsImageView.height + tipsView.tipsLabel.height) / 2.0f - MariginOfTipsLabel;
        tipsView.tipsImageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        [tipsView addSubview:tipsView.tipsImageView];
    }
    
    if (pressHandle) {
        tipsView.userInteractionEnabled = YES;
        [tipsView bk_whenTapped:^{
            pressHandle();
        }];
    }
    
    return tipsView;
}

+ (JLTipsView *)showTips:(NSString *)tips
                  inView:(UIView *)view
               withImage:(UIImage *)image
          andButtonTitle:(NSString *)buttonTitle
         andButtonHandle:(TipsTapHandle)handle
{
    return [JLTipsView showTips:tips
                         inView:view
                      withImage:image
           andButtonNormalImage:[UIImage imageNamed:@"btnOrange"]
        andButtonHighLightImage:[UIImage imageNamed:@"btnOrange"]
                 andButtonTitle:buttonTitle
                andButtonHandle:handle];
}

+ (JLTipsView *)showTips:(NSString *)tips
                  inView:(UIView *)view
               withImage:(UIImage *)image
    andButtonNormalImage:(UIImage *)normalImage
 andButtonHighLightImage:(UIImage *)highLightImage
          andButtonTitle:(NSString *)buttonTitle
         andButtonHandle:(TipsTapHandle)handle
{
    JLTipsView *tipsView = [JLTipsView showTips:tips
                                         inView:view
                                      withImage:image
                                 andPressHandle:nil];
    
    tipsView.tipsButton = [[UIButton alloc]init];
    tipsView.tipsButton.backgroundColor = [UIColor clearColor];
    if (normalImage) {
        [tipsView.tipsButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    }
    else {
        
    }
    if (highLightImage) {
        [tipsView.tipsButton setBackgroundImage:highLightImage forState:UIControlStateHighlighted];
    }
    else {
        
    }
    [tipsView.tipsButton setTitle:buttonTitle forState:UIControlStateNormal];
    tipsView.tipsButton.titleLabel.font = [UIFont systemFontOfSize:16];
    tipsView.tipsButton.titleLabel.textColor = [UIColor whiteColor];
    tipsView.tipsButton.width = 100.0f;
    tipsView.tipsButton.height = 32.0f;
    tipsView.tipsButton.centerX = tipsView.centerX;
    tipsView.tipsButton.centerY = tipsView.centerY + (tipsView.tipsButton.height + tipsView.tipsLabel.height) / 2.0f + MariginOfTipsLabel;
    [tipsView addSubview:tipsView.tipsButton];
    
    if (handle) {
        [tipsView.tipsButton bk_addEventHandler:^(id sender) {
            handle();
        } forControlEvents:UIControlEventTouchUpInside];
    }
    
    return tipsView;
}

@end
