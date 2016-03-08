//
//  DetailViewController.h
//  CNode
//
//  Created by George She on 16/3/7.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "FDViewController.h"
#import "TopicInfoModel.h"

@interface DetailViewController : FDViewController
@property(nonatomic, strong) NSString *topicId;
@property(nonatomic, strong) NSArray *topicIdList;
@end
