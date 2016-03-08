//
//  CommentViewController.h
//  CNode
//
//  Created by George She on 16/3/7.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "FDViewController.h"
#import "ReplyInfoModel.h"

@interface ReplyDetailViewController : FDViewController
@property(nonatomic, strong) ReplyInfoModel *curReply;
@property(nonatomic, strong) NSArray *replyList;
@end
