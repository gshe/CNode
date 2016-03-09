//
//  MessageModel.h
//  CNode
//
//  Created by George She on 16/3/9.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "TopicInfoModel.h"
#import "ReplyInfoModel.h"

@protocol MessageModel
@end

@interface MessageModel : JSONModel

@property(nonatomic, strong) NSString *messageId;
@property(nonatomic, strong) NSString *messageType;
@property(nonatomic, assign) BOOL has_read;
@property(nonatomic, strong) NSString *author_loginname;
@property(nonatomic, strong) NSString *author_avatar_url;
@property(nonatomic, strong) TopicInfoModel *topic;
@property(nonatomic, strong) ReplyInfoModel *reply;
@end
