//
//  XPToolKit.m
//  SeekClient
//
//  Created by origin on 14/10/20.
//  Copyright (c) 2014年 Dorigin. All rights reserved.
//

#import "WFToolKit.h"
#import <CommonCrypto/CommonDigest.h>
#import "TopicInfoModel.h"
#import "ReplyInfoModel.h"

UIColor *RGBColor(float R, float G, float B, float A) {

  return
      [UIColor colorWithRed:R / 255.f green:G / 255.f blue:B / 255.f alpha:A];
}

void setExtraCellLineHidden(UITableView *tableView) {

  UIView *view = [[UIView alloc] init];
  view.backgroundColor = [UIColor clearColor];
  [tableView setTableFooterView:view];
  [tableView setTableHeaderView:view];
}

#pragma mark resource Control
// bundle图片加载
extern UIImage *Image(NSString *imageName) {
  NSString *bundleStr = @"Resource.bundle/";
  NSString *imgPath = [bundleStr stringByAppendingString:imageName];
  return [UIImage imageNamed:imgPath];
}

NSArray *getTopicIdList(NSArray *topicList) {
  NSMutableArray *array = [NSMutableArray array];
  for (TopicInfoModel *item in topicList) {
    [array addObject:item.topicId];
  }
  return array;
}

NSArray *getReplyIdList(NSArray *replyList) {
  NSMutableArray *array = [NSMutableArray array];
  for (ReplyInfoModel *item in replyList) {
    [array addObject:item.replyId];
  }
  return array;
}