//
//  NewsItemCell.m
//  Floyd
//
//  Created by admin on 16/1/8.
//  Copyright © 2016年 George She. All rights reserved.
//

#import "TopicItemCell.h"
@implementation TopicItemCellUserData
@end

@interface TopicItemCell ()
@property(nonatomic, strong) UILabel *authorName;
@property(nonatomic, strong) UIImageView *authorAvatar;
@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UILabel *tab;
@property(nonatomic, strong) UILabel *pubDate;
@property(nonatomic, strong) UILabel *commentInfoLabel;
@end

@implementation TopicItemCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.contentView.backgroundColor = [UIColor whiteColor];

    self.title = [UILabel new];
    self.title.font = Font_15_B;
    self.title.numberOfLines = 0;
    self.title.textColor = [UIColor ex_mainTextColor];
    self.title.textAlignment = NSTextAlignmentLeft;

    self.tab = [UILabel new];
    self.tab.font = Font_13;
    self.tab.textColor = [UIColor whiteColor];
    self.tab.textAlignment = NSTextAlignmentCenter;
    self.tab.backgroundColor = [UIColor ex_greenTextColor];
    self.tab.layer.cornerRadius = 4;
    self.tab.clipsToBounds = YES;

    self.authorName = [UILabel new];
    self.authorName.font = Font_13;
    self.authorName.textColor = [UIColor ex_subTextColor];
    self.authorName.numberOfLines = 0;
    self.authorName.lineBreakMode = NSLineBreakByWordWrapping;
    self.authorName.textAlignment = NSTextAlignmentLeft;

    self.pubDate = [UILabel new];
    self.pubDate.font = Font_12;
    self.pubDate.textColor = [UIColor ex_subTextColor];
    self.pubDate.textAlignment = NSTextAlignmentLeft;

    self.commentInfoLabel = [UILabel new];
    self.commentInfoLabel.font = Font_12;
    self.commentInfoLabel.textColor = [UIColor ex_subTextColor];
    self.commentInfoLabel.textAlignment = NSTextAlignmentLeft;

    self.authorAvatar = [[UIImageView alloc] init];
    self.authorAvatar.image = [UIImage imageNamed:@"new"];
    self.authorAvatar.layer.cornerRadius = 22;
    self.authorAvatar.layer.borderWidth = 1;
    self.authorAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    self.authorAvatar.clipsToBounds = YES;

    self.clipsToBounds = YES;
    [self.contentView addSubview:self.tab];
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.authorName];
    [self.contentView addSubview:self.pubDate];
    [self.contentView addSubview:self.commentInfoLabel];

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

  [self.tab mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.authorAvatar);
    make.right.equalTo(self.contentView.mas_right).offset(-15);
    make.width.mas_equalTo(40);
    make.height.mas_equalTo(18);
  }];

  [self.authorName mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.authorAvatar);
    make.left.equalTo(self.authorAvatar.mas_right).offset(15);
    make.right.lessThanOrEqualTo(self.contentView).offset(-15);
  }];

  [self.pubDate mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.contentView).offset(-5);
    make.left.equalTo(self.title);
    make.right.equalTo(self.commentInfoLabel.mas_left).offset(-15);
  }];

  [self.commentInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.contentView).offset(-5);
    make.right.equalTo(self.contentView).offset(-15);
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
  self.commentInfoLabel.text = nil;
  self.tab.text = nil;
}

+ (CGFloat)heightForObject:(id)object
               atIndexPath:(NSIndexPath *)indexPath
                 tableView:(UITableView *)tableView {
  CGFloat height = 74;
  NICellObject *obj = object;
  TopicItemCellUserData *userData = (TopicItemCellUserData *)obj.userInfo;
  CGFloat maxWidth = tableView.frame.size.width - 30 - 44 - 15;

  CGFloat titleHeight = [userData.topic.title
      lineBreakSizeOfStringwithFont:Font_15_B
                           maxwidth:maxWidth
                      lineBreakMode:NSLineBreakByWordWrapping];
  if (titleHeight > 20) {
    height += titleHeight - 20;
  }
  return height;
}

- (BOOL)shouldUpdateCellWithObject:(NICellObject *)object {
  self.userData = (TopicItemCellUserData *)object.userInfo;
  self.title.text = self.userData.topic.title;
  self.authorName.text = self.userData.topic.author_loginname;
  if (self.userData.topic.create_at) {
    self.pubDate.text = timeStringFromNow(self.userData.topic.create_at);
  } else {
    self.pubDate.text = timeStringFromNow(self.userData.topic.last_reply_at);
  }
  if (self.userData.topic.visit_count == 0) {
    self.commentInfoLabel.hidden = YES;
  } else {
    self.commentInfoLabel.hidden = NO;
    self.commentInfoLabel.text =
        [NSString stringWithFormat:@"%ld/%ld", self.userData.topic.reply_count,
                                   self.userData.topic.visit_count];
  }
  [self.authorAvatar
      sd_setImageWithURL:[NSURL URLWithString:self.userData.topic
                                                  .author_avatar_url]
        placeholderImage:[UIImage imageNamed:@"avatar_default"]];
  [self dealTab];
  [self setNeedsLayout];
  return YES;
}

- (void)dealTab {
  self.tab.hidden = NO;
  if (self.userData.topic.top) {
    self.tab.text = @"置顶";
    self.tab.backgroundColor = RGBACOLOR(128, 188, 1, 1);
    self.tab.textColor = [UIColor whiteColor];
  } else if (self.userData.topic.good) {
    self.tab.text = @"精华";
    self.tab.backgroundColor = RGBACOLOR(128, 188, 1, 1);
    self.tab.textColor = [UIColor whiteColor];
  } else {
    if (self.userData.topic.tab) {
      self.tab.text = self.userData.topic.tab;
      self.tab.backgroundColor = RGBACOLOR(229, 229, 229, 1);
      self.tab.textColor = [UIColor ex_subTextColor];
    } else {
      self.tab.hidden = YES;
    }
  }
}

+ (NICellObject *)createObject:(id)_delegate userData:(id)_userData {
  TopicItemCellUserData *userData = [[TopicItemCellUserData alloc] init];
  NICellObject *cellObj =
      [[NICellObject alloc] initWithCellClass:[TopicItemCell class]
                                     userInfo:userData];
  return cellObj;
}

@end
