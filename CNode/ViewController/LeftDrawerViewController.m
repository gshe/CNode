//
//  LeftDrawerViewController.m
//  ZhihuDaily
//
//  Created by George She on 16/2/24.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "LeftDrawerViewController.h"
#import "LoginViewController.h"
#import "LeftItemCell.h"

@interface LeftDrawerViewController () <NIMutableTableViewModelDelegate,
                                        UITableViewDelegate>
@property(nonatomic, strong) UITableView *menuTable;
@property(nonatomic, strong) UIView *topView;
//@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) UIImageView *avatarImg;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) NIMutableTableViewModel *model;
@property(nonatomic, strong) NITableViewActions *action;

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

- (void)configUI {
  _topView = [UIView new];
  _topView.backgroundColor = [UIColor ex_blueTextColor];
  // _bottomView = [UIView new];
  _menuTable = [UITableView new];
  _menuTable.backgroundColor = [UIColor whiteColor];
  _menuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.view addSubview:_topView];
  //[self.view addSubview:_bottomView];
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
  [avatarview addSubview:_nameLabel];
  [_topView addSubview:avatarview];

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
}

#pragma mark - Private methods -

- (void)loginButtonClicked:(id)sender {
  LoginViewController *loginVC =
      [[LoginViewController alloc] initWithNibName:nil bundle:nil];
  UINavigationController *naviVC =
      [[UINavigationController alloc] initWithRootViewController:loginVC];
  [self presentViewController:naviVC
                     animated:YES
                   completion:^{

                   }];
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
                                                    .curUser.loginname]
          placeholderImage:[UIImage imageNamed:@"Contacts"]];
    _nameLabel.text = [UserManager sharedInstance].curUser.loginname;

  } else {
    self.avatarImg.image = [UIImage imageNamed:@"Contacts"];
    _nameLabel.text = @"请登录";
  }

  NSArray *menuItemArray =
      [NSArray arrayWithObjects:@"首页", @"消息", @"收藏", nil];
  NSArray *menuItemImageArray =
      [NSArray arrayWithObjects:@"Home", @"Message", @"fav", nil];
  NSMutableArray *contents = [@[] mutableCopy];
  self.action = [[NITableViewActions alloc] initWithTarget:self];
  for (NSInteger index = 0; index < menuItemArray.count; index++) {
    LeftItemCellUserData *userData = [[LeftItemCellUserData alloc] init];
    userData.name = menuItemArray[index];
    userData.image = menuItemImageArray[index];
    [contents
        addObject:[self.action
                      attachToObject:[[NICellObject alloc]
                                         initWithCellClass:[LeftItemCell class]
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
  //  ChannelItemCellUserData *userData = sender.userInfo;
  //  ChannelItemDataModel *item = userData.channelItem;
  //  for (BaseViewController *vc in _controllers) {
  //    if (vc.channleModel.isSelected) {
  //      vc.channleModel.isSelected = NO;
  //    }
  //  }
  //
  //  item.isSelected = YES;
  //
  //  if ([self.delegate respondsToSelector:@selector(channelSelected:)]) {
  //    [self.delegate channelSelected:item.channelVC];
  //        }
}

@end
