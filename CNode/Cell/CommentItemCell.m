//
//  NewsItemCell.m
//  Floyd
//
//  Created by admin on 16/1/8.
//  Copyright © 2016年 George She. All rights reserved.
//

#import "CommentItemCell.h"
@implementation CommentItemCellUserData
@end

@interface CommentItemCell ()
@property(nonatomic, strong) UILabel *authorName;
@property(nonatomic, strong) UIImageView *authorAvatar;
@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UILabel *pubDate;
@property(nonatomic, strong) UILabel *upsCount;
@property(nonatomic, strong) UIImageView *upsImageView;
@end

@implementation CommentItemCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.contentView.backgroundColor = [UIColor whiteColor];

    self.title = [UILabel new];
    self.title.font = Font_13_B;
    self.title.numberOfLines = 0;
    self.title.textColor = [UIColor ex_mainTextColor];
    self.title.textAlignment = NSTextAlignmentLeft;

    self.authorName = [UILabel new];
    self.authorName.font = Font_13;
    self.authorName.textColor = [UIColor ex_subTextColor];
    self.authorName.numberOfLines = 0;
    self.authorName.lineBreakMode = NSLineBreakByWordWrapping;
    self.authorName.textAlignment = NSTextAlignmentLeft;

    self.pubDate = [UILabel new];
    self.pubDate.font = Font_12;
    self.pubDate.textColor = [UIColor ex_subTextColor];
    self.pubDate.textAlignment = NSTextAlignmentRight;

    self.authorAvatar = [[UIImageView alloc] init];
    self.authorAvatar.image = [UIImage imageNamed:@"new"];
    self.authorAvatar.layer.cornerRadius = 22;
    self.authorAvatar.layer.borderWidth = 1;
    self.authorAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    self.authorAvatar.clipsToBounds = YES;

    self.upsCount = [UILabel new];
    self.upsCount.font = Font_12;
    self.upsCount.textColor = [UIColor ex_subTextColor];
    self.upsCount.textAlignment = NSTextAlignmentRight;

    self.upsImageView = [[UIImageView alloc] init];
    self.upsImageView.image = [UIImage imageNamed:@"thumb_up"];

    self.clipsToBounds = YES;
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.authorName];
    [self.contentView addSubview:self.pubDate];
    [self.contentView addSubview:self.authorAvatar];
    [self.contentView addSubview:self.upsImageView];
    [self.contentView addSubview:self.upsCount];
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
    make.right.lessThanOrEqualTo(self.upsImageView.mas_left).offset(-15);
  }];

  [self.upsCount mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.upsImageView);
    make.right.equalTo(self.contentView).offset(-15);
  }];

  [self.upsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.authorAvatar);
    make.right.equalTo(self.upsCount.mas_left).offset(-5);
    make.height.mas_equalTo(18);
    make.width.mas_equalTo(18);
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
  self.pubDate.text = nil;
}

+ (CGFloat)heightForObject:(id)object
               atIndexPath:(NSIndexPath *)indexPath
                 tableView:(UITableView *)tableView {
  CGFloat height = 54;
  NICellObject *obj = object;
  CommentItemCellUserData *userData = (CommentItemCellUserData *)obj.userInfo;
  CGFloat maxWidth = tableView.frame.size.width - 30 - 44 - 15;

  CGFloat titleHeight = [userData.reply.content
      lineBreakSizeOfStringwithFont:Font_13
                           maxwidth:maxWidth
                      lineBreakMode:NSLineBreakByWordWrapping];
  if (titleHeight > 20) {
    height += titleHeight - 20;
  }
  return height;
}

- (BOOL)shouldUpdateCellWithObject:(NICellObject *)object {
  self.userData = (CommentItemCellUserData *)object.userInfo;
  if (self.userData.reply.title) {
    self.title.text = self.userData.reply.title;
  } else {
    self.title.text = self.userData.reply.content;
  }

  self.authorName.text = self.userData.reply.author_loginname;
  self.upsCount.text =
      [NSString stringWithFormat:@"%ld", self.userData.reply.ups.count];
  [self.authorAvatar
      sd_setImageWithURL:[NSURL URLWithString:self.userData.reply
                                                  .author_avatar_url]
        placeholderImage:[UIImage imageNamed:@"avatar_default"]];
  [self setNeedsLayout];
  return YES;
}

+ (NICellObject *)createObject:(id)_delegate userData:(id)_userData {
  CommentItemCellUserData *userData = [[CommentItemCellUserData alloc] init];
  NICellObject *cellObj =
      [[NICellObject alloc] initWithCellClass:[CommentItemCell class]
                                     userInfo:userData];
  return cellObj;
}

@end
