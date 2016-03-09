//
//  RecommendersView.m
//  ZhihuDaily
//
//  Created by George She on 16/2/26.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "RecommendersView.h"
@interface RecommendersView ()
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *loginNameLabel;
@property(nonatomic, strong) UIImageView *authorAvatar;
@end

@implementation RecommendersView
- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor ex_globalBackgroundColor];
    _nameLabel = [UILabel new];
    _nameLabel.text = @"作者";
    _nameLabel.textColor = [UIColor ex_subTextColor];
    _loginNameLabel = [UILabel new];
    _loginNameLabel.textColor = [UIColor ex_greenTextColor];

    _authorAvatar = [[UIImageView alloc] init];
    _authorAvatar.image = [UIImage imageNamed:@"Contact"];
    _authorAvatar.layer.cornerRadius = 22;
    _authorAvatar.layer.borderWidth = 1;
    _authorAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    _authorAvatar.clipsToBounds = YES;

    [self addSubview:_nameLabel];
    [self addSubview:_loginNameLabel];
    [self addSubview:_authorAvatar];

    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self).offset(15);
      make.centerY.equalTo(self);
    }];

    [_authorAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(_nameLabel.mas_right).offset(15);
      make.centerY.equalTo(self);
      make.width.mas_equalTo(44);
      make.height.mas_equalTo(44);
    }];

    [_loginNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(_authorAvatar.mas_right).offset(15);
      make.centerY.equalTo(self);
    }];
  }
  return self;
}

- (void)setAuthor:(NSString *)author {
  _author = author;
  [self configUI];
}

- (void)setAuthorUrl:(NSString *)authorUrl {
  _authorUrl = authorUrl;
  [self configUI];
}

- (void)configUI {
  self.loginNameLabel.text = _author;
  [self.authorAvatar sd_setImageWithURL:[NSURL URLWithString:_authorUrl]
                       placeholderImage:[UIImage imageNamed:@"Contact"]];
}

@end
