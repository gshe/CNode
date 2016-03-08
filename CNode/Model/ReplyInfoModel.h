//
//  ReplyInfoModel.h
//  CNode
//
//  Created by George She on 16/3/7.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol ReplyInfoModel
@end

@interface ReplyInfoModel : JSONModel
@property(nonatomic, strong) NSString *replyId;
@property(nonatomic, strong) NSString *author_loginname;
@property(nonatomic, strong) NSString *author_avatar_url;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSArray *ups;
@property(nonatomic, strong) NSDate *reply_reply_id;
@property(nonatomic, strong) NSDate *create_at;
@end
