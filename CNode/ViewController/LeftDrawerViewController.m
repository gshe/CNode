//
//  LeftDrawerViewController.m
//  ZhihuDaily
//
//  Created by George She on 16/2/24.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "LeftDrawerViewController.h"
#import "LoginViewController.h"
#import "MenuItemCell.h"
#import "AppDelegate.h"
#import "TopicViewController.h"
#import "MessageViewController.h"
#import "UserInfoViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface LeftDrawerViewController () <NIMutableTableViewModelDelegate,
                                        UITableViewDelegate>
@property(nonatomic, strong) UITableView *menuTable;
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UIImageView *avatarImg;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *scoreLabel;
@property(nonatomic, strong) UIButton *logoutButton;

@property(nonatomic, strong) NIMutableTableViewModel *model;
@property(nonatomic, strong) NITableViewActions *action;
@property(nonatomic, strong) NSArray *menuItemArray;
@property(nonatomic, strong) MenuItemModel *messageMenu;
@end

@implementation LeftDrawerViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(loginStatusChanged)
             name:kLoginStatusChanged
           object:nil];
  [self createMenuItemArray];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self configUI];
  [self configTopView];
  [self refreshUI];
}

- (void)createMenuItemArray {
  MenuItemModel *allMenu = [[MenuItemModel alloc] init];
  allMenu.name = @"全部";
  allMenu.tab = nil;
  allMenu.image = @"all";
  allMenu.menuType = MenuItemType_All;
  allMenu.isSelected = YES;

  MenuItemModel *askMenu = [[MenuItemModel alloc] init];
  askMenu.name = @"问答";
  askMenu.tab = @"ask";
  askMenu.image = @"ask";
  askMenu.menuType = MenuItemType_Ask;
  askMenu.isSelected = NO;

  MenuItemModel *jobMenu = [[MenuItemModel alloc] init];
  jobMenu.name = @"招聘";
  jobMenu.image = @"job";
  jobMenu.tab = @"job";
  jobMenu.menuType = MenuItemType_Job;
  jobMenu.isSelected = NO;

  MenuItemModel *shareMenu = [[MenuItemModel alloc] init];
  shareMenu.name = @"分享";
  shareMenu.image = @"share";
  shareMenu.tab = @"share";
  shareMenu.menuType = MenuItemType_Share;
  shareMenu.isSelected = NO;

  MenuItemModel *goodMenu = [[MenuItemModel alloc] init];
  goodMenu.name = @"精华";
  goodMenu.image = @"good";
  goodMenu.tab = @"good";
  goodMenu.menuType = MenuItemType_Good;
  goodMenu.isSelected = NO;

  _messageMenu = [[MenuItemModel alloc] init];
  _messageMenu.name = @"消息";
  _messageMenu.image = @"Message";
  _messageMenu.menuType = MenuItemType_Message;
  _messageMenu.isSelected = NO;
  _menuItemArray =
      [NSArray arrayWithObjects:allMenu, askMenu, jobMenu, shareMenu, goodMenu,
                                _messageMenu, nil];
}

- (void)configUI {
  _topView = [UIView new];
  _topView.backgroundColor = [UIColor ex_blueTextColor];
  _menuTable = [UITableView new];
  _menuTable.backgroundColor = [UIColor whiteColor];
  _menuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.view addSubview:_topView];
  [self.view addSubview:_menuTable];

  [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(self.view);
    make.top.equalTo(self.view).offset(20);
    make.height.mas_equalTo(150);
  }];

  [_menuTable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(self.view);
    make.top.equalTo(_topView.mas_bottom);
    make.bottom.equalTo(self.view);
  }];
}

- (void)configTopView {
  UIView *avatarview = [UIView new];

  _avatarImg = [UIImageView new];
  _avatarImg.image = [UIImage imageNamed:@"Contacts"];
  _avatarImg.layer.cornerRadius = 44 / 2;
  _avatarImg.layer.borderColor = [UIColor whiteColor].CGColor;
  _avatarImg.layer.borderWidth = 2;
  _avatarImg.clipsToBounds = YES;

  UITapGestureRecognizer *tapGueture = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(loginButtonClicked:)];
  [avatarview addGestureRecognizer:tapGueture];
  [avatarview addSubview:_avatarImg];
  _nameLabel = [UILabel new];
  _nameLabel.text = @"请登录";
  _scoreLabel = [UILabel new];
  _scoreLabel.hidden = YES;
  _logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [_logoutButton setTitle:@"注销" forState:UIControlStateNormal];
  _logoutButton.hidden = YES;
  [_logoutButton addTarget:self
                    action:@selector(logoutButtonPressed:)
          forControlEvents:UIControlEventTouchUpInside];

  [avatarview addSubview:_nameLabel];
  [_topView addSubview:avatarview];
  [_topView addSubview:_scoreLabel];
  [_topView addSubview:_logoutButton];

  [avatarview mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(_topView).offset(15);
    make.right.equalTo(_topView).offset(-15);
    make.centerY.equalTo(_topView);
    make.height.mas_equalTo(44);
  }];

  [_avatarImg mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(avatarview);
    make.top.equalTo(avatarview);
    make.width.mas_equalTo(44);
    make.height.mas_equalTo(44);
  }];

  [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(_avatarImg.mas_right).offset(15);
    make.centerY.equalTo(_avatarImg);
  }];

  [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(_avatarImg.mas_right).offset(15);
    make.top.equalTo(_nameLabel.mas_bottom).offset(15);

  }];
  [_logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(_topView.mas_right).offset(-5);
    make.bottom.equalTo(_topView.mas_bottom).offset(-5);

  }];
}

#pragma mark - Private methods -
- (void)logoutButtonPressed:(id)sender {
  [[UserManager sharedInstance] logout];
}

- (void)loginButtonClicked:(id)sender {
  [self.mm_drawerController
      closeDrawerAnimated:YES
               completion:^(BOOL finished) {
                 if ([[UserManager sharedInstance] isUserLogin]) {
                   [self gotoUserInfoVC];
                 } else {
                   [self gotoLoginVC];
                 }
               }];
}

- (void)gotoLoginVC {
  LoginViewController *loginVC =
      [[LoginViewController alloc] initWithNibName:nil bundle:nil];
  UINavigationController *naviVC =
      [[UINavigationController alloc] initWithRootViewController:loginVC];
  [self presentViewController:naviVC animated:YES completion:nil];
}

- (void)gotoUserInfoVC {
  UserInfoViewController *userVC =
      [[UserInfoViewController alloc] initWithNibName:nil bundle:nil];
  userVC.loginName = [UserManager sharedInstance].curUser.loginname;
  [self.navigationController pushViewController:userVC animated:YES];
}

- (void)dealwith:(UIButton *)dealBtn {
  dealBtn.titleLabel.font = Font_12;
  [dealBtn setImageEdgeInsets:UIEdgeInsetsMake(-40, 0.f, 0.f, 0.f)];
  [dealBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -45, 0, 0)];
}

- (void)refreshUI {
  if ([UserManager sharedInstance].isUserLogin) {
    [self.avatarImg
        sd_setImageWithURL:[NSURL URLWithString:[UserManager sharedInstance]
                                                    .curUser.avatar_url]
          placeholderImage:[UIImage imageNamed:@"Contacts"]];
    _nameLabel.text = [UserManager sharedInstance].curUser.loginname;
    _scoreLabel.hidden = NO;
    _scoreLabel.text =
        [NSString stringWithFormat:@"积分:%ld",
                                   [UserManager sharedInstance].curUser.score];
    _logoutButton.hidden = NO;
  } else {
    self.avatarImg.image = [UIImage imageNamed:@"Contacts"];
    _nameLabel.text = @"请登录";
    _scoreLabel.hidden = YES;
    _logoutButton.hidden = YES;
  }

  _messageMenu.badgeCount = [UserManager sharedInstance].unreadMessageCount;

  NSMutableArray *contents = [@[] mutableCopy];
  self.action = [[NITableViewActions alloc] initWithTarget:self];
  for (NSInteger index = 0; index < _menuItemArray.count; index++) {
    if (_menuItemArray[index] == _messageMenu) {
      [contents addObject:@""];
    }

    MenuItemCellUserData *userData = [[MenuItemCellUserData alloc] init];
    userData.menuItem = _menuItemArray[index];
    [contents
        addObject:[self.action
                      attachToObject:[[NICellObject alloc]
                                         initWithCellClass:[MenuItemCell class]
                                                  userInfo:userData]
                         tapSelector:@selector(itemClicked:)]];
  }

  _menuTable.delegate = [self.action forwardingTo:self];
  [self setTableData:contents];
}

- (void)loginStatusChanged {
  [self refreshUI];
}

- (void)setTableData:(NSArray *)tableCells {
  NIDASSERT([NSThread isMainThread]);

  self.model =
      [[NIMutableTableViewModel alloc] initWithSectionedArray:tableCells
                                                     delegate:self];

  _menuTable.dataSource = _model;
  [_menuTable reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  return 10;
}

- (CGFloat)tableView:(UITableView *)aTableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [NICellFactory tableView:aTableView
          heightForRowAtIndexPath:indexPath
                            model:(NITableViewModel *)aTableView.dataSource];
}

#pragma mark - NIMutableTableViewModelDelegate

- (UITableViewCell *)tableViewModel:(NITableViewModel *)tableViewModel
                   cellForTableView:(UITableView *)tableView
                        atIndexPath:(NSIndexPath *)indexPath
                         withObject:(id)object {
  return [NICellFactory tableViewModel:tableViewModel
                      cellForTableView:tableView
                           atIndexPath:indexPath
                            withObject:object];
}

- (void)itemClicked:(NICellObject *)sender {
  MenuItemCellUserData *userData = sender.userInfo;
  [self changedCenterViewController:userData.menuItem];
}

- (void)changedCenterViewController:(MenuItemModel *)menuItem {
  if (menuItem.isSelected) {
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    return;
  }

  UIViewController *vc = nil;
  if (menuItem.menuType == MenuItemType_All ||
      menuItem.menuType == MenuItemType_Ask ||
      menuItem.menuType == MenuItemType_Job ||
      menuItem.menuType == MenuItemType_Share ||
      menuItem.menuType == MenuItemType_Good) {
    TopicViewController *topicVC =
        [[TopicViewController alloc] initWithNibName:nil bundle:nil];
    topicVC.menuItem = menuItem;
    vc = topicVC;
  } else if (menuItem.menuType == MenuItemType_Message) {
    vc = [[MessageViewController alloc] initWithNibName:nil bundle:nil];
  }

  [_menuItemArray
      enumerateObjectsUsingBlock:^(MenuItemModel *obj, NSUInteger idx,
                                   BOOL *_Nonnull stop) {
        obj.isSelected = NO;
      }];
  menuItem.isSelected = YES;

  UINavigationController *centerNaviVC =
      [[UINavigationController alloc] initWithRootViewController:vc];
  [self.mm_drawerController closeDrawerAnimated:YES
                                     completion:^(BOOL finished) {
                                       self.mm_drawerController
                                           .centerViewController = centerNaviVC;
                                     }];
}

@end
