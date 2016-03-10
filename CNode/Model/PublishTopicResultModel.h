//
//  PublicTopicResultModel.h
//  CNode
//
//  Created by George She on 16/3/10.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PublishTopicResultModel : JSONModel
@property(nonatomic, assign) BOOL success;
@property(nonatomic, strong) NSString *topic_id;
@property(nonatomic, strong) NSString *error_msg;
@end
