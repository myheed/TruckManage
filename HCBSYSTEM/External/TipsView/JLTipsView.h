//
//  JLTipsView.h
//  HCBTCHZ
//
//  Created by itte on 16/3/24.
//  Copyright © 2016年 itte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLTipsView : UIView

typedef void(^TipsTapHandle)(void);

- (void)setTipsLabelText:(NSString *)tips;

+ (JLTipsView *)showTips:(NSString *)tips
                  inView:(UIView *)view;

+ (JLTipsView *)showTips:(NSString *)tips
                  inView:(UIView *)view
               withImage:(UIImage *)image
          andPressHandle:(TipsTapHandle)pressHandle;

+ (JLTipsView *)showTips:(NSString *)tips
                  inView:(UIView *)view
               withImage:(UIImage *)image
          andButtonTitle:(NSString *)buttonTitle
         andButtonHandle:(TipsTapHandle)handle;

+ (JLTipsView *)showTips:(NSString *)tips
                  inView:(UIView *)view
               withImage:(UIImage *)image
    andButtonNormalImage:(UIImage *)normalImage
 andButtonHighLightImage:(UIImage *)highLightImage
          andButtonTitle:(NSString *)buttonTitle
         andButtonHandle:(TipsTapHandle)handle;
@end
