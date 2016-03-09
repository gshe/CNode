//
//  MessageCell.m
//  CNode
//
//  Created by George She on 16/3/9.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "MessageCell.h"
@implementation MessageCellUserData
@end

@interface MessageCell ()
@property(nonatomic, strong) UILabel *authorName;
@property(nonatomic, strong) UIImageView *authorAvatar;
@property(nonatomic, strong) UILabel *title;
@end

@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.contentView.backgroundColor = [UIColor whiteColor];

    self.title = [UILabel new];
    self.title.font = Font_13_B;
    self.title.numberOfLines = 1;
    self.title.textColor = [UIColor ex_mainTextColor];
    self.title.textAlignment = NSTextAlignmentLeft;
    self.title.lineBreakMode = NSLineBreakByTruncatingTail;

    self.authorName = [UILabel new];
    self.authorName.font = Font_13;
    self.authorName.textColor = [UIColor ex_subTextColor];
    self.authorName.numberOfLines = 1;
    self.authorName.lineBreakMode = NSLineBreakByWordWrapping;
    self.authorName.textAlignment = NSTextAlignmentLeft;

    self.authorAvatar = [[UIImageView alloc] init];
    self.authorAvatar.image = [UIImage imageNamed:@"new"];
    self.authorAvatar.layer.cornerRadius = 22;
    self.authorAvatar.layer.borderWidth = 1;
    self.authorAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    self.authorAvatar.clipsToBounds = YES;

    self.clipsToBounds = YES;
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.authorName];
    [self.contentView addSubview:self.authorAvatar];
    [self makeConstraint];
  }
  return self;
}

- (void)makeConstraint {
  [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.authorName.mas_bottom).offset(5);
    make.left.equalTo(self.authorAvatar.mas_right).offset(15);
    make.right.lessThanOrEqualTo(self.contentView).offset(-15);
  }];

  [self.authorName mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.authorAvatar);
    make.left.equalTo(self.authorAvatar.mas_right).offset(15);
    make.right.lessThanOrEqualTo(self.contentView).offset(-15);
  }];

  [self.authorAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.contentView).offset(15);
    make.top.equalTo(self.contentView).offset(5);
    make.height.mas_equalTo(44);
    make.width.mas_equalTo(44);
  }];
}

- (void)dealloc {
  self.userData = nil;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.title.text = nil;
  self.authorName.text = nil;
  self.authorAvatar.image = nil;
}

+ (CGFloat)heightForObject:(id)object
               atIndexPath:(NSIndexPath *)indexPath
                 tableView:(UITableView *)tableView {
  CGFloat height = 54;
  return height;
}

- (BOOL)shouldUpdateCellWithObject:(NICellObject *)object {
  self.userData = (MessageCellUserData *)object.userInfo;
  self.title.text = self.userData.message.messageType;

  self.authorName.text = self.userData.message.author_loginname;

  [self.authorAvatar
      sd_setImageWithURL:[NSURL URLWithString:self.userData.message
                                                  .author_avatar_url]
        placeholderImage:[UIImage imageNamed:@"avatar_default"]];
  [self setNeedsLayout];
  return YES;
}

+ (NICellObject *)createObject:(id)_delegate userData:(id)_userData {
  MessageCellUserData *userData = [[MessageCellUserData alloc] init];
  NICellObject *cellObj =
      [[NICellObject alloc] initWithCellClass:[MessageCell class]
                                     userInfo:userData];
  return cellObj;
}

@end
