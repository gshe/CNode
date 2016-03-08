//
//  UserManager.h
//  CNode
//
//  Created by George She on 16/3/7.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
#import "VerifyTokenResult.h"

#define kLoginStatusChanged @"kLoginStatusChanged"

typedef void (^UserManagerRequestCompletedBlock)(id data, NSError *error);

@interface UserManager : NSObject
+ (instancetype)sharedInstance;

@property(nonatomic, strong) UserInfoModel *curUser;

- (BOOL)isUserLogin;

- (void)verifyToken:(NSString *)token
     completedBlock:(UserManagerRequestCompletedBlock)completedBlock;

- (void)requestUserWithLoginName:(NSString *)loginName
                  completedBlock:
                      (UserManagerRequestCompletedBlock)completedBlock;
@end
