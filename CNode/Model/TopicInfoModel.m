//
//  TopicInfoModel.m
//  CNode
//
//  Created by George She on 16/3/7.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "TopicInfoModel.h"

@implementation TopicInfoModel
+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
    @"id" : @"topicId",
    @"author.loginname" : @"author_loginname",
    @"author.avatar_url" : @"author_avatar_url"
  }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
  return YES;
}
@end
