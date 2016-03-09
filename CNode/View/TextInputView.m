//
//  TextInputView.m
//  CNode
//
//  Created by George She on 16/3/9.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "TextInputView.h"
@interface TextInputView () <UITextFieldDelegate>
@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, strong) UITextField *textInputField;
@property(nonatomic, strong) UIButton *btnDone;
@property(nonatomic, strong) UIButton *btnCancel;
@end

@implementation TextInputView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
    [self addEvent];
    [self makeUI];
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(keyboardWillShow:)
               name:UIKeyboardWillShowNotification
             object:nil];
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(keyboardWillHide:)
               name:UIKeyboardWillHideNotification
             object:nil];
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(keyboardWillShow:)
               name:UIKeyboardWillChangeFrameNotification
             object:nil];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notif {
  NSDictionary *info = [notif userInfo];
  NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
  CGSize keyboardSize = [value CGRectValue].size;
  CGFloat keyboardheight = MIN(keyboardSize.height, keyboardSize.width);
  if (keyboardheight > 0) {
    [self compressFrameHeight:keyboardheight];
  }
}

- (void)keyboardWillHide:(NSNotification *)notif {
  [self compressFrameHeight:0];
}

- (void)compressFrameHeight:(CGFloat)frameHeight {
  [UIView animateWithDuration:0.5
      animations:^{
        CGRect frame = self.containerView.frame;
        frame.origin.y = HEIGHT(self) - 100 - frameHeight;
        self.containerView.frame = frame;
      }
      completion:^(BOOL finished){

      }];
}

- (void)makeUI {
  _containerView = [[UIView alloc]
      initWithFrame:CGRectMake(0, HEIGHT(self), WIDTH(self), 100)];
  _containerView.backgroundColor = [UIColor whiteColor];
  _containerView.layer.cornerRadius = 2;
  _containerView.layer.masksToBounds = YES;
  [self addSubview:_containerView];
  UIView *actionView = [UIView new];
  actionView.backgroundColor = [UIColor ex_globalBackgroundColor];
  [_containerView addSubview:actionView];
  _btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
  [_btnDone setTitleColor:[UIColor ex_blueTextColor]
                 forState:UIControlStateNormal];
  [_btnDone setTitle:@"确定" forState:UIControlStateNormal];
  [_btnDone addTarget:self
                action:@selector(doneAction:)
      forControlEvents:UIControlEventTouchUpInside];
  [actionView addSubview:_btnDone];

  _btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
  [_btnCancel setTitleColor:[UIColor lightGrayColor]
                   forState:UIControlStateNormal];
  [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
  [_btnCancel addTarget:self
                 action:@selector(cancelAction:)
       forControlEvents:UIControlEventTouchUpInside];
  [actionView addSubview:_btnCancel];
  [actionView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(_containerView);
    make.top.equalTo(_containerView);
    make.height.mas_equalTo(40);
  }];

  [_btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(actionView).offset(15);
    make.top.equalTo(actionView).offset(5);
    make.height.mas_equalTo(40);
  }];

  [_btnDone mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(actionView).offset(-15);
    make.top.equalTo(actionView).offset(5);
    make.height.mas_equalTo(40);
  }];

  _textInputField = [UITextField new];
  _textInputField.returnKeyType = UIReturnKeyDone;
  _textInputField.delegate = self;
  [_containerView addSubview:_textInputField];
  [_textInputField mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(_containerView).offset(15);
    make.right.equalTo(_containerView).offset(-15);
    make.top.equalTo(actionView.mas_bottom).offset(15);
  }];
}

- (void)setPlaceholder:(NSString *)placeholder {
  _textInputField.placeholder = placeholder;
}

#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [_textInputField resignFirstResponder];
  return YES;
}

#pragma mark - Action
- (void)show {
  [super show];
  CGRect blockViewRect = _containerView.frame;
  blockViewRect.origin.y -= 100;
  [UIView animateWithDuration:0.25
                   animations:^{
                     _containerView.frame = blockViewRect;
                   }];
}

- (void)dismiss {
  CGRect blockViewRect = _containerView.frame;
  blockViewRect.origin.y = HEIGHT(self);
  [UIView animateWithDuration:0.25
      animations:^{
        _containerView.frame = blockViewRect;
      }
      completion:^(BOOL finished) {
        [super dismiss];
      }];
}

- (void)doneAction:(UIButton *)btn {
  if (self.textInputViewEnd) {
    self.textInputViewEnd(_textInputField.text);
  }
  [self dismiss];
}

- (void)cancelAction:(UIButton *)btn {
  [self dismiss];
}

@end
