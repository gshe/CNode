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
#import "UpOrDownResultModel.h"

@interface RepliesListViewController () <CommentItemCellDelegate>

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
      userData.delegate = self;
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
  detailVC.topic = self.topic;
  [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)commentCell:(CommentItemCell *)cell
     upImageClicked:(CommentItemCellUserData *)userData {
  ReplyInfoModel *reply = userData.reply;
  [[TopicManager sharedInstance]
      upOrDownTheReply:reply.replyId
        completedBlock:^(UpOrDownResultModel *data, NSError *error) {
          if (error || data.error_msg) {
            NSString *msg = [NSString
                stringWithFormat:@"点赞失败 [%@]",
                                 data.error_msg ? data.error_msg : error];
            [WFToastView showMsg:msg inView:nil];
          } else {
            [WFToastView showMsg:@"点赞成功" inView:nil];
            NSMutableArray *ups = [NSMutableArray arrayWithArray:reply.ups];
            if ([data.action isEqualToString:@"up"]) {
              [ups addObject:[UserManager sharedInstance].userId];
            } else {
              [ups removeObject:[UserManager sharedInstance].userId];
            }
            reply.ups = ups;
          }

          NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
          if (indexPath) {
            [self.tableView reloadRowsAtIndexPaths:@[ indexPath ]
                                  withRowAnimation:UITableViewRowAnimationFade];
          }

        }];
}

@end
