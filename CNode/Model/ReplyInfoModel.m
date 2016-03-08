//
//  ReplyInfoModel.m
//  CNode
//
//  Created by George She on 16/3/7.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "ReplyInfoModel.h"

@implementation ReplyInfoModel
+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
    @"id" : @"replyId",
    @"author.loginname" : @"author_loginname",
    @"author.avatar_url" : @"author_avatar_url",
    @"reply_id" : @"reply_reply_id",
  }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
  return YES;
}
@end
