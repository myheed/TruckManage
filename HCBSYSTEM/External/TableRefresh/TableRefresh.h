//
//  TableRefresh.h
//  HCBTCHZ
//
//  Created by itte on 16/3/24.
//  Copyright © 2016年 itte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJRefresh.h>

@interface TableRefresh : NSObject

// 动画的下拉刷新
+(MJRefreshGifHeader *)gitHeaderWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;

// 动画的上拉刷新
+(MJRefreshBackGifFooter *)gitFooterWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;

@end
