//
//  TableRefresh.m
//  HCBTCHZ
//
//  Created by itte on 16/3/24.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "TableRefresh.h"


@implementation TableRefresh

+(MJRefreshGifHeader *)gitHeaderWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:refreshingBlock];
    NSArray *gitImage = @[@"git01",@"git02",@"git03",@"git04",@"git05",@"git06"];
    NSMutableArray *imgArray = [NSMutableArray array];
    for (NSString *img in gitImage) {
        UIImage *imgName= [UIImage imageNamed:img];
        [imgArray addObject:imgName];
    }
    [header setImages:imgArray forState:MJRefreshStateIdle];
    [header setImages:imgArray forState:MJRefreshStatePulling];
    [header setImages:imgArray forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    return header;
}

+(MJRefreshBackGifFooter *)gitFooterWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:refreshingBlock];
    NSArray *gitImage = @[@"git01",@"git02",@"git03",@"git04",@"git05",@"git06"];
    NSMutableArray *imgArray = [NSMutableArray array];
    for (NSString *img in gitImage) {
        UIImage *imgName= [UIImage imageNamed:img];
        [imgArray addObject:imgName];
    }
    [footer setImages:imgArray forState:MJRefreshStateIdle];
    [footer setImages:imgArray forState:MJRefreshStatePulling];
    [footer setImages:imgArray forState:MJRefreshStateRefreshing];
    footer.stateLabel.hidden = YES;
    return footer;
}
@end
