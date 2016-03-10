//
//  NewTopicViewController.m
//  CNode
//
//  Created by George She on 16/3/10.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "NewTopicViewController.h"
#import <UIKit/UIKit.h>
#import "AHKActionSheet.h"
#import "PublishTopicResultModel.h"
#import "DetailViewController.h"

@interface NewTopicViewController ()
@property(nonatomic, strong) UITextField *titleField;
@property(nonatomic, strong) UIButton *tabButton;
@property(nonatomic, strong) UITextView *contentTextView;
@property(nonatomic, strong) NSString *curTab;
@end

@implementation NewTopicViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@"发布"
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(publicPressed:)];
  [self configUI];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)configUI {
  UILabel *titleLabel = [UILabel new];
  titleLabel.text = @"标题";
  titleLabel.textColor = [UIColor ex_greenTextColor];
  [self.view addSubview:titleLabel];
  _titleField = [UITextField new];
  _titleField.placeholder = @"请输入标题";
  _titleField.textAlignment = NSTextAlignmentLeft;
  [self.view addSubview:_titleField];
  UILabel *tabTipLabel = [UILabel new];
  tabTipLabel.text = @"标签";
  tabTipLabel.textColor = [UIColor ex_greenTextColor];
  [self.view addSubview:tabTipLabel];
  _tabButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [_tabButton setTitle:@"点击选择" forState:UIControlStateNormal];
  [_tabButton setTitleColor:[UIColor ex_blueTextColor]
                   forState:UIControlStateNormal];
  _tabButton.titleLabel.font = Font_12;
  [_tabButton addTarget:self
                 action:@selector(tabBUttonPressed:)
       forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_tabButton];
  UILabel *contentTipLabel = [UILabel new];
  contentTipLabel.text = @"内容";
  contentTipLabel.textColor = [UIColor ex_greenTextColor];
  [self.view addSubview:contentTipLabel];

  _contentTextView = [UITextView new];
  _contentTextView.backgroundColor = [UIColor ex_globalBackgroundColor];
  [self.view addSubview:_contentTextView];

  [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view).offset(15);
    make.top.equalTo(self.view).offset(15);
  }];

  [_titleField mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(titleLabel.mas_right).offset(15);
    make.top.equalTo(titleLabel);
    make.width.mas_equalTo(200);
  }];

  [tabTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view).offset(15);
    make.top.equalTo(titleLabel.mas_bottom).offset(15);
  }];
  [_tabButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(tabTipLabel.mas_right).offset(15);
    make.top.equalTo(tabTipLabel);
  }];
  [contentTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view).offset(15);
    make.top.equalTo(tabTipLabel.mas_bottom).offset(15);
  }];
  [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(contentTipLabel);
    make.top.equalTo(contentTipLabel.mas_bottom).offset(15);
    make.right.equalTo(self.view).offset(-15);
    make.bottom.equalTo(self.view).offset(-15);
  }];
}

- (void)publicPressed:(id)sender {
  if (_titleField.text.length == 0 || _contentTextView.text.length == 0) {
    [WFToastView showMsg:@"还有字段没填哦！" inView:nil];
    return;
  }

  [self showHUD];
  FDWeakSelf;
  [[TopicManager sharedInstance]
         publicTopic:_titleField.text
                 tab:_curTab
             content:_contentTextView.text
      completedBlock:^(PublishTopicResultModel *data, NSError *error) {
        FDStrongSelf;
        [self gotoDetailVC:data];
        [self hideAllHUDs];
      }];
}

- (void)gotoDetailVC:(PublishTopicResultModel *)data {
  if (data.success) {
    [WFToastView showMsg:@"发布成功" inView:nil];
  } else {
    NSString *title =
        [NSString stringWithFormat:@"发布失败：%@", data.error_msg];
    [WFToastView showMsg:title inView:nil];
  }

  [self.navigationController popoverPresentationController];
  if (data.topic_id) {
    DetailViewController *detailVC =
        [[DetailViewController alloc] initWithNibName:nil bundle:nil];
    detailVC.topicId = data.topic_id;
    [self.navigationController pushViewController:detailVC animated:YES];
  }
}

- (void)tabBUttonPressed:(id)sender {
  [_contentTextView resignFirstResponder];
  [_titleField resignFirstResponder];
  AHKActionSheet *actionSheet =
      [[AHKActionSheet alloc] initWithTitle:@"选择标签"];
  [actionSheet
      addButtonWithTitle:@"问答"
                    type:AHKActionSheetButtonTypeDefault
                 handler:^(AHKActionSheet *as) {
                   _curTab = @"ask";
                   [_tabButton setTitle:@"问答" forState:UIControlStateNormal];
                 }];
  [actionSheet
      addButtonWithTitle:@"招聘"
                    type:AHKActionSheetButtonTypeDefault
                 handler:^(AHKActionSheet *as) {
                   _curTab = @"job";
                   [_tabButton setTitle:@"招聘" forState:UIControlStateNormal];
                 }];
  [actionSheet
      addButtonWithTitle:@"分享"
                    type:AHKActionSheetButtonTypeDefault
                 handler:^(AHKActionSheet *as) {
                   _curTab = @"share";
                   [_tabButton setTitle:@"分享" forState:UIControlStateNormal];
                 }];
  if (!_curTab) {
    [actionSheet addButtonWithTitle:@"清除标签"
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                              _curTab = nil;
                              [_tabButton setTitle:@"点击选择"
                                          forState:UIControlStateNormal];
                            }];
        }
        [actionSheet show];
}
@end
