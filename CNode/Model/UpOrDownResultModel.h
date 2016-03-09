//
//  UpOrDownResultModel.h
//  CNode
//
//  Created by George She on 16/3/9.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface UpOrDownResultModel : JSONModel
@property(nonatomic, assign) BOOL success;
@property(nonatomic, strong) NSString *action;
@property(nonatomic, strong) NSString *error_msg;
@end
