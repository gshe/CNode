//
//  MessageCell.h
//  CNode
//
//  Created by George She on 16/3/9.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "FDTableViewCell.h"
#import "MessageModel.h"

@interface MessageCellUserData : NSObject
@property(nonatomic, strong) MessageModel *message;
@end

@interface MessageCell : FDTableViewCell
@property(nonatomic, strong) MessageCellUserData *userData;

+ (NICellObject *)createObject:(id)_delegate userData:(id)_userData;
@end
