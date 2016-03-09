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
                  [self hideAllHUDs];
                }];
}

- (void)refreshUI {
  [self createHeaderView];
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

- (void)createHeaderView {
  UIView *headerView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), 120)];
  headerView.backgroundColor = [UIColor ex_globalBackgroundColor];
  UIImageView *authorAvatar = [[UIImageView alloc] init];
  authorAvatar.layer.cornerRadius = 22;
  authorAvatar.layer.borderWidth = 1;
  authorAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
  authorAvatar.clipsToBounds = YES;
  [headerView addSubview:authorAvatar];

  UILabel *loginNameLabel = [UILabel new];
  loginNameLabel.textColor = [UIColor ex_greenTextColor];
  loginNameLabel.font = Font_15_B;
  loginNameLabel.text = self.userInfo.loginname;
  [headerView addSubview:loginNameLabel];

  UILabel *scoreLabel = [UILabel new];
  scoreLabel.textColor = [UIColor ex_blueTextColor];
  scoreLabel.font = Font_12_B;
  scoreLabel.text =
      [NSString stringWithFormat:@"积分: %ld", self.userInfo.score];
  [headerView addSubview:scoreLabel];
  [authorAvatar
      sd_setImageWithURL:[NSURL URLWithString:self.userInfo.avatar_url]
        placeholderImage:[UIImage imageNamed:@"Contact"]];

  [authorAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(headerView).offset(15);
    make.centerX.equalTo(headerView);
    make.width.mas_equalTo(44);
    make.height.mas_equalTo(44);
  }];
  [loginNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(authorAvatar.mas_bottom).offset(5);
    make.centerX.equalTo(headerView);
  }];
  [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(loginNameLabel.mas_bottom).offset(5);
    make.centerX.equalTo(headerView);
  }];
  self.tableView.tableHeaderView = headerView;
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

}

@end
