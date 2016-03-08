//
//  NewsItemCell.h
//  Floyd
//
//  Created by admin on 16/1/8.
//  Copyright © 2016年 George She. All rights reserved.
//

#import "FDTableViewCell.h"
#import "TopicInfoModel.h"

@interface TopicItemCellUserData : NSObject
@property(nonatomic, strong) TopicInfoModel *topic;
@end

@interface TopicItemCell : FDTableViewCell
@property(nonatomic, strong) TopicItemCellUserData *userData;

+ (NICellObject *)createObject:(id)_delegate userData:(id)_userData;
@end
