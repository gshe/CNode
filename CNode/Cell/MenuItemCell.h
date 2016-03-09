//
//  LeftItemCell.h
//  CNode
//
//  Created by George She on 16/3/9.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "FDTableViewCell.h"
#import "MenuItemModel.h"

@interface MenuItemCellUserData : NSObject
@property(nonatomic, strong) MenuItemModel *menuItem;
@end

@interface MenuItemCell : FDTableViewCell
@property(nonatomic, strong) MenuItemCellUserData *userData;

+ (NICellObject *)createObject:(id)_delegate userData:(id)_userData;
@end
