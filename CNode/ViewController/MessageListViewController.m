//
//  MessageListViewController.m
//  CNode
//
//  Created by George She on 16/3/9.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageCell.h"

@interface MessageListViewController ()
@property(nonatomic, strong) UIButton *makeAll;
@end

@implementation MessageListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _makeAll = [UIButton buttonWithType:UIButtonTypeCustom];
  [_makeAll setTitle:@"全部标记为已读" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)setMessage:(NSArray<MessageModel> *)message {
  _message = message;
  [self refreshUI];
}

- (void)refreshUI {
  [self refreshMakeAllButton];
  NSMutableArray *contents = [@[] mutableCopy];
  self.action = [[NITableViewActions alloc] initWithTarget:self];
  if (_message) {
    for (MessageModel *item in _message) {
      MessageCellUserData *userData = [[MessageCellUserData alloc] init];
      userData.message = item;
      [contents
          addObject:[self.action
                        attachToObject:[[NICellObject alloc]
                                           initWithCellClass:[MessageCell class]
                                                    userInfo:userData]
                           tapSelector:@selector(itemClicked:)]];
    }
  }

  self.tableView.delegate = [self.action forwardingTo:self];
  [self setTableData:contents];
}

- (void)refreshMakeAllButton {

  if (self.isForUnreadMessage && _message.count > 0) {
    _makeAll.hidden = NO;
    _makeAll.frame =
        CGRectMake(0, HEIGHT(self.view) - 44, WIDTH(self.view), 44);
    self.tableView.frame =
        CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view) - 44);
  } else {
    _makeAll.hidden = YES;
    self.tableView.frame =
        CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view));
  }
}

- (void)itemClicked:(NICellObject *)cellObj {
  //	CommentItemCellUserData *userData = cellObj.userInfo;
  //	ReplyDetailViewController *detailVC =
  //	[[ReplyDetailViewController alloc] initWithNibName:nil bundle:nil];
  //	detailVC.curReply = userData.reply;
  //	detailVC.replyList = self.topic.replies;
  //	[self.navigationController pushViewController:detailVC animated:YES];
}

@end
