//
//  StorageCache.h
//  GoMarket
//
//  Created by admin on 15/9/28.
//  Copyright (c) 2015年 ruidao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StorageCache : NSObject

// 缓存管理单例
+(instancetype)sharedInstance;

// 加载缓存数据 返回数组
-(id)loadCache:(NSString *)key;

// 保存对象到缓存
-(void)saveObjectToCache:(id)object forKey:(NSString *)key;
// 添加对象到缓存文件
-(void)addObjectToArrayCache:(id)object forKey:(NSString *)key;
// 清空缓存
-(void)clearCache;
@end
