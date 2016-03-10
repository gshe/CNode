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
#import "RecommendersView.h"
#import "UserInfoViewController.h"
#import "TextInputView.h"
#import "WriteCommentResultModel.h"

@interface DetailViewController () <UIWebViewDelegate, UIScrollViewDelegate,
                                    UITextFieldDelegate>
@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, strong) RecommendersView *authorView;
@property(nonatomic, strong) WFLoadingView *loadingView;
@property(nonatomic, assign) BOOL isLoading;
@property(nonatomic, strong) TopicInfoModel *curDetailTopic;
@property(nonatomic, strong) UIView *commentView;
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
  _commentView = [UIView new];
  _commentView.backgroundColor = [UIColor ex_globalBackgroundColor];
  [_containerView addSubview:_commentView];
  _authorView = [[RecommendersView alloc] initWithFrame:CGRectZero];
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(authorInfoPressed:)];
  [_authorView addGestureRecognizer:tapGesture];
  self.webView = [[UIWebView alloc] init];
  self.webView.delegate = self;
  self.webView.scrollView.delegate = self;
  [self.containerView addSubview:self.authorView];
  [self.containerView addSubview:self.webView];
  self.view.backgroundColor = [UIColor whiteColor];

  [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view);
    make.right.equalTo(self.view);
    make.top.equalTo(self.view);
    make.bottom.equalTo(self.view);
  }];
  [_authorView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view);
    make.right.equalTo(self.view);
    make.top.equalTo(self.view);
    make.height.mas_equalTo(56);
  }];
  [_commentView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view);
    make.right.equalTo(self.view);
    make.bottom.equalTo(self.view);
    make.height.mas_equalTo(44);

  }];
  [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.containerView);
    make.right.equalTo(self.containerView);
    make.top.equalTo(_authorView.mas_bottom);
    make.bottom.equalTo(_commentView.mas_top);
  }];

  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@"看评论"
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(commentPressed:)];
  [self configCommentView];
  [self requestTopicDetail];
}

- (void)configCommentView {
  UITextField *writeComment = [UITextField new];
  writeComment.layer.cornerRadius = 5;
  writeComment.placeholder = @"写评论";
  writeComment.delegate = self;
  writeComment.backgroundColor = [UIColor whiteColor];
  [_commentView addSubview:writeComment];
  [writeComment mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(_commentView).offset(15);
    make.right.equalTo(_commentView).offset(-15);
    make.centerY.equalTo(_commentView);
    make.height.mas_equalTo(25);
  }];
}

- (void)refreshUI {
  //  [[ItemDatabase sharedInstance]
  //  itemReadByUser:self.storyDataModel.storyId];
  //  if ([self.delegate respondsToSelector:@selector(itemReadNotify:)]) {
  //    [self.delegate itemReadNotify:self.storyDataModel];
  //  }

  [self.loadingView dismissLoadingView];
  if (self.curDetailTopic) {
    self.authorView.author = self.curDetailTopic.author_loginname;
    self.authorView.authorUrl = self.curDetailTopic.author_avatar_url;
    self.title = self.curDetailTopic.title;
    NSString *htmlStr = [self generateHtml];
    [_webView loadHTMLString:htmlStr baseURL:nil];
  }
  _isLoading = NO;
}

- (NSString *)generateHtml {
  return self.curDetailTopic.content;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:YES];
}

//- (void)sharePressed:(id)sender {
//  [[WFToastView class] showMsg:@"已分享！" inView:nil];
//}
//
//- (void)votedPressed:(id)sender {
//  [[WFToastView class] showMsg:@"已赞！" inView:nil];
//}
- (void)authorInfoPressed:(id)sender {
  UserInfoViewController *userVC =
      [[UserInfoViewController alloc] initWithNibName:nil bundle:nil];
  userVC.loginName = self.curDetailTopic.author_loginname;
  [self.navigationController pushViewController:userVC animated:YES];
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

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

  //  CGFloat offSetY = scrollView.contentOffset.y;
  //
  //  if (-offSetY <= 80 && -offSetY >= 0) {
  //
  //    if (-offSetY > 40 && !_webView.scrollView.isDragging) {
  //
  //      [self getPreviousNews];
  //    }
  //  } else if (-offSetY > 80) { //到－80 让webview不再能被拉动
  //
  //    _webView.scrollView.contentOffset = CGPointMake(0, -80);
  //
  //  } else if (offSetY <= 300) {
  //  }
  //
  //  if (offSetY + kScreenHeight > scrollView.contentSize.height + 160 &&
  //      !_webView.scrollView.isDragging) {
  //
  //    [self getNextNews];
  //  }
  //
  //  if (offSetY >= 200) {
  //
  //    [[UIApplication sharedApplication]
  //        setStatusBarStyle:UIStatusBarStyleDefault];
  //
  //  } else {
  //
  //    [[UIApplication sharedApplication]
  //        setStatusBarStyle:UIStatusBarStyleLightContent];
  //  }
}
- (void)writeCommentToTopic:(NSString *)comment {
  if (!comment || comment.length == 0) {
    [WFToastView showMsg:@"字段没填哦！" inView:nil];
    return;
  }

  [self showHUD];
  FDWeakSelf;
  [[TopicManager sharedInstance]
      writeCommentToTopic:self.topicId
                  replyId:nil
                  content:comment
           completedBlock:^(WriteCommentResultModel *data, NSError *error) {
             FDStrongSelf;
             [self requestTopicDetail];
             [self hideAllHUDs];
           }];
}

#pragma mark - Getter
- (WFLoadingView *)loadingView {

  if (!_loadingView) {
    _loadingView = [[WFLoadingView alloc]
        initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
  }

  return _loadingView;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  [textField resignFirstResponder];
  TextInputView *textInputView =
      [[TextInputView alloc] initWithFrame:CGRectZero];
  textInputView.placeholder = @"输入评论";
  textInputView.textInputViewEnd = ^(NSString *comment) {
    [self writeCommentToTopic:comment];
  };
        [textInputView show];
	return NO;
}


@end
