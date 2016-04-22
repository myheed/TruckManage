//
//  JLCache.h
//  StuMarket
//
//  Created by admin on 15/7/23.
//  Copyright (c) 2015年 ruidao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JLCache : NSObject

+ (void)clearCaches;
+ (id)objectForKey:(NSString*)key;
+ (void)setObject:(id)data forKey:(NSString*)key;
@end
