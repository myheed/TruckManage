//
//  DataModels.m
//  HCBTCSJ
//
//  Created by itte on 16/2/23.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "DataModels.h"

@implementation BaseModel
MJCodingImplementation
@end

@implementation CommonModel
@end

@implementation UserModel
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"userID":@"User_id",@"userType":@"User_type"};
}
@end

@implementation CarTraceModel
@end

@implementation VechicleInfoModel
@end


/*
@implementation TruckClassModel
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"Children":[TruckModel class]};
}
@end
*/



