//
//  VerifyTokenResult.h
//  CNode
//
//  Created by George She on 16/3/8.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface VerifyTokenResult : JSONModel
@property(nonatomic, assign) BOOL success;
@property(nonatomic, strong) NSString *loginname;
@end
