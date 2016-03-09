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
@property(nonatomic, strong) UIButton *upsBtnView;
@end

@implementation CommentItemCell
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

    self.upsBtnView = [[UIButton alloc] init];
    [self.upsBtnView addTarget:self
                        action:@selector(upButtonPressed:)
              forControlEvents:UIControlEventTouchUpInside];
    self.clipsToBounds = YES;
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.authorName];
    [self.contentView addSubview:self.pubDate];
    [self.contentView addSubview:self.authorAvatar];
    [self.contentView addSubview:self.upsBtnView];
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
    make.right.lessThanOrEqualTo(self.upsBtnView.mas_left).offset(-15);
  }];

  [self.upsCount mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.upsBtnView);
    make.right.equalTo(self.contentView).offset(-15);
  }];

  [self.upsBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
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

  [self.pubDate mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.contentView).offset(-5);
    make.left.equalTo(self.title);
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
  CGFloat height = 64;
  return height;
}

- (BOOL)shouldUpdateCellWithObject:(NICellObject *)object {
  self.userData = (CommentItemCellUserData *)object.userInfo;
  if (self.userData.reply.title) {
    self.title.text = self.userData.reply.title;
  } else {
    NSAttributedString *attrStr = [[NSAttributedString alloc]
              initWithData:[self.userData.reply.content
                               dataUsingEncoding:NSUnicodeStringEncoding]
                   options:@{
                     NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType
                   }
        documentAttributes:nil
                     error:nil];
    self.title.attributedText = attrStr;
  }

  if ([[UserManager sharedInstance] isUserUpTheReplay:self.userData.reply]) {
    [self.upsBtnView setImage:[UIImage imageNamed:@"thumb_x"]
                     forState:UIControlStateNormal];
  } else {
    [self.upsBtnView setImage:[UIImage imageNamed:@"thumb_up"]
                     forState:UIControlStateNormal];
  }

  if (self.userData.reply.create_at) {
    self.pubDate.hidden = NO;
    self.pubDate.text = timeStringFromNow(self.userData.reply.create_at);
  } else {
    self.pubDate.hidden = YES;
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
- (void)upButtonPressed:(id)sender {
  if ([self.userData.delegate
          respondsToSelector:@selector(commentCell:upImageClicked:)]) {
    [self.userData.delegate commentCell:self upImageClicked:self.userData];
  }
}

+ (NICellObject *)createObject:(id)_delegate userData:(id)_userData {
  CommentItemCellUserData *userData = [[CommentItemCellUserData alloc] init];
  NICellObject *cellObj =
      [[NICellObject alloc] initWithCellClass:[CommentItemCell class]
                                     userInfo:userData];
  return cellObj;
}

@end
