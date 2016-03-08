//
//  LoginViewController.m
//  ZhihuDaily
//
//  Created by George She on 16/3/1.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "LoginViewController.h"
#import "SubLBXScanViewController.h"

@interface LoginViewController () <SubLBXScanViewControllerDelegate>
@property(nonatomic, strong) UIButton *scanCodeLogin;
@property(nonatomic, strong) UIButton *inputTokenLogin;
@end

@implementation LoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                           target:self
                           action:@selector(closeVC:)];
  self.title = @"用户登录";
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(loginStatusChanged)
             name:kLoginStatusChanged
           object:nil];

  [self configUI];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loginStatusChanged {
  [self hideAllHUDs];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)configUI {
  self.view.backgroundColor = [UIColor ex_blueTextColor];
  UILabel *loginMessage = [UILabel new];
  loginMessage.text = @"选择你的登录方式";
  loginMessage.textColor = [UIColor whiteColor];
  [self.view addSubview:loginMessage];
  UIImageView *logoView = [[UIImageView alloc] init];
  logoView.layer.cornerRadius = 4;
  logoView.image = [UIImage imageNamed:@"about"];
  [self.view addSubview:logoView];

  _scanCodeLogin = [UIButton buttonWithType:UIButtonTypeCustom];
  _scanCodeLogin.backgroundColor = [UIColor ex_separatorLineColor];
  _scanCodeLogin.layer.cornerRadius = 4;
  [_scanCodeLogin setTitleColor:[UIColor ex_subTextColor]
                       forState:UIControlStateNormal];
  [_scanCodeLogin setTitle:@"扫码登录" forState:UIControlStateNormal];
  [_scanCodeLogin addTarget:self
                     action:@selector(scanCodePressed:)
           forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_scanCodeLogin];
  _inputTokenLogin = [UIButton buttonWithType:UIButtonTypeCustom];
  _inputTokenLogin.layer.cornerRadius = 4;
  [_inputTokenLogin setTitle:@"手动输入" forState:UIControlStateNormal];
  _inputTokenLogin.backgroundColor = [UIColor ex_separatorLineColor];
  [_inputTokenLogin setTitleColor:[UIColor ex_subTextColor]
                         forState:UIControlStateNormal];
  [_inputTokenLogin addTarget:self
                       action:@selector(inputTokenPressed:)
             forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_inputTokenLogin];
  [_scanCodeLogin mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.bottom.equalTo(_inputTokenLogin.mas_top).offset(-10);
    make.width.mas_equalTo(260);
    make.height.mas_equalTo(45);
  }];

  [_inputTokenLogin mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.bottom.equalTo(self.view).offset(-60);
    make.width.mas_equalTo(260);
    make.height.mas_equalTo(45);
  }];

  [loginMessage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.bottom.equalTo(_scanCodeLogin.mas_top).offset(-15);
  }];

  [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.top.equalTo(self.view).offset(100);
    make.width.mas_equalTo(200);
    make.height.mas_equalTo(76);
  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)closeVC:(id)sender {
  [self dismissViewControllerAnimated:YES
                           completion:^{

                           }];
}

- (void)scanCodePressed:(id)sender {
  //设置扫码区域参数设置

  //创建参数对象
  LBXScanViewStyle *style = [[LBXScanViewStyle alloc] init];

  //矩形区域中心上移，默认中心点为屏幕中心点
  style.centerUpOffset = 44;

  //扫码框周围4个角的类型,设置为外挂式
  style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;

  //扫码框周围4个角绘制的线条宽度
  style.photoframeLineW = 6;

  //扫码框周围4个角的宽度
  style.photoframeAngleW = 24;

  //扫码框周围4个角的高度
  style.photoframeAngleH = 24;

  //扫码框内 动画类型 --线条上下移动
  style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;

  //线条上下移动图片
  style.animationImage =
      [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];

  // SubLBXScanViewController继承自LBXScanViewController
  //添加一些扫码或相册结果处理
  SubLBXScanViewController *vc = [SubLBXScanViewController new];
  vc.style = style;
  vc.delegate = self;
  // vc.isQQSimulator = YES;
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma SubLBXScanViewControllerDelegate
- (void)QRCodeScanned:(NSString *)token {
  [self showHUD];
  [[UserManager sharedInstance]
         verifyToken:token
      completedBlock:^(id data, NSError *error) {
		  if (error){
			  [self showError:error];
		  }
	  }
      ];
}

- (void)inputTokenPressed:(id)sender{
	
}
@end
