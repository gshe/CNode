//
//  FilterView.h
//  CNode
//
//  Created by George She on 16/3/8.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "PopupBaseView.h"

typedef void (^FilterTabSelected)(NSString *selectedTab);

@interface FilterView : PopupBaseView
@property(nonatomic, copy) FilterTabSelected selectedTabBlock;
@end
