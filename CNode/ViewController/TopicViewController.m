//
//  TopicViewController.m
//  CNode
//
//  Created by George She on 16/3/7.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicItemCell.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "FilterView.h"

@interface TopicViewController ()
@property(nonatomic, strong) NSString *tab;
@property(nonatomic, assign) NSInteger pageIndex;
@property(nonatomic, strong) NSMutableArray<TopicInfoModel> *topicList;
@end

@implementation TopicViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"主题";
  _topicList = [@[] mutableCopy];
  self.tableView.mj_header =
      [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                       refreshingAction:@selector(loadNewData)];
  [self.tableView.mj_header beginRefreshing];
  self.tableView.mj_footer = [MJRefreshAutoNormalFooter
      footerWithRefreshingTarget:self
                refreshingAction:@selector(loadMoreData)];

  self.navigationItem.leftBarButtonItem =
      [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"todo_list"]
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(openLeftDrawer)];
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"filter"]
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(openFilterPressed)];
}

- (void)openLeftDrawer {
  AppDelegate *appDelegate =
      (AppDelegate *)[[UIApplication sharedApplication] delegate];
  if ([appDelegate.window.rootViewController
          isKindOfClass:[MMDrawerController class]]) {
    MMDrawerController *mainVc =
        (MMDrawerController *)appDelegate.window.rootViewController;
    if (mainVc.openSide == MMDrawerSideLeft) {
      [mainVc closeDrawerAnimated:YES completion:nil];
    } else {
      [mainVc openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
  }
}

- (void)openFilterPressed {
  FilterView *v = [[FilterView alloc] initWithFrame:CGRectZero];
  v.curTab = _tab;
  v.selectedTabBlock = ^(NSString *tab) {
    _tab = tab;
    [self loadNewData];
  };
  [v show];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)loadNewData {
  _pageIndex = 1;
  FDWeakSelf;
  [[TopicManager sharedInstance]
      requestTopicWithPage:_pageIndex
              countPerPage:20
                       tab:_tab
            completedBlock:^(TopicListModel *data, NSError *error) {
              FDStrongSelf;
              [_topicList removeAllObjects];
              [self dealWithNewData:data error:error];
              [self refreshUI];
            }];
}

- (void)loadMoreData {
  _pageIndex++;
  FDWeakSelf;
  [[TopicManager sharedInstance]
      requestTopicWithPage:_pageIndex
              countPerPage:20
                       tab:_tab
            completedBlock:^(id data, NSError *error) {
              FDStrongSelf;
              [self dealWithMoreData:data error:error];
              [self refreshUI];
            }];
}

- (void)dealWithNewData:(TopicListModel *)data error:(NSError *)error {
  [self.tableView.mj_header endRefreshing];
  if (error || !data || data.data.count == 0) {
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    return;
  }

  [_topicList addObjectsFromArray:data.data];
  if (data.data.count < 20) {
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
  }
}

- (void)dealWithMoreData:(TopicListModel *)data error:(NSError *)error {
  if (error || !data || data.data.count == 0) {
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    return;
  }

  [_topicList addObjectsFromArray:data.data];
  if (data.data.count >= 20) {
    [self.tableView.mj_footer endRefreshing];
  } else {
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
  }
}

- (void)refreshUI {
  NSMutableArray *contents = [@[] mutableCopy];
  self.action = [[NITableViewActions alloc] initWithTarget:self];
  if (self.topicList) {
    for (TopicInfoModel *item in self.topicList) {
      TopicItemCellUserData *userData = [[TopicItemCellUserData alloc] init];
      userData.topic = item;
      [contents
          addObject:[self.action attachToObject:
                                     [[NICellObject alloc]
                                         initWithCellClass:[TopicItemCell class]
                                                  userInfo:userData]
                                    tapSelector:@selector(itemClicked:)]];
    }
  }

  self.tableView.delegate = [self.action forwardingTo:self];
  [self setTableData:contents];
}

- (void)itemClicked:(NICellObject *)sender {
  TopicItemCellUserData *userData = sender.userInfo;
  DetailViewController *detailVC =
      [[DetailViewController alloc] initWithNibName:nil bundle:nil];
  detailVC.topicId = userData.topic.topicId;
  detailVC.topicIdList = getTopicIdList(self.topicList);
  [self.navigationController pushViewController:detailVC animated:YES];
}
@end
