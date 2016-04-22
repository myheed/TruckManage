//
//  StorageCache.m
//  GoMarket
//
//  Created by admin on 15/9/28.
//  Copyright (c) 2015年 ruidao. All rights reserved.
//

#import "StorageCache.h"
#import "JLCache.h"

@implementation StorageCache

// 缓存管理单例
+(instancetype)sharedInstance
{
    static dispatch_once_t onceTocken;
    __strong static id sharedObject;
    dispatch_once(&onceTocken, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

// 加载缓存数据
-(id)loadCache:(NSString *)key
{
    NSString *md5Key = [key md5FromString];
    return [JLCache objectForKey:md5Key];
}

// 保存对象到缓存
-(void)saveObjectToCache:(id)object forKey:(NSString *)key
{
    if([key isEmpty])
    {
        return ;
    }
    NSString *md5Key = [key md5FromString];
    [JLCache setObject:object forKey:md5Key];
}

// 添加对象到缓存文件
-(void)addObjectToArrayCache:(id)object forKey:(NSString *)key
{
    if([key isEmpty])
    {
        return ;
    }
    id logCache = [self loadCache:key];
    if ([logCache isKindOfClass:[NSArray class]])
    {
        NSMutableArray *data = [NSMutableArray arrayWithArray:logCache];
        [data addObject:object];
        NSString *md5Key = [key md5FromString];
        [JLCache setObject:data forKey:md5Key];
    }
    else
    {
        NSMutableArray *data = [NSMutableArray arrayWithObject:object];
        NSString *md5Key = [key md5FromString];
        [JLCache setObject:data forKey:md5Key];
    }
}

// 清空缓存
-(void)clearCache
{
    [JLCache clearCaches];
}

@end
