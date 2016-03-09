//
//  LeftItemCell.m
//  CNode
//
//  Created by George She on 16/3/9.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "LeftItemCell.h"
@implementation LeftItemCellUserData
@end
@interface LeftItemCell ()
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UIImageView *itemImageView;
@end

@implementation LeftItemCell
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

    self.itemImageView = [[UIImageView alloc] init];

    self.clipsToBounds = YES;
    [self.contentView addSubview:self.itemImageView];
    [self.contentView addSubview:self.nameLabel];
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
  self.userData = (LeftItemCellUserData *)object.userInfo;
  self.nameLabel.text = self.userData.name;
  self.itemImageView.image = [UIImage imageNamed:self.userData.image];
  [self setNeedsLayout];
  return YES;
}

+ (NICellObject *)createObject:(id)_delegate userData:(id)_userData {
  LeftItemCellUserData *userData = [[LeftItemCellUserData alloc] init];
  NICellObject *cellObj =
      [[NICellObject alloc] initWithCellClass:[LeftItemCell class]
                                     userInfo:userData];
  return cellObj;
}

@end
