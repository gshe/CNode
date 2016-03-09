//
//  UserManager.m
//  CNode
//
//  Created by George She on 16/3/7.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "UserManager.h"
#import "AFHTTPSessionManager.h"
#import "MessageListModel.h"

//#define kBaseUrl @"https://cnodejs.org/api/v1/"
#define kBaseUrl @"http://ionichina.com/api/v1"

@interface UserManager ()
@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property(nonatomic, strong) VerifyTokenResult *tokenVerify;
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
    _userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
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

- (void)storeVerifiedToken:(NSString *)token
                    result:(VerifyTokenResult *)result {
  _token = token;
  _tokenVerify = result;
  if (!result) {
    _token = nil;
  }
  if (result) {
    FDWeakSelf;
    [self requestUserWithLoginName:result.loginname
                    completedBlock:^(id data, NSError *error) {
                      FDStrongSelf;
                      self.curUser = data;
                      [self notifyLoginStatusChanegd];
                    }];
    [self requestUserUnReadMessageCount:^(id data, NSError *error) {
      if ([data isKindOfClass:[NSNumber class]]) {
        NSNumber *number = data;
        self.unreadMessageCount = number.integerValue;
        [self notifyLoginStatusChanegd];
      }
    }];
  } else {
    [self notifyLoginStatusChanegd];
  }
}

- (void)notifyLoginStatusChanegd {
  [[NSUserDefaults standardUserDefaults] setObject:_token forKey:@"token"];
  [[NSUserDefaults standardUserDefaults] setObject:_tokenVerify.loginname
                                            forKey:@"loginNamme"];
  [[NSUserDefaults standardUserDefaults] setObject:_tokenVerify.userId
                                            forKey:@"userId"];
  [[NSUserDefaults standardUserDefaults] setObject:_tokenVerify.avatar_url
                                            forKey:@"avatar"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusChanged
                                                      object:nil];
}

- (BOOL)isUserLogin {
  return self.token;
}

- (NSString *)userId {
  return _userId;
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
            [self storeVerifiedToken:token result:data];
          } else {
            [self storeVerifiedToken:token result:nil];
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

- (void)requestUserUnReadMessageCount:
        (UserManagerRequestCompletedBlock)completedBlock {
  NSMutableDictionary *param = [NSMutableDictionary dictionary];
  [param setObject:[UserManager sharedInstance].token forKey:@"accesstoken"];
  [_sessionManager GET:@"message/count"
      parameters:param
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nonnull responseObject) {
        NSError *error;
        id data = responseObject[@"data"];

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

- (void)requestUserMakeAllAsRead:
        (UserManagerRequestCompletedBlock)completedBlock {
  NSMutableDictionary *param = [NSMutableDictionary dictionary];
  [param setObject:[UserManager sharedInstance].token forKey:@"accesstoken"];
  [_sessionManager POST:@"message/mark_all"
      parameters:param
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nonnull responseObject) {
        NSError *error;
        id data = responseObject[@"success"];

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

- (void)requestUserMessage:(UserManagerRequestCompletedBlock)completedBlock {
  NSMutableDictionary *param = [NSMutableDictionary dictionary];
  [param setObject:[UserManager sharedInstance].token forKey:@"accesstoken"];
  [_sessionManager GET:@"messages"
      parameters:param
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nonnull responseObject) {
        NSError *error;
        MessageListModel *data =
            [[MessageListModel alloc] initWithDictionary:responseObject[@"data"]
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

- (BOOL)isUserUpTheReplay:(ReplyInfoModel *)reply {
  if (!_userId) {
    return NO;
  }

  __block BOOL isUp = NO;
  [reply.ups enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx,
                                          BOOL *_Nonnull stop) {
    if ([_userId isEqualToString:obj]) {
      isUp = YES;
      *stop = YES;
    }
  }];
  return isUp;
}
@end
