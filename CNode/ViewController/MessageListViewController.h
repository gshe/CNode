//
//  MessageListViewController.h
//  CNode
//
//  Created by George She on 16/3/9.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "FDTableViewController.h"
#import "MessageModel.h"

@interface MessageListViewController : FDTableViewController
@property(nonatomic, assign) BOOL isForUnreadMessage;
@property(nonatomic, strong) NSArray<MessageModel> *message;
@end
