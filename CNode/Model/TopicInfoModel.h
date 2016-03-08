//
//  TopicInfoModel.h
//  CNode
//
//  Created by George She on 16/3/7.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ReplyInfoModel.h"

@protocol TopicInfoModel
@end

@interface TopicInfoModel : JSONModel
@property(nonatomic, strong) NSString *topicId;
@property(nonatomic, strong) NSString *author_id;
@property(nonatomic, strong) NSString *author_loginname;
@property(nonatomic, strong) NSString *author_avatar_url;

@property(nonatomic, strong) NSString *tab;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSDate *last_reply_at;
@property(nonatomic, strong) NSDate *create_at;

@property(nonatomic, assign) BOOL good;
@property(nonatomic, assign) BOOL top;
@property(nonatomic, assign) NSInteger reply_count;
@property(nonatomic, assign) NSInteger visit_count;

@property(nonatomic, strong) NSArray<ReplyInfoModel> *replies;
@end
