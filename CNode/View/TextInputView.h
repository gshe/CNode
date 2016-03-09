//
//  TextInputView.h
//  CNode
//
//  Created by George She on 16/3/9.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "PopupBaseView.h"
typedef void (^TextInputViewEnd)(NSString *inputText);

@interface TextInputView : PopupBaseView
@property(nonatomic, copy) NSString *placeholder;
@property(nonatomic, copy) TextInputViewEnd textInputViewEnd;
@end
