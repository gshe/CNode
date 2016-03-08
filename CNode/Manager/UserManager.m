//
//  UserManager.m
//  CNode
//
//  Created by George She on 16/3/7.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "UserManager.h"
#import "AFHTTPSessionManager.h"

#define kBaseUrl @"https://cnodejs.org/api/v1/"

@interface UserManager ()
@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property(nonatomic, strong) NSString *token;
@end

@implementation UserManager
+ (instancetype)sharedInstance {
  static UserManager *manager;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[UserManager alloc] init];
  });
  return manager;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _sessionManager = [[AFHTTPSessionManager alloc]
        initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    _token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (_token) {
      [self verifyToken:_token
          completedBlock:^(VerifyTokenResult *data, NSError *error) {
            if (data && data.success) {
              [self requestUserWithLoginName:data.loginname
                              completedBlock:^(id data, NSError *error) {
                                self.curUser = data;
                              }];
            }
          }];
    }
  }
  return self;
}

- (void)storeToken:(NSString *)token loginName:(NSString *)name {
  _token = token;
  if (token) {
    FDWeakSelf;
    [self requestUserWithLoginName:name
                    completedBlock:^(id data, NSError *error) {
                      FDStrongSelf;
                      self.curUser = data;
                      [self notifyLoginStatusChanegd];
                    }];
  } else {
    [self notifyLoginStatusChanegd];
  }
}

- (void)notifyLoginStatusChanegd {
  [[NSUserDefaults standardUserDefaults] setObject:_token forKey:@"token"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusChanged
                                                      object:nil];
}

- (BOOL)isUserLogin {
  return self.token;
}

- (void)verifyToken:(NSString *)token
     completedBlock:(UserManagerRequestCompletedBlock)completedBlock {
  NSMutableDictionary *param = [NSMutableDictionary dictionary];
  [param setObject:token forKey:@"accesstoken"];
  [_sessionManager POST:@"accesstoken"
      parameters:param
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nonnull responseObject) {
        NSError *error;
        VerifyTokenResult *data =
            [[VerifyTokenResult alloc] initWithDictionary:responseObject
                                                    error:&error];
        if (data && !error) {
          if (data.success) {
            [self storeToken:token loginName:data.loginname];
          } else {
            [self storeToken:nil loginName:nil];
          }
          if (completedBlock) {
            completedBlock(data, nil);
          }
        } else {
          if (completedBlock) {
            completedBlock(nil, error);
          }
        }
      }
      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (completedBlock) {
          completedBlock(nil, error);
        }
      }];
}

- (void)requestUserWithLoginName:(NSString *)loginName
                  completedBlock:
                      (UserManagerRequestCompletedBlock)completedBlock {
  NSString *urlStr = [NSString stringWithFormat:@"user/%@", loginName];
  [_sessionManager GET:urlStr
      parameters:nil
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nonnull responseObject) {
        NSError *error;
        UserInfoModel *data =
            [[UserInfoModel alloc] initWithDictionary:responseObject[@"data"]
                                                error:&error];
        if (data && !error) {
          if (completedBlock) {
            completedBlock(data, nil);
          }
        } else {
          if (completedBlock) {
            completedBlock(nil, error);
          }
        }
      }
      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (completedBlock) {
          completedBlock(nil, error);
        }
      }];
}
@end
