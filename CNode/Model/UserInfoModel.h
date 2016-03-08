//
//  UserInfoModel.h
//  CNode
//
//  Created by George She on 16/3/7.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ReplyInfoModel.h"
#import "TopicInfoModel.h"

@interface UserInfoModel : JSONModel
@property(nonatomic, strong) NSString *loginname;
@property(nonatomic, strong) NSString *avatar_url;

@property(nonatomic, strong) NSString *githubUsername;
@property(nonatomic, strong) NSDate *create_at;
@property(nonatomic, assign) NSInteger score;

@property(nonatomic, strong) NSArray<TopicInfoModel> *recent_topics;
@property(nonatomic, strong) NSArray<ReplyInfoModel> *recent_replies;
@end
