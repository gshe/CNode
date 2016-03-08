//
//  DetailViewController.m
//  CNode
//
//  Created by George She on 16/3/7.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "DetailViewController.h"
#import "WFToastView.h"
#import "FDWebViewController.h"
#import "WFLoadingView.h"
#import "RepliesListViewController.h"

@interface DetailViewController () <UIWebViewDelegate, UIScrollViewDelegate>
@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) UIBarButtonItem *goBackButton;
@property(nonatomic, strong) UIBarButtonItem *nextButton;
@property(nonatomic, strong) UIButton *votedButton;
@property(nonatomic, strong) UIBarButtonItem *votedBarButton;
@property(nonatomic, strong) UIBarButtonItem *shareButton;
@property(nonatomic, strong) UIButton *commentButton;
@property(nonatomic, strong) UIBarButtonItem *commentBarButton;
@property(nonatomic, strong) UIView *containerView;

@property(nonatomic, strong) WFLoadingView *loadingView;
@property(nonatomic, assign) BOOL isLoading;
@property(nonatomic, strong) TopicInfoModel *curDetailTopic;
@end

@implementation DetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self configUI];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)configUI {
  self.containerView = [UIView new];
  [self.view addSubview:self.containerView];

  self.webView = [[UIWebView alloc] init];
  self.webView.delegate = self;
  self.webView.scrollView.delegate = self;

  [self.containerView addSubview:self.webView];
  self.view.backgroundColor = [UIColor whiteColor];

  [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view);
    make.right.equalTo(self.view);
    make.top.equalTo(self.view);
    make.bottom.equalTo(self.view);
  }];

  [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.containerView);
    make.right.equalTo(self.containerView);
    make.top.equalTo(_containerView);
    make.bottom.equalTo(self.containerView);
  }];

  self.goBackButton =
      [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(goBackPressed:)];
  self.nextButton =
      [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forward"]
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(nextPressed:)];
  self.votedButton = [UIButton buttonWithType:UIButtonTypeCustom];
  UIImage *votedImg = [UIImage imageNamed:@"thumb_up"];
  [self.votedButton setImage:votedImg forState:UIControlStateNormal];
  [self.votedButton addTarget:self
                       action:@selector(votedPressed:)
             forControlEvents:UIControlEventTouchUpInside];
  self.votedButton.titleLabel.font = Font_10;
  [self.votedButton setTitleColor:[UIColor ex_mainTextColor]
                         forState:UIControlStateNormal];
  self.votedButton.tintColor = [UIColor lightGrayColor];
  self.votedButton.frame =
      CGRectMake(0, 0, votedImg.size.width, votedImg.size.height);
  self.votedBarButton =
      [[UIBarButtonItem alloc] initWithCustomView:self.votedButton];

  self.shareButton =
      [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"]
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(sharePressed:)];
  self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
  UIImage *commentImg = [UIImage imageNamed:@"comments"];
  [self.commentButton setImage:commentImg forState:UIControlStateNormal];
  [self.commentButton addTarget:self
                         action:@selector(commentPressed:)
               forControlEvents:UIControlEventTouchUpInside];
  self.commentButton.titleLabel.font = Font_10;
  [self.commentButton setTitleColor:[UIColor ex_mainTextColor]
                           forState:UIControlStateNormal];
  self.commentButton.tintColor = [UIColor lightGrayColor];
  self.commentButton.frame =
      CGRectMake(0, 0, votedImg.size.width, votedImg.size.height);
  self.commentBarButton =
      [[UIBarButtonItem alloc] initWithCustomView:self.commentButton];
  UIBarButtonItem *flexItem = [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                           target:nil
                           action:nil];
  [self
      setToolbarItems:[NSArray arrayWithObjects:flexItem, self.goBackButton,
                                                flexItem, self.nextButton,
                                                flexItem, self.votedBarButton,
                                                flexItem, self.shareButton,
                                                flexItem, self.commentBarButton,
                                                flexItem, nil]
             animated:YES];
  [self requestTopicDetail];
}

- (void)refreshUI {
  //  [[ItemDatabase sharedInstance]
  //  itemReadByUser:self.storyDataModel.storyId];
  //  if ([self.delegate respondsToSelector:@selector(itemReadNotify:)]) {
  //    [self.delegate itemReadNotify:self.storyDataModel];
  //  }

  [self.loadingView dismissLoadingView];
  [self refreshToolbarStatus];
  if (self.curDetailTopic) {
    self.title = self.curDetailTopic.title;
    NSString *htmlStr = [self generateHtml];
    [_webView loadHTMLString:htmlStr baseURL:nil];
    [self.votedButton
        setTitle:[NSString
                     stringWithFormat:@"%ld", self.curDetailTopic.visit_count]
        forState:UIControlStateNormal];
    [self.votedButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 18, 0)];
    [self.commentButton
        setTitle:[NSString
                     stringWithFormat:@"%ld", self.curDetailTopic.reply_count]
        forState:UIControlStateNormal];
    [self.commentButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -48, 18, 0)];
  }
  _isLoading = NO;
}

- (NSString *)generateHtml {
  return self.curDetailTopic.content;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  if (_webView.scrollView.contentOffset.y >= 200) {
    [[UIApplication sharedApplication]
        setStatusBarStyle:UIStatusBarStyleDefault];

  } else {
    [[UIApplication sharedApplication]
        setStatusBarStyle:UIStatusBarStyleLightContent];
  }

  [UIView animateWithDuration:0.25
                   animations:^{
                     self.navigationController.toolbarHidden = NO;
                   }];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:YES];
  [[UIApplication sharedApplication]
      setStatusBarStyle:UIStatusBarStyleLightContent];
  self.navigationController.toolbarHidden = YES;
}

- (void)goBackPressed:(id)sender {
  [self getPreviousNews];
}

- (void)nextPressed:(id)sender {
  [self getNextNews];
}

- (void)sharePressed:(id)sender {
  [[WFToastView class] showMsg:@"已分享！" inView:nil];
}

- (void)votedPressed:(id)sender {
  [[WFToastView class] showMsg:@"已赞！" inView:nil];
}

- (void)commentPressed:(id)sender {
  RepliesListViewController *commentVC =
      [[RepliesListViewController alloc] initWithNibName:nil bundle:nil];
  commentVC.topic = self.curDetailTopic;
  [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)getNextNews {
  if (_isLoading) {
    return;
  }
  FDWeakSelf;
  [UIView animateWithDuration:0.25
      delay:0
      options:UIViewAnimationOptionCurveEaseIn
      animations:^{
        self.containerView.frame =
            CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight);
      }
      completion:^(BOOL finished) {
        FDStrongSelf;
        [self.view insertSubview:self.loadingView belowSubview:self.webView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC),
                       dispatch_get_main_queue(), ^{
                         self.containerView.frame =
                             CGRectMake(0, 0, kScreenWidth, kScreenHeight);
                         NSUInteger index =
                             [self.topicIdList indexOfObject:self.topicId];
                         if (index < self.topicIdList.count - 1) {
                           self.topicId = self.topicIdList[index + 1];
                           self.curDetailTopic = nil;
                         }
                         [self requestTopicDetail];
                       });

      }];
}

- (void)requestTopicDetail {
  if (_isLoading) {
    return;
  }
  _isLoading = YES;
  FDWeakSelf;
  [[TopicManager sharedInstance]
      requestTopicDetailWithId:self.topicId
                completedBlock:^(TopicInfoModel *data, NSError *error) {
                  FDStrongSelf;
                  if (data) {
                    self.curDetailTopic = data;
                  }
                  [self.loadingView dismissLoadingView];
                  [self refreshUI];
                }];
}

- (void)getPreviousNews {
  if (_isLoading) {
    return;
  }
  FDWeakSelf;
  [UIView animateWithDuration:0.25
      delay:0
      options:UIViewAnimationOptionCurveEaseIn
      animations:^{
        self.containerView.frame =
            CGRectMake(0, kScreenHeight + 40, kScreenWidth, kScreenHeight);
      }
      completion:^(BOOL finished) {
        FDStrongSelf;
        [self.view insertSubview:self.loadingView belowSubview:self.webView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC),
                       dispatch_get_main_queue(), ^{
                         self.containerView.frame =
                             CGRectMake(0, 0, kScreenWidth, kScreenHeight);
                         NSUInteger index =
                             [self.topicIdList indexOfObject:self.topicId];
                         if (index > 0 && index < self.topicIdList.count) {
                           self.topicId = self.topicIdList[index - 1];
                         }
                         [self requestTopicDetail];
                       });

      }];
}

- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
                navigationType:(UIWebViewNavigationType)navigationType {
  if (navigationType == UIWebViewNavigationTypeLinkClicked) {
    FDWebViewController *webVC =
        [[FDWebViewController alloc] initWithNibName:nil bundle:nil];
    webVC.title = self.curDetailTopic.title;
    webVC.urlString = request.URL.absoluteString;
    [self.navigationController pushViewController:webVC animated:YES];
    return NO;
  }
  return YES;
}

- (void)refreshToolbarStatus {
  NSUInteger index = [self.topicIdList indexOfObject:self.topicId];
  if (index == self.topicIdList.count - 1) {
    self.nextButton.enabled = NO;
  } else {
    self.nextButton.enabled = YES;
  }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

  CGFloat offSetY = scrollView.contentOffset.y;

  if (-offSetY <= 80 && -offSetY >= 0) {

    if (-offSetY > 40 && !_webView.scrollView.isDragging) {

      [self getPreviousNews];
    }
  } else if (-offSetY > 80) { //到－80 让webview不再能被拉动

    _webView.scrollView.contentOffset = CGPointMake(0, -80);

  } else if (offSetY <= 300) {
  }

  if (offSetY + kScreenHeight > scrollView.contentSize.height + 160 &&
      !_webView.scrollView.isDragging) {

    [self getNextNews];
  }

  if (offSetY >= 200) {

    [[UIApplication sharedApplication]
        setStatusBarStyle:UIStatusBarStyleDefault];

  } else {

    [[UIApplication sharedApplication]
        setStatusBarStyle:UIStatusBarStyleLightContent];
  }
}
#pragma mark - Getter
- (WFLoadingView *)loadingView {

  if (!_loadingView) {
    _loadingView = [[WFLoadingView alloc]
        initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
  }

  return _loadingView;
}

@end
