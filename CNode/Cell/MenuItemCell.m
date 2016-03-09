//
//  LeftItemCell.m
//  CNode
//
//  Created by George She on 16/3/9.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "MenuItemCell.h"

@implementation MenuItemCellUserData
@end
@interface MenuItemCell ()
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UIImageView *itemImageView;
@property(nonatomic, strong) UILabel *badgeLabel;
@end

@implementation MenuItemCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.backgroundColor = [UIColor clearColor];

    self.nameLabel = [UILabel new];
    self.nameLabel.font = Font_15_B;
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.textColor = [UIColor ex_mainTextColor];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;

    self.badgeLabel = [UILabel new];
    self.badgeLabel.font = Font_12;
    self.badgeLabel.textColor = [UIColor whiteColor];
    self.badgeLabel.textAlignment = NSTextAlignmentCenter;
    self.badgeLabel.backgroundColor = [UIColor redColor];
    self.badgeLabel.layer.cornerRadius = 4;
    self.badgeLabel.clipsToBounds = YES;

    self.itemImageView = [[UIImageView alloc] init];

    self.clipsToBounds = YES;
    [self.contentView addSubview:self.itemImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.badgeLabel];
    [self makeConstraint];
  }
  return self;
}

- (void)makeConstraint {
  [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.itemImageView.mas_right).offset(15);
    make.centerY.equalTo(self.contentView);
  }];

  [self.itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.contentView).offset(15);
    make.centerY.equalTo(self.contentView);
    make.width.mas_equalTo(25);
    make.height.mas_equalTo(25);
  }];

  [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.contentView).offset(15);
    make.centerY.equalTo(self.contentView);
  }];
}

- (void)dealloc {
  self.userData = nil;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.nameLabel.text = nil;
  self.itemImageView.image = nil;
}

+ (CGFloat)heightForObject:(id)object
               atIndexPath:(NSIndexPath *)indexPath
                 tableView:(UITableView *)tableView {

  return 44;
}

- (BOOL)shouldUpdateCellWithObject:(NICellObject *)object {
  self.userData = (MenuItemCellUserData *)object.userInfo;
  if (self.userData.menuItem.isSelected) {
    self.backgroundColor = [UIColor ex_globalBackgroundColor];
    self.nameLabel.font = Font_15_B;
  } else {
    self.backgroundColor = [UIColor whiteColor];
    self.nameLabel.font = Font_13;
  }
  self.nameLabel.text = self.userData.menuItem.name;
  self.itemImageView.image = [UIImage imageNamed:self.userData.menuItem.image];
  if (self.userData.menuItem.badgeCount > 0) {
    self.badgeLabel.hidden = NO;
    self.badgeLabel.text =
        [NSString stringWithFormat:@"%ld", self.userData.menuItem.badgeCount];
  } else {
    self.badgeLabel.hidden = YES;
  }
  [self setNeedsLayout];
  return YES;
}

+ (NICellObject *)createObject:(id)_delegate userData:(id)_userData {
  MenuItemCellUserData *userData = [[MenuItemCellUserData alloc] init];
  NICellObject *cellObj =
      [[NICellObject alloc] initWithCellClass:[MenuItemCell class]
                                     userInfo:userData];
  return cellObj;
}

@end
