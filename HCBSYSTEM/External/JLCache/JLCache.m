//
//  JLCache.m
//  StuMarket
//
//  Created by admin on 15/7/23.
//  Copyright (c) 2015年 ruidao. All rights reserved.
//

#import "JLCache.h"

@implementation JLCache

// 缓存有效时间（一个星期）
static NSTimeInterval cacheTime =  (double)604800;

+(void)clearCaches
{
    [[NSFileManager defaultManager] removeItemAtPath:[JLCache cacheDirectory] error:nil];
}

+(NSString *)cacheDirectory
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    cacheDirectory = [cacheDirectory stringByAppendingPathComponent:@"JLCaches"];
    return cacheDirectory;
}

// 从缓存里获取对象
+(id)objectForKey:(NSString*)key
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [self.cacheDirectory stringByAppendingPathComponent:key];
    
    if ([fileManager fileExistsAtPath:filename])
    {
        NSDate *modificationDate = [[fileManager attributesOfItemAtPath:filename error:nil] objectForKey:NSFileModificationDate];
        if ([modificationDate timeIntervalSinceNow] > cacheTime)
        {
            [fileManager removeItemAtPath:filename error:nil];
        }
        else
        {
            id data = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
            return data;
        }
    }
    return nil;
}

// 将对象保存到缓存里
+(void)setObject:(id)data forKey:(NSString*)key
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [self.cacheDirectory stringByAppendingPathComponent:key];
    
    BOOL isDir = YES;
    if (![fileManager fileExistsAtPath:self.cacheDirectory isDirectory:&isDir])
    {
        [fileManager createDirectoryAtPath:self.cacheDirectory withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    [NSKeyedArchiver archiveRootObject:data toFile:filename];
    
}

@end
