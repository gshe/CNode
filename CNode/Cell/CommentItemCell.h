//
//  NewsItemCell.h
//  Floyd
//
//  Created by admin on 16/1/8.
//  Copyright © 2016年 George She. All rights reserved.
//

#import "FDTableViewCell.h"
#import "TopicInfoModel.h"
@protocol CommentItemCellDelegate;

@interface CommentItemCellUserData : NSObject
@property(nonatomic, strong) ReplyInfoModel *reply;
@property(nonatomic, weak) id<CommentItemCellDelegate> delegate;
@end

@interface CommentItemCell : FDTableViewCell
@property(nonatomic, strong) CommentItemCellUserData *userData;

+ (NICellObject *)createObject:(id)_delegate userData:(id)_userData;
@end

@protocol CommentItemCellDelegate <NSObject>
- (void)commentCell:(CommentItemCell *)cell
     upImageClicked:(CommentItemCellUserData *)userData;
@end