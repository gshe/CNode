//
//  LeftItemCell.h
//  CNode
//
//  Created by George She on 16/3/9.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "FDTableViewCell.h"
@interface LeftItemCellUserData : NSObject
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *image;
@end

@interface LeftItemCell : FDTableViewCell
@property(nonatomic, strong) LeftItemCellUserData *userData;

+ (NICellObject *)createObject:(id)_delegate userData:(id)_userData;
@end
