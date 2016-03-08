//
//  TopicListModel.h
//  CNode
//
//  Created by George She on 16/3/7.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "TopicInfoModel.h"

@interface TopicListModel : JSONModel
@property(nonatomic, strong) NSArray<TopicInfoModel> *data;
@end
