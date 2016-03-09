//
//  MessageModel.m
//  CNode
//
//  Created by George She on 16/3/9.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel
+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
    @"id" : @"messageId",
    @"author.loginname" : @"author_loginname",
    @"author.avatar_url" : @"author_avatar_url",
    @"type" : @"messageType",
  }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
  return YES;
}
@end
