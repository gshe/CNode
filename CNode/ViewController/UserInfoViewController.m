//
//  UserInfoViewController.m
//  CNode
//
//  Created by George She on 16/3/7.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "UserInfoViewController.h"
#import "TopicItemCell.h"
#import "CommentItemCell.h"
#import "DetailViewController.h"

@interface UserInfoViewController ()
@property(nonatomic, strong) UserInfoModel *userInfo;
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self requestData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)requestData {

  [self showHUD];
  FDWeakSelf;
  [[UserManager sharedInstance]
      requestUserWithLoginName:self.loginName
                completedBlock:^(UserInfoModel *userInfo, NSError *error) {
                  FDStrongSelf;
                  _userInfo = userInfo;
                  [self refreshUI];
                }];
}

- (void)refreshUI {

  NSMutableArray *contents = [@[] mutableCopy];
  self.action = [[NITableViewActions alloc] initWithTarget:self];
  if (self.userInfo) {
    [contents addObject:@"最近主题"];
    for (TopicInfoModel *item in self.userInfo.recent_topics) {
      TopicItemCellUserData *userData = [[TopicItemCellUserData alloc] init];
      userData.topic = item;
      [contents
          addObject:[self.action attachToObject:
                                     [[NICellObject alloc]
                                         initWithCellClass:[TopicItemCell class]
                                                  userInfo:userData]
                                    tapSelector:@selector(topicItemClicked:)]];
    }
    [contents addObject:@"最近回复"];
    for (ReplyInfoModel *item in self.userInfo.recent_replies) {
      CommentItemCellUserData *userData =
          [[CommentItemCellUserData alloc] init];
      userData.reply = item;
      [contents addObject:[self.action
                              attachToObject:
                                  [[NICellObject alloc]
                                      initWithCellClass:[CommentItemCell class]
                                               userInfo:userData]
                                 tapSelector:@selector(commentItemClicked:)]];
    }
  }

  self.tableView.delegate = [self.action forwardingTo:self];
  [self setTableData:contents];
}

- (void)topicItemClicked:(NICellObject *)sender {
  TopicItemCellUserData *userData = sender.userInfo;
  DetailViewController *detailVC =
      [[DetailViewController alloc] initWithNibName:nil bundle:nil];
  detailVC.topicId = userData.topic.topicId;
  detailVC.topicIdList = getTopicIdList(self.userInfo.recent_topics);
  [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)commentItemClicked:(NICellObject *)sender {
  TopicItemCellUserData *userData = sender.userInfo;
  DetailViewController *detailVC =
      [[DetailViewController alloc] initWithNibName:nil bundle:nil];
  detailVC.topicId = userData.topic.topicId;
  detailVC.topicIdList = getReplyIdList(self.userInfo.recent_replies);
  [self.navigationController pushViewController:detailVC animated:YES];
}

@end
