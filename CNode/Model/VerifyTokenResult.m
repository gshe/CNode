//
//  VerifyTokenResult.m
//  CNode
//
//  Created by George She on 16/3/8.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "VerifyTokenResult.h"

@implementation VerifyTokenResult
+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
    @"id" : @"userId",
  }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
  return YES;
}
@end
