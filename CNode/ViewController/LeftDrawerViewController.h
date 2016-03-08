//
//  LeftDrawerViewController.h
//  ZhihuDaily
//
//  Created by George She on 16/2/24.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftDrawerViewControllerDelegate <NSObject>
- (void)channelSelected:(UIViewController *)channelVC;
@end

@interface LeftDrawerViewController : UIViewController
@property(nonatomic, weak) id<LeftDrawerViewControllerDelegate> delegate;
@end
