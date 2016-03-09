//
//  MessageViewController.m
//  CNode
//
//  Created by George She on 16/3/9.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "MessageViewController.h"
#import "AppDelegate.h"
#import "MessageListViewController.h"
#import "MessageListModel.h"

@interface MessageViewController ()
@property(nonatomic, strong)
    MessageListViewController *readMessageViewController;
@property(nonatomic, strong)
    MessageListViewController *unreadMessageViewController;
@property(nonatomic, strong) UIViewController *currentVC;
@property(nonatomic, strong) MessageListModel *allMessage;
@end

@implementation MessageViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  UISegmentedControl *segmentedControl =
      [[UISegmentedControl alloc] initWithItems:nil];
  [segmentedControl insertSegmentWithTitle:@"未读消息" atIndex:0 animated:NO];
  [segmentedControl insertSegmentWithTitle:@"已读消息" atIndex:1 animated:NO];
  [segmentedControl addTarget:self
                       action:@selector(controlPressed:)
             forControlEvents:UIControlEventValueChanged];
  segmentedControl.selectedSegmentIndex = 0;
  self.navigationItem.titleView = segmentedControl;
  self.navigationItem.leftBarButtonItem =
      [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(openLeftDrawer)];
  _unreadMessageViewController =
      [[MessageListViewController alloc] initWithNibName:nil bundle:nil];
  _unreadMessageViewController.isForUnreadMessage = YES;
  _readMessageViewController =
      [[MessageListViewController alloc] initWithNibName:nil bundle:nil];
  _readMessageViewController.isForUnreadMessage = NO;
  [self requestData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)requestData {
  [self showHUD];
  FDWeakSelf;
  [[UserManager sharedInstance]
      requestUserMessage:^(MessageListModel *data, NSError *error) {
        FDStrongSelf;
        _allMessage = data;
        [self updateSubVC];
        [self hideAllHUDs];
      }];
}

- (void)updateSubVC {
  self.readMessageViewController.message = _allMessage.has_read_messages;
  self.unreadMessageViewController.message = _allMessage.hasnot_read_messages;
}

- (void)controlPressed:(UISegmentedControl *)sender {
  if (_currentVC) {
    [_currentVC removeFromParentViewController];
    [_currentVC.view removeFromSuperview];
  }
  UIViewController *selectedVC = nil;

  NSInteger selectedSegment = sender.selectedSegmentIndex;
  if (selectedSegment == 0) {
    selectedVC = _unreadMessageViewController;
  } else {
    selectedVC = _readMessageViewController;
  }

  [self addChildViewController:selectedVC];
  [self.view addSubview:selectedVC.view];

  selectedVC.view.alpha = 0.f;
  [UIView animateWithDuration:0.4f
      animations:^{
        selectedVC.view.alpha = 1.0f;
      }
      completion:^(BOOL finished) {
        _currentVC = selectedVC;
      }];
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

@end
