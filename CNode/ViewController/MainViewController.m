//
//  MainViewController.m
//  ZhihuDaily
//
//  Created by George She on 16/2/24.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "MainViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "TopicViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "TabListViewController.h"

@interface MainViewController ()
@property(nonatomic, strong) UIViewController *currentViewController;
@property(nonatomic, strong) UIViewController *containerController;

@property(nonatomic, strong) UINavigationController *topicViewController;
@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  _topicViewController = [[UINavigationController alloc]
      initWithRootViewController:
          [[TopicViewController alloc] initWithNibName:nil bundle:nil]];

  _containerController = [UIViewController new];
  _containerController.view.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:_containerController.view];

  [self showSelectedViewController];
}

//
//- (void)requestChannels {
//  FDWeakSelf;
//  [[ZhihuDataManager shardInstance]
//      requestChannelsWithSuccessBlock:^(ThemeListDataModel *json) {
//        FDStrongSelf;
//        _allThemes = json;
//        [self refreshTheme];
//      }
//      failed:^(NSError *error){
//
//      }];
//}
//
//- (void)refreshTheme {
//  for (ThemeDataModel *theme in _allThemes.subscribed) {
//    ChannelCommonViewController *themeVC =
//        [[ChannelCommonViewController alloc] initWithNibName:nil bundle:nil];
//    themeVC.channleModel = [[ChannelItemDataModel alloc] initWithInfo:theme
//                                                                   vc:themeVC
//                                                             selected:NO];
//    themeVC.channleModel.isSubscribed = YES;
//    [_controllers addObject:themeVC];
//
//    UINavigationController *naviVC =
//        [[UINavigationController alloc] initWithRootViewController:themeVC];
//    [_naviControllers addObject:naviVC];
//  }
//
//  for (ThemeDataModel *theme in _allThemes.others) {
//    ChannelCommonViewController *themeVC =
//        [[ChannelCommonViewController alloc] initWithNibName:nil bundle:nil];
//    themeVC.channleModel = [[ChannelItemDataModel alloc] initWithInfo:theme
//                                                                   vc:themeVC
//                                                             selected:NO];
//    themeVC.channleModel.isSubscribed = NO;
//    [_controllers addObject:themeVC];
//
//    UINavigationController *naviVC =
//        [[UINavigationController alloc] initWithRootViewController:themeVC];
//    [_naviControllers addObject:naviVC];
//  }
//  self.leftViewController.controllers = _controllers;
//}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

//#pragma LeftDrawerViewControllerDelegate
//- (void)channelSelected:(BaseViewController *)channelVC {
//  [self.mm_drawerController closeDrawerAnimated:YES
//                                     completion:^(BOOL finished) {
//                                       [self showSelectedViewController];
//                                     }];
//}

- (void)showSelectedViewController {
  if (_currentViewController != nil) { //如果不为nil移除最上面的视图控制器
    [_currentViewController.view removeFromSuperview];
    [_currentViewController removeFromParentViewController];
  }

  UIViewController *selectedNaviVC = self.topicViewController;
  [_containerController addChildViewController:selectedNaviVC];
  [_containerController.view addSubview:selectedNaviVC.view];

  selectedNaviVC.view.alpha = 0.f;
  [UIView animateWithDuration:0.4f
      animations:^{
        selectedNaviVC.view.alpha = 1.0f;
      }
      completion:^(BOOL finished) {
        _currentViewController = selectedNaviVC;
      }];
}

- (BOOL)isLeftDrawerShow {
  return (self.mm_drawerController.openSide == MMDrawerSideLeft);
}

- (void)showLeftDrawer {
  [self.mm_drawerController openDrawerSide:MMDrawerSideLeft
                                  animated:YES
                                completion:nil];
}

- (void)hideLeftDrawer {
  [self.mm_drawerController closeDrawerAnimated:YES
                                     completion:^(BOOL finished){

                                     }];
}
@end
