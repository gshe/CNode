//
//  DetailViewController.m
//  CNode
//
//  Created by George She on 16/3/7.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "ReplyDetailViewController.h"
#import "WFToastView.h"
#import "FDWebViewController.h"
#import "WFLoadingView.h"
#import "RepliesListViewController.h"
#import "TextInputView.h"
#import "WriteCommentResultModel.h"

@interface ReplyDetailViewController () <
    UIWebViewDelegate, UIScrollViewDelegate, UITextFieldDelegate>
@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) UIView *containerView;

@property(nonatomic, strong) WFLoadingView *loadingView;
@property(nonatomic, assign) BOOL isLoading;
@property(nonatomic, strong) UIView *commentView;
@end

@implementation ReplyDetailViewController

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
  [_commentView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view);
    make.right.equalTo(self.view);
    make.bottom.equalTo(self.view);
    make.height.mas_equalTo(44);

  }];

  [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.containerView);
    make.right.equalTo(self.containerView);
    make.top.equalTo(_containerView);
    make.bottom.equalTo(_commentView.mas_top);
  }];
  [self configCommentView];
  [self refreshUI];
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
  [self.loadingView dismissLoadingView];
  if (self.curReply) {
    NSString *htmlStr = [self generateHtml];
    [_webView loadHTMLString:htmlStr baseURL:nil];
  }
}

- (NSString *)generateHtml {
  return self.curReply.content;
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
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:YES];
  [[UIApplication sharedApplication]
      setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)getNextNews {
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
                             [self.replyList indexOfObject:self.curReply];
                         if (index < self.replyList.count - 1) {
                           self.curReply = self.replyList[index + 1];
                         }
                         [self refreshUI];
                       });

      }];
}

- (void)getPreviousNews {
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
                             [self.replyList indexOfObject:self.curReply];
                         if (index > 0 && index < self.replyList.count) {
                           self.curReply = self.replyList[index - 1];
                         }
                         [self refreshUI];
                       });

      }];
}

- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
                navigationType:(UIWebViewNavigationType)navigationType {
  if (navigationType == UIWebViewNavigationTypeLinkClicked) {
    FDWebViewController *webVC =
        [[FDWebViewController alloc] initWithNibName:nil bundle:nil];
    webVC.title = self.curReply.title;
    webVC.urlString = request.URL.absoluteString;
    [self.navigationController pushViewController:webVC animated:YES];
    return NO;
  }
  return YES;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  //
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
#pragma mark - Getter
- (WFLoadingView *)loadingView {

  if (!_loadingView) {
    _loadingView = [[WFLoadingView alloc]
        initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
  }

  return _loadingView;
}

- (void)writeCommentToTopic:(NSString *)comment {
  if (!comment || comment.length == 0) {
    [WFToastView showMsg:@"字段没填哦！" inView:nil];
    return;
  }

  [self showHUD];
  FDWeakSelf;
  [[TopicManager sharedInstance]
      writeCommentToTopic:self.topic.topicId
                  replyId:self.curReply.replyId
                  content:comment
           completedBlock:^(WriteCommentResultModel *data, NSError *error) {
             FDStrongSelf;
             [self hideAllHUDs];
           }];
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
