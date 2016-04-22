//
//  Login.m
//  HCBTCSJ
//
//  Created by itte on 16/2/24.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "Login.h"

@implementation Login

+(instancetype)sharedInstance
{
    static dispatch_once_t onceTocken;
    __strong static id shareObject;
    dispatch_once(&onceTocken, ^{
        shareObject = [[self alloc] init];
    });
    return shareObject;
}

-(id)init
{
    if (self = [super init]) {
        self.user = [UserModel new];
    }
    BOOL hadLogined = [[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUser"] boolValue];
    if (hadLogined == YES){
        NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginedUser"];
        UserModel *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        [self login:user withRecordPwd:YES];
    }
    return self;
}

-(NSString *)userID
{
    if(self.user.userID.length > 0)
    {
        return self.user.userID;
    }
    else
    {
        return @"0";
    }
}
-(void)login:(UserModel *)user withRecordPwd:(BOOL)bRecord
{
    self.user = user;
    self.isLogined = YES;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:bRecord] forKey:@"loginUser"];
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"loginedUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    postNWithInfo(kNotificationLoginSuccess, nil);
}
-(void)logout
{
    self.user = nil;
    self.isLogined = NO;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"loginUser"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"loginedUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
