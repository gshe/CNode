//
//  MenuItemModel.h
//  CNode
//
//  Created by George She on 16/3/9.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, MenuItemType) {
  MenuItemType_All,
  MenuItemType_Ask,
  MenuItemType_Job,
  MenuItemType_Share,
  MenuItemType_Good,
  MenuItemType_Message,
};

@interface MenuItemModel : NSObject
@property(nonatomic, strong) NSString *tab;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *image;
@property(nonatomic, assign) MenuItemType menuType;
@property(nonatomic, assign) NSInteger badgeCount;
@property(nonatomic, assign) BOOL isSelected;
@end
