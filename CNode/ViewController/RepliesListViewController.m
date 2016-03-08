//
//  CommentsListViewController.m
//  CNode
//
//  Created by George She on 16/3/7.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "RepliesListViewController.h"
#import "CommentItemCell.h"
#import "ReplyDetailViewController.h"

@interface RepliesListViewController ()

@end

@implementation RepliesListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.title = self.topic.title;
  [self refreshUI];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)refreshUI {
  NSMutableArray *contents = [@[] mutableCopy];
  self.action = [[NITableViewActions alloc] initWithTarget:self];
  if (self.topic) {
    for (ReplyInfoModel *item in self.topic.replies) {
      CommentItemCellUserData *userData =
          [[CommentItemCellUserData alloc] init];
      userData.reply = item;
      [contents addObject:[self.action
                              attachToObject:
                                  [[NICellObject alloc]
                                      initWithCellClass:[CommentItemCell class]
                                               userInfo:userData]
                                 tapSelector:@selector(itemClicked:)]];
    }
  }

  self.tableView.delegate = [self.action forwardingTo:self];
  [self setTableData:contents];
}

- (void)itemClicked:(NICellObject *)cellObj {
  CommentItemCellUserData *userData = cellObj.userInfo;
  ReplyDetailViewController *detailVC =
      [[ReplyDetailViewController alloc] initWithNibName:nil bundle:nil];
  detailVC.curReply = userData.reply;
  detailVC.replyList = self.topic.replies;
  [self.navigationController pushViewController:detailVC animated:YES];
}
@end
