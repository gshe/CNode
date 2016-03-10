//
//  TopicManager.h
//  CNode
//
//  Created by George She on 16/3/7.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopicListModel.h"

typedef void (^TopicManagerRequestCompletedBlock)(id data, NSError *error);

@interface TopicManager : NSObject
+ (instancetype)sharedInstance;
- (void)requestTopicWithPage:(NSInteger)pageIndex
                countPerPage:(NSInteger)countPerPage
                         tab:(NSString *)tab
              completedBlock:(TopicManagerRequestCompletedBlock)completedBlock;

- (void)requestTopicDetailWithId:(NSString *)topicId
                  completedBlock:
                      (TopicManagerRequestCompletedBlock)completedBlock;

- (void)collectTopic:(NSString *)topicId
      completedBlock:(TopicManagerRequestCompletedBlock)completedBlock;

- (void)decollectTopic:(NSString *)topicId
        completedBlock:(TopicManagerRequestCompletedBlock)completedBlock;

- (void)upOrDownTheReply:(NSString *)replyId
          completedBlock:(TopicManagerRequestCompletedBlock)completedBlock;

- (void)publicTopic:(NSString *)title
                tab:(NSString *)tab
            content:(NSString *)content
     completedBlock:(TopicManagerRequestCompletedBlock)completedBlock;

- (void)writeCommentToTopic:(NSString *)topicId
                    replyId:(NSString *)replyId
                    content:(NSString *)comment
             completedBlock:(TopicManagerRequestCompletedBlock)completedBlock;
@end
