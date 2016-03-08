//
//  TopicManager.m
//  CNode
//
//  Created by George She on 16/3/7.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "TopicManager.h"
#import "AFNetworking.h"
#define kBaseUrl @"https://cnodejs.org/api/v1/"

@interface TopicManager ()
@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation TopicManager

+ (instancetype)sharedInstance {
  static TopicManager *manager;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[TopicManager alloc] init];
  });
  return manager;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _sessionManager = [[AFHTTPSessionManager alloc]
        initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
  }
  return self;
}

- (void)requestTopicWithPage:(NSInteger)pageIndex
                countPerPage:(NSInteger)countPerPage
                         tab:(NSString *)tab
              completedBlock:(TopicManagerRequestCompletedBlock)completedBlock {
  NSMutableDictionary *param = [NSMutableDictionary dictionary];
  [param setObject:@(pageIndex) forKey:@"page"];
  [param setObject:@(countPerPage) forKey:@"limit"];
  if (tab) {
    [param setObject:tab forKey:@"tab"];
  }

  [_sessionManager GET:@"topics"
      parameters:param
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nonnull responseObject) {
        NSError *error;
        TopicListModel *data =
            [[TopicListModel alloc] initWithDictionary:responseObject
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

- (void)requestTopicDetailWithId:(NSString *)topicId
                  completedBlock:
                      (TopicManagerRequestCompletedBlock)completedBlock {
  NSString *urlStr = [NSString stringWithFormat:@"topic/%@", topicId];
  [_sessionManager GET:urlStr
      parameters:nil
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nonnull responseObject) {
        NSError *error;
        TopicInfoModel *data =
            [[TopicInfoModel alloc] initWithDictionary:responseObject[@"data"]
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
