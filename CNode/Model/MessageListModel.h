//
//  MessageListModel.h
//  CNode
//
//  Created by George She on 16/3/9.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MessageModel.h"

@interface MessageListModel : JSONModel
@property(nonatomic, strong) NSArray<MessageModel> *has_read_messages;
@property(nonatomic, strong) NSArray<MessageModel> *hasnot_read_messages;
@end
