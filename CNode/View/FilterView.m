//
//  FilterView.m
//  CNode
//
//  Created by George She on 16/3/8.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "FilterView.h"
@interface FilterView () <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, strong) UITableView *tabTableView;
@property(nonatomic, strong) NSArray *tabArray;
@property(nonatomic, strong) NSArray *tabDisplayArray;
@end

@implementation FilterView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
    [self addEvent];
    [self makeUI];
  }
  return self;
}

- (void)makeUI {
  _tabArray =
      [NSArray arrayWithObjects:@"无", @"ask", @"share", @"job", @"good", nil];
  _tabDisplayArray = [NSArray
      arrayWithObjects:@"无", @"问答", @"分享", @"招聘", @"精华", nil];

  _containerView = [[UIView alloc]
      initWithFrame:CGRectMake(WIDTH(self), 0, 150, HEIGHT(self))];
  _containerView.backgroundColor = [UIColor whiteColor];
  _containerView.layer.cornerRadius = 2;
  _containerView.layer.masksToBounds = YES;
  [self addSubview:_containerView];
  _tabTableView = [[UITableView alloc] initWithFrame:CGRectZero];
  _tabTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  _tabTableView.dataSource = self;
  _tabTableView.delegate = self;
  _tabTableView.showsVerticalScrollIndicator = NO;
  _tabTableView.showsHorizontalScrollIndicator = NO;
  _tabTableView.allowsSelection = YES;
  [_containerView addSubview:_tabTableView];
  [_tabTableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(_containerView);
    make.top.bottom.equalTo(_containerView);
  }];
}

#pragma mark - Action
- (void)show {
  [super show];
  CGRect blockViewRect = _containerView.frame;
  blockViewRect.origin.x -= 150;
  [UIView animateWithDuration:0.25
                   animations:^{
                     _containerView.frame = blockViewRect;
                   }];
}

- (void)dismiss {
  CGRect blockViewRect = _containerView.frame;
  blockViewRect.origin.x = HEIGHT(self);
  [UIView animateWithDuration:0.25
      animations:^{
        _containerView.frame = blockViewRect;
      }
      completion:^(BOOL finished) {
        [super dismiss];
      }];
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  return 64;
}

- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {
  UILabel *v =
      [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH(tableView), 44)];

  v.backgroundColor = [UIColor lightGrayColor];
  v.text = @"过滤器";
  v.textAlignment = NSTextAlignmentCenter;
  return v;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return _tabArray.count;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.selectedTabBlock) {
    if (indexPath.row == 0) {
      self.selectedTabBlock(nil);
    } else {
      self.selectedTabBlock(_tabArray[indexPath.row]);
    }
  }
  [self dismiss];
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CMainCell = @"CMainCell"; //  0

  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:CMainCell]; //   1
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CMainCell]; //  2
  }
  NSString *tab = _tabDisplayArray[indexPath.row];
  cell.textLabel.text = tab;
  if ([self isCellSelected:indexPath.row]) {
    cell.textLabel.font = Font_15_B;
    cell.textLabel.backgroundColor = [UIColor ex_globalBackgroundColor];
  } else {
    cell.textLabel.font = Font_13;
    cell.textLabel.backgroundColor = [UIColor whiteColor];
  }
  return cell;
}

- (BOOL)isCellSelected:(NSInteger)index {
  BOOL isSelected = NO;
  if (index == 0) {
    if (!_curTab) {
      isSelected = YES;
    }
  } else {
    if ([_curTab isEqualToString:_tabArray[index]]) {
      isSelected = YES;
    }
  }
  return isSelected;
}
@end
